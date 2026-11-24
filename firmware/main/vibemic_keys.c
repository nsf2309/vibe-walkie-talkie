#include "vibemic_keys.h"
#include "board_pins.h"
#include "vibemic_protocol.h"

#include "driver/gpio.h"
#include "esp_rom_sys.h"
#include "esp_timer.h"
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"

#include <string.h>

#define DEBOUNCE_US           40000
#define REARM_US              20000
#define LONG_PRESS_US         600000
#define DOUBLE_CLICK_US       350000

typedef struct {
    uint8_t id;
    bool stable;
    bool raw_candidate;
    int64_t raw_since_us;
    int64_t last_edge_us;
    int64_t down_us;
    int64_t last_click_us;
    int click_count;
} key_state_t;

static vibemic_ptt_cb_t s_ptt_cb;
static vibemic_button_cb_t s_btn_cb;
static void *s_user;
static key_state_t s_ptt;
static key_state_t s_keys[VIBEMIC_BUTTON_COUNT];

/* 4x5 matrix -> logical key id (0 = unused spare). */
static const uint8_t s_matrix_map[PIN_MX_ROWS][PIN_MX_COLS] = {
    { VIBEMIC_KEY_UP,   VIBEMIC_KEY_LEFT, VIBEMIC_KEY_RIGHT, VIBEMIC_KEY_DOWN, VIBEMIC_KEY_OK },
    { VIBEMIC_KEY_VOL_UP, VIBEMIC_KEY_VOL_DOWN, VIBEMIC_KEY_BACK, VIBEMIC_KEY_HOME, VIBEMIC_KEY_MENU },
    { VIBEMIC_KEY_F1, VIBEMIC_KEY_F2, VIBEMIC_KEY_F3, VIBEMIC_KEY_F4, VIBEMIC_KEY_F5 },
    { VIBEMIC_KEY_F6, 0, 0, 0, 0 },
};

static const int s_rows[PIN_MX_ROWS] = {
    PIN_MX_ROW0, PIN_MX_ROW1, PIN_MX_ROW2, PIN_MX_ROW3,
};
static const int s_cols[PIN_MX_COLS] = {
    PIN_MX_COL0, PIN_MX_COL1, PIN_MX_COL2, PIN_MX_COL3, PIN_MX_COL4,
};

static void cfg_input_pullup(int pin)
{
    gpio_config_t io = {
        .pin_bit_mask = 1ULL << pin,
        .mode = GPIO_MODE_INPUT,
        .pull_up_en = GPIO_PULLUP_ENABLE,
        .pull_down_en = GPIO_PULLDOWN_DISABLE,
        .intr_type = GPIO_INTR_DISABLE,
    };
    gpio_config(&io);
}

static void cfg_row_output(int pin)
{
    gpio_config_t io = {
        .pin_bit_mask = 1ULL << pin,
        .mode = GPIO_MODE_OUTPUT,
        .pull_up_en = GPIO_PULLUP_DISABLE,
        .pull_down_en = GPIO_PULLDOWN_DISABLE,
        .intr_type = GPIO_INTR_DISABLE,
    };
    gpio_config(&io);
    gpio_set_level(pin, 1);
}

static void key_reset(key_state_t *k, uint8_t id)
{
    memset(k, 0, sizeof(*k));
    k->id = id;
}

static bool debounce_step(key_state_t *k, bool raw, int64_t now, bool *out_pressed)
{
    if (raw != k->raw_candidate) {
        k->raw_candidate = raw;
        k->raw_since_us = now;
        return false;
    }
    if (raw == k->stable) {
        return false;
    }
    if ((now - k->raw_since_us) < DEBOUNCE_US) {
        return false;
    }
    if ((now - k->last_edge_us) < REARM_US) {
        return false;
    }
    k->stable = raw;
    k->last_edge_us = now;
    *out_pressed = raw;
    return true;
}

static void emit_btn(uint8_t id, uint8_t event)
{
    if (s_btn_cb) {
        s_btn_cb(id, event, s_user);
    }
}

static void on_key_edge(key_state_t *k, bool pressed, int64_t now)
{
    if (pressed) {
        k->down_us = now;
        emit_btn(k->id, VIBEMIC_BTN_DOWN);
        return;
    }

    const int64_t held = now - k->down_us;
    emit_btn(k->id, VIBEMIC_BTN_UP);
    if (held >= LONG_PRESS_US) {
        emit_btn(k->id, VIBEMIC_BTN_LONG);
        k->click_count = 0;
        return;
    }

    if (now - k->last_click_us < DOUBLE_CLICK_US) {
        k->click_count++;
    } else {
        k->click_count = 1;
    }
    k->last_click_us = now;
    if (k->click_count >= 2) {
        emit_btn(k->id, VIBEMIC_BTN_DOUBLE);
        k->click_count = 0;
    } else {
        emit_btn(k->id, VIBEMIC_BTN_CLICK);
    }
}

void vibemic_keys_init(vibemic_ptt_cb_t ptt_cb, vibemic_button_cb_t btn_cb, void *user)
{
    s_ptt_cb = ptt_cb;
    s_btn_cb = btn_cb;
    s_user = user;

    cfg_input_pullup(PIN_PTT);
    key_reset(&s_ptt, 0);

    for (int i = 0; i < VIBEMIC_BUTTON_COUNT; i++) {
        key_reset(&s_keys[i], (uint8_t)(i + 1));
    }

    for (int r = 0; r < PIN_MX_ROWS; r++) {
        cfg_row_output(s_rows[r]);
    }
    for (int c = 0; c < PIN_MX_COLS; c++) {
        cfg_input_pullup(s_cols[c]);
    }

    vTaskDelay(pdMS_TO_TICKS(5));
    s_ptt.stable = (gpio_get_level(PIN_PTT) == 0);
    s_ptt.raw_candidate = s_ptt.stable;
}

bool vibemic_keys_ptt_down(void)
{
    return s_ptt.stable;
}

static key_state_t *key_by_id(uint8_t id)
{
    if (id >= 1 && id <= VIBEMIC_BUTTON_COUNT) {
        return &s_keys[id - 1];
    }
    return NULL;
}

static void scan_matrix(int64_t now)
{
    bool pressed_now[VIBEMIC_BUTTON_COUNT + 1] = {0};

    for (int r = 0; r < PIN_MX_ROWS; r++) {
        for (int rr = 0; rr < PIN_MX_ROWS; rr++) {
            gpio_set_level(s_rows[rr], rr == r ? 0 : 1);
        }
        /* settle */
        esp_rom_delay_us(5);
        for (int c = 0; c < PIN_MX_COLS; c++) {
            const uint8_t id = s_matrix_map[r][c];
            if (id == 0) {
                continue;
            }
            if (gpio_get_level(s_cols[c]) == 0) {
                pressed_now[id] = true;
            }
        }
    }
    for (int rr = 0; rr < PIN_MX_ROWS; rr++) {
        gpio_set_level(s_rows[rr], 1);
    }

    for (uint8_t id = 1; id <= VIBEMIC_BUTTON_COUNT; id++) {
        key_state_t *k = key_by_id(id);
        if (!k) {
            continue;
        }
        bool pressed = false;
        if (debounce_step(k, pressed_now[id], now, &pressed)) {
            on_key_edge(k, pressed, now);
        }
    }
}

void vibemic_keys_poll(void)
{
    const int64_t now = esp_timer_get_time();
    bool pressed = false;

    if (debounce_step(&s_ptt, gpio_get_level(PIN_PTT) == 0, now, &pressed)) {
        if (s_ptt_cb) {
            s_ptt_cb(pressed, s_user);
        }
    }

    scan_matrix(now);
}
