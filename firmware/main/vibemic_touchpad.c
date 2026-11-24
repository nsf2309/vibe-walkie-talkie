#include "vibemic_touchpad.h"
#include "board_pins.h"

#include "esp_log.h"
#include "esp_timer.h"

#include <stdlib.h>

static const char *TAG = "vm_tp";

static vibemic_mouse_cb_t s_cb;
static void *s_user;
static bool s_enabled;
static bool s_audio_priority;
static bool s_present;
static int64_t s_last_report_us;

void vibemic_touchpad_init(vibemic_mouse_cb_t cb, void *user)
{
    s_cb = cb;
    s_user = user;
    /* Phase 2: probe GT911 (or similar) on I2C. Until hardware is present, mark absent. */
    s_present = false;
    s_enabled = false;
    ESP_LOGI(TAG, "touchpad stub (I2C SDA=%d SCL=%d IRQ=%d) — not present", PIN_I2C_SDA, PIN_I2C_SCL, PIN_TP_IRQ);
}

void vibemic_touchpad_set_enabled(bool on)
{
    s_enabled = on && s_present;
}

void vibemic_touchpad_set_audio_priority(bool on)
{
    s_audio_priority = on;
}

bool vibemic_touchpad_present(void)
{
    return s_present;
}

void vibemic_touchpad_poll(void)
{
    if (!s_enabled || !s_cb) {
        return;
    }
    const int64_t now = esp_timer_get_time();
    /* Cap rate while streaming audio to reduce BLE contention. */
    const int64_t min_gap_us = s_audio_priority ? 50000 : 10000; /* 20 Hz vs 100 Hz */
    if (now - s_last_report_us < min_gap_us) {
        return;
    }
    s_last_report_us = now;

    /* When a real controller is wired, read dx/dy here. Stub emits nothing. */
    (void)s_user;
}

/* Test helper for host bring-up without hardware. */
void vibemic_touchpad_debug_inject(int8_t dx, int8_t dy, uint8_t buttons)
{
    if (s_cb) {
        s_cb(buttons, dx, dy, 0, s_user);
    }
}