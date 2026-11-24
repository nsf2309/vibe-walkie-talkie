/* Logical button IDs shared by firmware + host. PTT is separate (CTRL_PTT_STATE). */
#pragma once

enum {
    VIBEMIC_KEY_NONE       = 0,
    VIBEMIC_KEY_UP         = 1,
    VIBEMIC_KEY_DOWN       = 2,
    VIBEMIC_KEY_LEFT       = 3,
    VIBEMIC_KEY_RIGHT      = 4,
    VIBEMIC_KEY_OK         = 5,
    VIBEMIC_KEY_VOL_UP     = 6,
    VIBEMIC_KEY_VOL_DOWN   = 7,
    VIBEMIC_KEY_BACK       = 8,
    VIBEMIC_KEY_HOME       = 9,
    VIBEMIC_KEY_MENU       = 10,
    VIBEMIC_KEY_F1         = 11,
    VIBEMIC_KEY_F2         = 12,
    VIBEMIC_KEY_F3         = 13,
    VIBEMIC_KEY_F4         = 14,
    VIBEMIC_KEY_F5         = 15,
    VIBEMIC_KEY_F6         = 16,
};

/* Mappable keys (excludes PTT). */
#define VIBEMIC_BUTTON_COUNT 16
