/* Logical button IDs shared by firmware + host. PTT is separate (CTRL_PTT_STATE). */
#pragma once

enum {
    VIBEMIC_KEY_NONE              = 0,
    VIBEMIC_KEY_UP                = 1,
    VIBEMIC_KEY_DOWN              = 2,
    VIBEMIC_KEY_LEFT              = 3,
    VIBEMIC_KEY_RIGHT             = 4,
    VIBEMIC_KEY_OK                = 5,
    VIBEMIC_KEY_VOL_UP            = 6,
    VIBEMIC_KEY_VOL_DOWN          = 7,
    VIBEMIC_KEY_BACK              = 8,
    VIBEMIC_KEY_HOME              = 9,
    VIBEMIC_KEY_MENU              = 10,
    VIBEMIC_KEY_F1                = 11,
    VIBEMIC_KEY_F2                = 12,
    VIBEMIC_KEY_F3                = 13,
    VIBEMIC_KEY_F4                = 14,
    VIBEMIC_KEY_F5                = 15,
    VIBEMIC_KEY_F6                = 16,
    /* Virtual: side squeeze (PTT + Vol). Not matrix cells. */
    VIBEMIC_KEY_SQUEEZE_VOL_DOWN  = 17, /* PTT + Vol- */
    VIBEMIC_KEY_SQUEEZE_VOL_UP    = 18, /* PTT + Vol+ */
};

/* Physical matrix keys */
#define VIBEMIC_MATRIX_KEY_COUNT 16
/* Mappable keys including squeeze gestures */
#define VIBEMIC_BUTTON_COUNT     18
