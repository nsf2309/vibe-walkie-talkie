#pragma once
#include <stddef.h>
#include <stdint.h>

typedef struct {
    int32_t predictor;
    int index;
} vibemic_adpcm_state_t;

void vibemic_adpcm_reset(vibemic_adpcm_state_t *st);
void vibemic_adpcm_encode(vibemic_adpcm_state_t *st, const int16_t *pcm, size_t samples, uint8_t *out);
