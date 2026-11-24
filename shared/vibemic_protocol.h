/* VibeMic protocol constants — shared by firmware (C) and mirrored in Dart. */
#pragma once
#include <stdint.h>
#include "vibemic_buttons.h"

#define VIBEMIC_NAME                 "VibeMic"
#define VIBEMIC_PROTO_VERSION        0x01

#define VIBEMIC_HID_VID              0x56D0
#define VIBEMIC_HID_PID              0x0001

#define VIBEMIC_SAMPLE_RATE_HZ       16000
#define VIBEMIC_CHANNELS             1
#define VIBEMIC_FRAME_SAMPLES        128
#define VIBEMIC_ADPCM_BYTES          (VIBEMIC_FRAME_SAMPLES / 2)

/* 128-bit UUIDs as ESP NimBLE byte order helpers use esp_bt_uuid; Dart uses strings. */
#define VIBEMIC_UUID_SERVICE_STR     "6b1d0001-7c2e-4a9f-9b10-a1b2c3d4e5f0"
#define VIBEMIC_UUID_CMD_STR         "6b1d0002-7c2e-4a9f-9b10-a1b2c3d4e5f0"
#define VIBEMIC_UUID_AUDIO_STR       "6b1d0003-7c2e-4a9f-9b10-a1b2c3d4e5f0"
#define VIBEMIC_UUID_CTRL_STR        "6b1d0004-7c2e-4a9f-9b10-a1b2c3d4e5f0"

enum {
    VIBEMIC_CMD_GET_CAPS       = 0x01,
    VIBEMIC_CMD_SET_MODE       = 0x02,
    VIBEMIC_CMD_SET_TOUCHPAD   = 0x03,
    VIBEMIC_CMD_TEST_TONE      = 0x04,
};

enum {
    VIBEMIC_MODE_IDLE          = 0x00,
    VIBEMIC_MODE_LIVE          = 0x01,
    VIBEMIC_MODE_TEST          = 0x02,
};

enum {
    VIBEMIC_TP_OFF             = 0x00,
    VIBEMIC_TP_ON              = 0x01,
    VIBEMIC_TP_AUDIO_PRIORITY  = 0x02,
};

enum {
    VIBEMIC_CTRL_CAPS          = 0x81,
    VIBEMIC_CTRL_PTT_STATE     = 0x82,
    VIBEMIC_CTRL_BUTTON        = 0x83,
    VIBEMIC_CTRL_NACK          = 0x84,
    VIBEMIC_CTRL_SYNC          = 0x85,
};

enum {
    VIBEMIC_BTN_UP             = 0,
    VIBEMIC_BTN_DOWN           = 1,
    VIBEMIC_BTN_CLICK          = 2,
    VIBEMIC_BTN_DOUBLE         = 3,
    VIBEMIC_BTN_LONG           = 4,
};

enum {
    VIBEMIC_FLAG_HAS_MIC       = 1 << 0,
    VIBEMIC_FLAG_HAS_TOUCHPAD  = 1 << 1,
    VIBEMIC_FLAG_TEST_TONE     = 1 << 2,
    VIBEMIC_FLAG_ADPCM_IMA     = 1 << 3,
};

enum {
    VIBEMIC_AFLAG_SESSION_START = 1 << 0,
    VIBEMIC_AFLAG_SESSION_END   = 1 << 1,
    VIBEMIC_AFLAG_SYNC          = 1 << 2,
};

#define VIBEMIC_AUDIO_HDR_SIZE  2
#define VIBEMIC_AUDIO_PKT_SIZE  (VIBEMIC_AUDIO_HDR_SIZE + VIBEMIC_ADPCM_BYTES)
