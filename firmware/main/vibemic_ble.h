#pragma once
#include <stdbool.h>
#include <stdint.h>

void vibemic_ble_start(void);
void vibemic_ble_notify_ctrl(const uint8_t *data, uint16_t len);
void vibemic_ble_notify_audio(const uint8_t *data, uint16_t len);
void vibemic_ble_notify_button(uint8_t id, uint8_t event);
void vibemic_ble_on_mouse(uint8_t buttons, int8_t dx, int8_t dy, int8_t wheel);
bool vibemic_ble_is_connected(void);
uint8_t vibemic_ble_mode(void);
uint8_t vibemic_ble_touchpad_mode(void);
void vibemic_ble_set_ptt(bool down);