#include "vibemic_audio.h"
#include "vibemic_keys.h"
#include "vibemic_protocol.h"
#include "board_pins.h"
#include "sdkconfig.h"

#include "esp_log.h"
#include "esp_timer.h"
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"

#include "driver/i2s_std.h"

#include <string.h>

static const char *TAG = "vm_audio";

static vibemic_audio_frame_cb_t s_cb;
static void *s_user;
static vibemic_adpcm_state_t s_adpcm;
static bool s_streaming;
static bool s_use_mic;
static bool s_tone_only; /* stop when tone ends unless PTT held */
static bool s_i2s_ok;
static bool s_mic_heard; /* saw non-silent energy at least once */
static uint8_t s_seq;
static int64_t s_tone_until_us;
static uint32_t s_phase;
static TaskHandle_t s_task;
static i2s_chan_handle_t s_rx;

static void fill_tone(int16_t *pcm, size_t n)
{
    const uint32_t step = (440u * 65536u) / VIBEMIC_SAMPLE_RATE_HZ;
    for (size_t i = 0; i < n; i++) {
        const int16_t tri = (int16_t)((int16_t)(s_phase >> 3) - 4096);
        pcm[i] = (int16_t)(tri * 2);
        s_phase += step;
    }
}

static void fill_silence(int16_t *pcm, size_t n)
{
    memset(pcm, 0, n * sizeof(int16_t));
}

#if CONFIG_VIBEMIC_USE_INMP441 && CONFIG_VIBEMIC_MIC_TONE_FALLBACK
static bool mic_frame_has_energy(const int16_t *pcm, size_t n)
{
    int32_t peak = 0;
    for (size_t i = 0; i < n; i++) {
        int32_t a = pcm[i];
        if (a < 0) {
            a = -a;
        }
        if (a > peak) {
            peak = a;
        }
    }
    /* INMP441 idle room noise is usually well above this after gain. */
    return peak > 80;
}
#endif

#if CONFIG_VIBEMIC_USE_INMP441
static esp_err_t i2s_mic_init(void)
{
    i2s_chan_config_t chan_cfg = I2S_CHANNEL_DEFAULT_CONFIG(I2S_NUM_AUTO, I2S_ROLE_MASTER);
    chan_cfg.auto_clear = true;
    esp_err_t err = i2s_new_channel(&chan_cfg, NULL, &s_rx);
    if (err != ESP_OK) {
        ESP_LOGE(TAG, "i2s_new_channel: %s", esp_err_to_name(err));
        return err;
    }

    /* INMP441: 24-bit data in 32-bit Philips slots, left channel (L/R→GND). */
    i2s_std_config_t std_cfg = {
        .clk_cfg = I2S_STD_CLK_DEFAULT_CONFIG(VIBEMIC_SAMPLE_RATE_HZ),
        .slot_cfg = I2S_STD_PHILIPS_SLOT_DEFAULT_CONFIG(I2S_DATA_BIT_WIDTH_32BIT, I2S_SLOT_MODE_MONO),
        .gpio_cfg = {
            .mclk = I2S_GPIO_UNUSED,
            .bclk = PIN_I2S_CLK,
            .ws = PIN_I2S_WS,
            .dout = I2S_GPIO_UNUSED,
            .din = PIN_I2S_DIN,
            .invert_flags = {
                .mclk_inv = false,
                .bclk_inv = false,
                .ws_inv = false,
            },
        },
    };
    std_cfg.slot_cfg.slot_mask = I2S_STD_SLOT_LEFT;

    err = i2s_channel_init_std_mode(s_rx, &std_cfg);
    if (err != ESP_OK) {
        ESP_LOGE(TAG, "i2s_channel_init_std_mode: %s", esp_err_to_name(err));
        i2s_del_channel(s_rx);
        s_rx = NULL;
        return err;
    }

    err = i2s_channel_enable(s_rx);
    if (err != ESP_OK) {
        ESP_LOGE(TAG, "i2s_channel_enable: %s", esp_err_to_name(err));
        i2s_del_channel(s_rx);
        s_rx = NULL;
        return err;
    }

    ESP_LOGI(TAG, "INMP441 I2S RX ready (BCLK=%d WS=%d DIN=%d @ %d Hz)",
             PIN_I2S_CLK, PIN_I2S_WS, PIN_I2S_DIN, VIBEMIC_SAMPLE_RATE_HZ);
    return ESP_OK;
}

static bool read_mic_pcm(int16_t *pcm, size_t n)
{
    if (!s_rx) {
        return false;
    }

    /* 32-bit slot samples from the MEMS mic. */
    int32_t raw[VIBEMIC_FRAME_SAMPLES];
    size_t bytes_read = 0;
    const esp_err_t err = i2s_channel_read(s_rx, raw, n * sizeof(int32_t), &bytes_read, pdMS_TO_TICKS(50));
    if (err != ESP_OK || bytes_read < n * sizeof(int32_t)) {
        return false;
    }

    for (size_t i = 0; i < n; i++) {
        /* INMP441 24-bit left-justified in 32-bit word → usable int16. */
        pcm[i] = (int16_t)(raw[i] >> 14);
    }
    return true;
}
#else
static esp_err_t i2s_mic_init(void)
{
    return ESP_ERR_NOT_SUPPORTED;
}

static bool read_mic_pcm(int16_t *pcm, size_t n)
{
    (void)pcm;
    (void)n;
    return false;
}
#endif

static void read_pcm(int16_t *pcm, size_t n)
{
    const int64_t now = esp_timer_get_time();
    if (now < s_tone_until_us) {
        fill_tone(pcm, n);
        return;
    }
    if (s_tone_only) {
        fill_silence(pcm, n);
        return;
    }

    if (s_i2s_ok && s_use_mic) {
            if (read_mic_pcm(pcm, n)) {
#if CONFIG_VIBEMIC_MIC_TONE_FALLBACK
                if (!s_mic_heard) {
                    if (mic_frame_has_energy(pcm, n)) {
                        s_mic_heard = true;
                        ESP_LOGI(TAG, "mic energy detected — live capture active");
                    } else {
                        fill_tone(pcm, n);
                        return;
                    }
                }
#endif
                return;
            }
        /* Transient I2S glitch: keep stream alive with silence rather than a tone blip. */
        fill_silence(pcm, n);
        return;
    }

    fill_tone(pcm, n);
}

static void audio_task(void *arg)
{
    (void)arg;
    int16_t pcm[VIBEMIC_FRAME_SAMPLES];
    uint8_t pkt[VIBEMIC_AUDIO_PKT_SIZE];
    const TickType_t frame_ticks = pdMS_TO_TICKS((VIBEMIC_FRAME_SAMPLES * 1000) / VIBEMIC_SAMPLE_RATE_HZ);

    while (true) {
        if (!s_streaming) {
            vTaskDelay(pdMS_TO_TICKS(20));
            continue;
        }

        /* Auto-stop one-shot test tone when finished and PTT not held. */
        if (s_tone_only && esp_timer_get_time() >= s_tone_until_us && !vibemic_keys_ptt_down()) {
            s_streaming = false;
            s_tone_only = false;
            continue;
        }

        const bool first = (s_seq == 0);
        read_pcm(pcm, VIBEMIC_FRAME_SAMPLES);
        pkt[0] = s_seq++;
        pkt[1] = 0;
        if (first) {
            pkt[1] |= VIBEMIC_AFLAG_SESSION_START | VIBEMIC_AFLAG_SYNC;
            vibemic_adpcm_reset(&s_adpcm);
        }
        vibemic_adpcm_encode(&s_adpcm, pcm, VIBEMIC_FRAME_SAMPLES, &pkt[2]);
        if (s_cb) {
            s_cb(pkt, sizeof(pkt), s_user);
        }
        vTaskDelay(frame_ticks);
    }
}

void vibemic_audio_init(vibemic_audio_frame_cb_t cb, void *user)
{
    s_cb = cb;
    s_user = user;
    vibemic_adpcm_reset(&s_adpcm);
    s_use_mic = true;
    s_mic_heard = false;

    if (i2s_mic_init() == ESP_OK) {
        s_i2s_ok = true;
#if CONFIG_VIBEMIC_MIC_TONE_FALLBACK
        ESP_LOGI(TAG, "mic pending — PTT uses tone until INMP441 signal appears");
#else
        ESP_LOGI(TAG, "mic capture enabled");
#endif
    } else {
        s_i2s_ok = false;
        ESP_LOGW(TAG, "I2S mic unavailable — PTT streams 440 Hz tone");
    }

    xTaskCreate(audio_task, "vm_audio", 4096, NULL, 5, &s_task);
}

void vibemic_audio_reset_codec(void)
{
    vibemic_adpcm_reset(&s_adpcm);
    s_seq = 0;
}

void vibemic_audio_set_streaming(bool on)
{
    if (on && !s_streaming) {
        vibemic_audio_reset_codec();
    }
    if (on) {
        s_tone_only = false; /* PTT / live path */
    }
    s_streaming = on;
}

void vibemic_audio_set_use_mic(bool on)
{
    s_use_mic = on;
    if (!on) {
        s_mic_heard = false;
    }
}

void vibemic_audio_request_test_tone(uint16_t duration_ms)
{
    if (duration_ms > 2000) {
        duration_ms = 2000;
    }
    s_tone_until_us = esp_timer_get_time() + (int64_t)duration_ms * 1000;
    s_tone_only = true;
    if (!s_streaming) {
        vibemic_audio_reset_codec();
        s_streaming = true;
    }
}

bool vibemic_audio_is_streaming(void)
{
    return s_streaming;
}
