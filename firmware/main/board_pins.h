#pragma once

#include "sdkconfig.h"

#if CONFIG_IDF_TARGET_ESP32C3
/*
 * ESP32-C3 pin map
 * - PTT: dedicated GPIO (hold-to-talk; not matrix-scanned)
 * - Keys: 4x5 matrix = 20 positions (16 used + 4 spare)
 * - Mic INMP441 I2S
 * - Touchpad I2C reserved (phase 2); do not overlap matrix
 *
 * Avoid GPIO18/19 when the board uses USB-Serial/JTAG.
 */
#define PIN_PTT            3

#define PIN_MX_ROW0        4
#define PIN_MX_ROW1        5
#define PIN_MX_ROW2        6
#define PIN_MX_ROW3        7
#define PIN_MX_COL0        0
#define PIN_MX_COL1        21
#define PIN_MX_COL2        11
#define PIN_MX_COL3        12
#define PIN_MX_COL4        13

#define PIN_I2S_CLK        10
#define PIN_I2S_WS         20
#define PIN_I2S_DIN        2
#define PIN_TP_IRQ         1
#define PIN_I2C_SDA        8
#define PIN_I2C_SCL        9
#else
/* Classic ESP32 defaults */
#define PIN_PTT            32

#define PIN_MX_ROW0        33
#define PIN_MX_ROW1        25
#define PIN_MX_ROW2        26
#define PIN_MX_ROW3        27
#define PIN_MX_COL0        12
#define PIN_MX_COL1        13
#define PIN_MX_COL2        14
#define PIN_MX_COL3        15
#define PIN_MX_COL4        16

#define PIN_I2S_CLK        0
#define PIN_I2S_WS         4
#define PIN_I2S_DIN        35
#define PIN_TP_IRQ         34
#define PIN_I2C_SDA        21
#define PIN_I2C_SCL        22
#endif

#define PIN_MX_ROWS        4
#define PIN_MX_COLS        5
