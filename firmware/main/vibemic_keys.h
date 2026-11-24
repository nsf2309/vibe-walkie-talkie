#pragma once
#include <stdbool.h>
#include <stdint.h>

typedef void (*vibemic_ptt_cb_t)(bool down, void *user);
typedef void (*vibemic_button_cb_t)(uint8_t id, uint8_t event, void *user);

void vibemic_keys_init(vibemic_ptt_cb_t ptt_cb, vibemic_button_cb_t btn_cb, void *user);
void vibemic_keys_poll(void);
bool vibemic_keys_ptt_down(void);