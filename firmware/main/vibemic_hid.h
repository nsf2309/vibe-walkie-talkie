#pragma once
#include <stdbool.h>
#include <stdint.h>

/* HID report assembly; transport is owned by vibemic_ble. */
void vibemic_hid_build_keyboard_f20(bool down, uint8_t report[8]);
void vibemic_hid_build_consumer(uint16_t usage, uint8_t report[2]);
void vibemic_hid_build_mouse(uint8_t buttons, int8_t dx, int8_t dy, int8_t wheel, uint8_t report[4]);

const uint8_t *vibemic_hid_report_map(uint16_t *out_len);