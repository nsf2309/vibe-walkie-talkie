#include "vibemic_audio.h"
#include "vibemic_ble.h"
#include "vibemic_keys.h"
#include "vibemic_touchpad.h"
#include "board_pins.h"

#include "esp_log.h"
#include "nvs_flash.h"
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"

static const char *TAG = "vibemic";

static void on_audio_frame(const uint8_t *pkt, size_t len, void *user)
{
    (void)user;
    vibemic_ble_notify_audio(pkt, (uint16_t)len);
}

static void on_ptt(bool down, void *user)
{
    (void)user;
    ESP_LOGI(TAG, "PTT %s", down ? "down" : "up");
    vibemic_ble_set_ptt(down);
}

static void on_button(uint8_t id, uint8_t event, void *user)
{
    (void)user;
    ESP_LOGI(TAG, "button %u event %u", id, event);
    vibemic_ble_notify_button(id, event);
}

static void on_mouse(uint8_t buttons, int8_t dx, int8_t dy, int8_t wheel, void *user)
{
    (void)user;
    vibemic_ble_on_mouse(buttons, dx, dy, wheel);
}

void app_main(void)
{
    esp_err_t err = nvs_flash_init();
    if (err == ESP_ERR_NVS_NO_FREE_PAGES || err == ESP_ERR_NVS_NEW_VERSION_FOUND) {
        ESP_ERROR_CHECK(nvs_flash_erase());
        err = nvs_flash_init();
    }
    ESP_ERROR_CHECK(err);

    vibemic_audio_init(on_audio_frame, NULL);
    vibemic_touchpad_init(on_mouse, NULL);
    vibemic_keys_init(on_ptt, on_button, NULL);
    vibemic_ble_start();

    ESP_LOGI(TAG, "VibeMic firmware ready");
    ESP_LOGI(TAG, "pins: PTT=%d matrix %dx%d rows=%d,%d,%d,%d cols=%d,%d,%d,%d,%d mic BCLK=%d WS=%d DIN=%d",
             PIN_PTT, PIN_MX_ROWS, PIN_MX_COLS,
             PIN_MX_ROW0, PIN_MX_ROW1, PIN_MX_ROW2, PIN_MX_ROW3,
             PIN_MX_COL0, PIN_MX_COL1, PIN_MX_COL2, PIN_MX_COL3, PIN_MX_COL4,
             PIN_I2S_CLK, PIN_I2S_WS, PIN_I2S_DIN);
    ESP_LOGI(TAG, "keys: D-pad/OK/vol/back/home/menu/F1-F6 via matrix; PTT=%d active-low to GND", PIN_PTT);
    while (true) {
        vibemic_keys_poll();
        vibemic_touchpad_poll();
        vTaskDelay(pdMS_TO_TICKS(10));
    }
}