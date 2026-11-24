#pragma once
#include <stdbool.h>
#include <stdint.h>

typedef void (*vibemic_mouse_cb_t)(uint8_t buttons, int8_t dx, int8_t dy, int8_t wheel, void *user);

void vibemic_touchpad_init(vibemic_mouse_cb_t cb, void *user);
void vibemic_touchpad_set_enabled(bool on);
void vibemic_touchpad_set_audio_priority(bool on);
void vibemic_touchpad_poll(void);
bool vibemic_touchpad_present(void);
