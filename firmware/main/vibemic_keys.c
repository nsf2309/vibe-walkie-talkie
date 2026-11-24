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
/* Wait before starting voice so PTT+Vol squeeze can win. */
#define PTT_ARM_US            150000

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
static key_state_t s_keys[VIBEMIC_MATRIX_KEY_COUNT];

/* Physical layout (front): F4-F6 top, D-pad, Home/Back/Menu, F1-F3 bottom.
 * Sides: PTT (dedicated GPIO), Vol+/- (matrix, right side). */
static const uint8_t s_matrix_map[PIN_MX_ROWS][PIN_MX_COLS] = {
    { VIBEMIC_KEY_UP, VIBEMIC_KEY_LEFT, VIBEMIC_KEY_RIGHT, VIBEMIC_KEY_DOWN, VIBEMIC_KEY_OK },
    { VIBEMIC_KEY_HOME, VIBEMIC_KEY_BACK, VIBEMIC_KEY_MENU, VIBEMIC_KEY_VOL_UP, VIBEMIC_KEY_VOL_DOWN },
    { VIBEMIC_KEY_F4, VIBEMIC_KEY_F5, VIBEMIC_KEY_F6, 0, 0 },
    { VIBEMIC_KEY_F1, VIBEMIC_KEY_F2, VIBEMIC_KEY_F3, 0, 0 },
};

static const int s_rows[PIN_MX_ROWS] = {
    PIN_MX_ROW0, PIN_MX_ROW1, PIN_MX_ROW2, PIN_MX_ROW3,
};
static const int s_cols[PIN_MX_COLS] = {
    PIN_MX_COL0, PIN_MX_COL1, PIN_MX_COL2, PIN_MX_COL3, PIN_MX_COL4,
};

/* Squeeze / PTT arm state */
static bool s_ptt_pending;       /* down seen, voice not started yet */
static bool s_ptt_live;          /* voice session active */
static bool s_squeeze_active;
static uint8_t s_squeeze_vol_id; /* VOL_UP or VOL_DOWN */
static int64_t s_squeeze_since_us;
static bool s_suppress_vol[2];   /* [0]=vol_up [1]=vol_down: skip click/long after squeeze */

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

static int vol_suppress_index(uint8_t id)
{
    if (id == VIBEMIC_KEY_VOL_UP) {
        return 0;
    }
    if (id == VIBEMIC_KEY_VOL_DOWN) {
        return 1;
    }
    return -1;
}

static uint8_t squeeze_id_for_vol(uint8_t vol_id)
{
    return (vol_id == VIBEMIC_KEY_VOL_UP) ? VIBEMIC_KEY_SQUEEZE_VOL_UP : VIBEMIC_KEY_SQUEEZE_VOL_DOWN;
}

static void begin_squeeze(uint8_t vol_id, int64_t now)
{
    if (s_ptt_live) {
        s_ptt_live = false;
        if (s_ptt_cb) {
            s_ptt_cb(false, s_user);
        }
    }
    s_ptt_pending = false;
    s_squeeze_active = true;
    s_squeeze_vol_id = vol_id;
    s_squeeze_since_us = now;
    const int si = vol_suppress_index(vol_id);
    if (si >= 0) {
        s_suppress_vol[si] = true;
    }
}

static void end_squeeze(int64_t now)
{
    if (!s_squeeze_active) {
        return;
    }
    const uint8_t sid = squeeze_id_for_vol(s_squeeze_vol_id);
    const bool is_long = (now - s_squeeze_since_us) >= LONG_PRESS_US;
    emit_btn(sid, is_long ? VIBEMIC_BTN_LONG : VIBEMIC_BTN_CLICK);
    s_squeeze_active = false;
    s_squeeze_vol_id = 0;
}

static void on_matrix_key_edge(key_state_t *k, bool pressed, int64_t now)
{
    const bool is_vol = (k->id == VIBEMIC_KEY_VOL_UP || k->id == VIBEMIC_KEY_VOL_DOWN);
    const bool ptt_held = s_ptt.stable || s_ptt_pending || s_ptt_live;

    if (is_vol && pressed && ptt_held && !s_squeeze_active) {
        begin_squeeze(k->id, now);
        /* Still record DOWN for diagnostics but host mapping ignores vol during squeeze. */
        emit_btn(k->id, VIBEMIC_BTN_DOWN);
        return;
    }

    if (is_vol && !pressed && s_squeeze_active && s_squeeze_vol_id == k->id) {
        emit_btn(k->id, VIBEMIC_BTN_UP);
        end_squeeze(now);
        return;
    }

    if (pressed) {
        k->down_us = now;
        emit_btn(k->id, VIBEMIC_BTN_DOWN);
        return;
    }

    emit_btn(k->id, VIBEMIC_BTN_UP);

    const int si = vol_suppress_index(k->id);
    if (si >= 0 && s_suppress_vol[si]) {
        s_suppress_vol[si] = false;
        k->click_count = 0;
        return; /* swallow click/long — squeeze already emitted */
    }

    const int64_t held = now - k->down_us;
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

static void on_ptt_edge(bool pressed, int64_t now)
{
    if (pressed) {
        if (s_squeeze_active) {
            return;
        }
        /* If a vol key is already held, this is an immediate squeeze. */
        if (s_keys[VIBEMIC_KEY_VOL_UP - 1].stable) {
            begin_squeeze(VIBEMIC_KEY_VOL_UP, now);
            return;
        }
        if (s_keys[VIBEMIC_KEY_VOL_DOWN - 1].stable) {
            begin_squeeze(VIBEMIC_KEY_VOL_DOWN, now);
            return;
        }
        s_ptt_pending = true;
        s_ptt.down_us = now;
        return;
    }

    /* PTT released */
    if (s_squeeze_active) {
        end_squeeze(now);
        s_ptt_pending = false;
        return;
    }
    if (s_ptt_pending) {
        s_ptt_pending = false;
        return; /* released before arm — no voice */
    }
    if (s_ptt_live) {
        s_ptt_live = false;
        if (s_ptt_cb) {
            s_ptt_cb(false, s_user);
        }
    }
}

static void arm_ptt_if_needed(int64_t now)
{
    if (!s_ptt_pending || s_squeeze_active || s_ptt_live) {
        return;
    }
    if ((now - s_ptt.down_us) < PTT_ARM_US) {
        return;
    }
    s_ptt_pending = false;
    s_ptt_live = true;
    if (s_ptt_cb) {
        s_ptt_cb(true, s_user);
    }
}

void vibemic_keys_init(vibemic_ptt_cb_t ptt_cb, vibemic_button_cb_t btn_cb, void *user)
{
    s_ptt_cb = ptt_cb;
    s_btn_cb = btn_cb;
    s_user = user;
    s_ptt_pending = false;
    s_ptt_live = false;
    s_squeeze_active = false;
    s_squeeze_vol_id = 0;
    s_suppress_vol[0] = s_suppress_vol[1] = false;

    cfg_input_pullup(PIN_PTT);
    key_reset(&s_ptt, 0);

    for (int i = 0; i < VIBEMIC_MATRIX_KEY_COUNT; i++) {
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
    return s_ptt_live || s_ptt_pending || s_ptt.stable;
}

static key_state_t *key_by_id(uint8_t id)
{
    if (id >= 1 && id <= VIBEMIC_MATRIX_KEY_COUNT) {
        return &s_keys[id - 1];
    }
    return NULL;
}

static void scan_matrix(int64_t now)
{
    bool pressed_now[VIBEMIC_MATRIX_KEY_COUNT + 1] = {0};

    for (int r = 0; r < PIN_MX_ROWS; r++) {
        for (int rr = 0; rr < PIN_MX_ROWS; rr++) {
            gpio_set_level(s_rows[rr], rr == r ? 0 : 1);
        }
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

    for (uint8_t id = 1; id <= VIBEMIC_MATRIX_KEY_COUNT; id++) {
        key_state_t *k = key_by_id(id);
        if (!k) {
            continue;
        }
        bool pressed = false;
        if (debounce_step(k, pressed_now[id], now, &pressed)) {
            on_matrix_key_edge(k, pressed, now);
        }
    }
}

void vibemic_keys_poll(void)
{
    const int64_t now = esp_timer_get_time();
    bool pressed = false;

    if (debounce_step(&s_ptt, gpio_get_level(PIN_PTT) == 0, now, &pressed)) {
        on_ptt_edge(pressed, now);
    }
    arm_ptt_if_needed(now);
    scan_matrix(now);
}
