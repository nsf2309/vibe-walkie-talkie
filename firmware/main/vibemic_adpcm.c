#include "vibemic_adpcm.h"

static const int16_t s_step_table[89] = {
    7, 8, 9, 10, 11, 12, 13, 14, 16, 17, 19, 21, 23, 25, 28, 31, 34, 37, 41, 45, 50, 55, 60, 66, 73, 80, 88, 97, 107,
    118, 130, 143, 157, 173, 190, 209, 230, 253, 279, 307, 337, 371, 408, 449, 494, 544, 598, 658, 724, 796, 876,
    963, 1060, 1166, 1282, 1411, 1552, 1707, 1878, 2066, 2272, 2499, 2749, 3024, 3327, 3660, 4026, 4428, 4871, 5358,
    5894, 6484, 7132, 7845, 8630, 9493, 10442, 11487, 12635, 13899, 15289, 16818, 18500, 20350, 22385, 24623, 27086,
    29794, 32767
};

static const int s_index_table[16] = {
    -1, -1, -1, -1, 2, 4, 6, 8,
    -1, -1, -1, -1, 2, 4, 6, 8
};

void vibemic_adpcm_reset(vibemic_adpcm_state_t *st)
{
    st->predictor = 0;
    st->index = 0;
}

static int16_t encode_nibble(vibemic_adpcm_state_t *st, int16_t sample)
{
    int step = s_step_table[st->index];
    int diff = sample - st->predictor;
    int sign = 0;
    if (diff < 0) {
        sign = 8;
        diff = -diff;
    }
    int nibble = 0;
    if (diff >= step) {
        nibble = 4;
        diff -= step;
    }
    step >>= 1;
    if (diff >= step) {
        nibble |= 2;
        diff -= step;
    }
    step >>= 1;
    if (diff >= step) {
        nibble |= 1;
    }
    nibble |= sign;

    int delta = s_step_table[st->index] >> 3;
    if (nibble & 4) {
        delta += s_step_table[st->index];
    }
    if (nibble & 2) {
        delta += s_step_table[st->index] >> 1;
    }
    if (nibble & 1) {
        delta += s_step_table[st->index] >> 2;
    }
    if (nibble & 8) {
        st->predictor -= delta;
    } else {
        st->predictor += delta;
    }
    if (st->predictor > 32767) {
        st->predictor = 32767;
    } else if (st->predictor < -32768) {
        st->predictor = -32768;
    }
    st->index += s_index_table[nibble];
    if (st->index < 0) {
        st->index = 0;
    } else if (st->index > 88) {
        st->index = 88;
    }
    return (int16_t)nibble;
}

void vibemic_adpcm_encode(vibemic_adpcm_state_t *st, const int16_t *pcm, size_t samples, uint8_t *out)
{
    for (size_t i = 0; i + 1 < samples; i += 2) {
        int hi = encode_nibble(st, pcm[i]);
        int lo = encode_nibble(st, pcm[i + 1]);
        *out++ = (uint8_t)((hi << 4) | (lo & 0x0f));
    }
}