#pragma once
#include <stdbool.h>
#include <stdint.h>
#include "vibemic_adpcm.h"

typedef void (*vibemic_audio_frame_cb_t)(const uint8_t *pkt, size_t len, void *user);

void vibemic_audio_init(vibemic_audio_frame_cb_t cb, void *user);
void vibemic_audio_reset_codec(void);
void vibemic_audio_set_streaming(bool on);
void vibemic_audio_set_use_mic(bool on);
void vibemic_audio_request_test_tone(uint16_t duration_ms);
bool vibemic_audio_is_streaming(void);