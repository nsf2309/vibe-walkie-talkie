#include "vibemic_ble.h"
#include "vibemic_audio.h"
#include "vibemic_hid.h"
#include "vibemic_protocol.h"
#include "vibemic_touchpad.h"
#include "board_pins.h"

#include "esp_log.h"
#include "esp_random.h"
#include "nimble/nimble_port.h"
#include "nimble/nimble_port_freertos.h"
#include "host/ble_hs.h"
#include "host/ble_uuid.h"
#include "services/gap/ble_svc_gap.h"
#include "services/gatt/ble_svc_gatt.h"
#include "host/util/util.h"
#include <assert.h>
#include <string.h>

static const char *TAG = "vm_ble";

static uint8_t s_addr_type;
static uint16_t s_conn_handle = BLE_HS_CONN_HANDLE_NONE;
static uint16_t s_audio_handle;
static uint16_t s_ctrl_handle;
static uint16_t s_hid_input_kb_handle;
static uint16_t s_hid_input_cons_handle;
static uint16_t s_hid_input_mouse_handle;
static uint8_t s_mode = VIBEMIC_MODE_LIVE;
static uint8_t s_tp_mode = VIBEMIC_TP_AUDIO_PRIORITY;
static bool s_audio_notify;
static bool s_ctrl_notify;
static bool s_hid_notify;

static int gap_event(struct ble_gap_event *event, void *arg);
static void start_advertise(void);

static void notify_ctrl_raw(const uint8_t *data, uint16_t len)
{
    if (!s_ctrl_notify || s_conn_handle == BLE_HS_CONN_HANDLE_NONE) {
        return;
    }
    struct os_mbuf *om = ble_hs_mbuf_from_flat(data, len);
    if (om) {
        ble_gatts_notify_custom(s_conn_handle, s_ctrl_handle, om);
    }
}

void vibemic_ble_notify_ctrl(const uint8_t *data, uint16_t len)
{
    notify_ctrl_raw(data, len);
}

void vibemic_ble_notify_audio(const uint8_t *data, uint16_t len)
{
    if (!s_audio_notify || s_conn_handle == BLE_HS_CONN_HANDLE_NONE) {
        return;
    }
    struct os_mbuf *om = ble_hs_mbuf_from_flat(data, len);
    if (om) {
        ble_gatts_notify_custom(s_conn_handle, s_audio_handle, om);
    }
}

bool vibemic_ble_is_connected(void)
{
    return s_conn_handle != BLE_HS_CONN_HANDLE_NONE;
}

uint8_t vibemic_ble_mode(void)
{
    return s_mode;
}

uint8_t vibemic_ble_touchpad_mode(void)
{
    return s_tp_mode;
}

static void send_caps(void)
{
    uint8_t c[9];
    c[0] = VIBEMIC_CTRL_CAPS;
    c[1] = VIBEMIC_PROTO_VERSION;
    c[2] = (uint8_t)(VIBEMIC_FLAG_HAS_MIC | VIBEMIC_FLAG_TEST_TONE | VIBEMIC_FLAG_ADPCM_IMA);
    if (vibemic_touchpad_present()) {
        c[2] |= VIBEMIC_FLAG_HAS_TOUCHPAD;
    }
    c[3] = (uint8_t)(VIBEMIC_SAMPLE_RATE_HZ & 0xff);
    c[4] = (uint8_t)((VIBEMIC_SAMPLE_RATE_HZ >> 8) & 0xff);
    c[5] = VIBEMIC_CHANNELS;
    c[6] = (uint8_t)VIBEMIC_FRAME_SAMPLES;
    c[7] = VIBEMIC_BUTTON_COUNT;
    c[8] = 0;
    notify_ctrl_raw(c, sizeof(c));
}

static void send_hid_keyboard(bool f20_down)
{
    if (!s_hid_notify || s_conn_handle == BLE_HS_CONN_HANDLE_NONE) {
        return;
    }
    uint8_t report[8];
    vibemic_hid_build_keyboard_f20(f20_down, report);
    struct os_mbuf *om = ble_hs_mbuf_from_flat(report, sizeof(report));
    if (om) {
        ble_gatts_notify_custom(s_conn_handle, s_hid_input_kb_handle, om);
    }
}

static void send_hid_mouse(uint8_t buttons, int8_t dx, int8_t dy, int8_t wheel)
{
    if (!s_hid_notify || s_conn_handle == BLE_HS_CONN_HANDLE_NONE) {
        return;
    }
    uint8_t report[4];
    vibemic_hid_build_mouse(buttons, dx, dy, wheel, report);
    struct os_mbuf *om = ble_hs_mbuf_from_flat(report, sizeof(report));
    if (om) {
        ble_gatts_notify_custom(s_conn_handle, s_hid_input_mouse_handle, om);
    }
}

void vibemic_ble_set_ptt(bool down)
{
    uint8_t p[2] = {VIBEMIC_CTRL_PTT_STATE, (uint8_t)(down ? 1 : 0)};
    notify_ctrl_raw(p, sizeof(p));
    send_hid_keyboard(down);

    if (s_mode == VIBEMIC_MODE_LIVE || s_mode == VIBEMIC_MODE_TEST) {
        if (down) {
            uint8_t sync = VIBEMIC_CTRL_SYNC;
            notify_ctrl_raw(&sync, 1);
            vibemic_audio_set_streaming(true);
        } else {
            vibemic_audio_set_streaming(false);
        }
    }
}

void vibemic_ble_notify_button(uint8_t id, uint8_t event)
{
    uint8_t p[3] = {VIBEMIC_CTRL_BUTTON, id, event};
    notify_ctrl_raw(p, sizeof(p));
}

void vibemic_ble_on_mouse(uint8_t buttons, int8_t dx, int8_t dy, int8_t wheel)
{
    send_hid_mouse(buttons, dx, dy, wheel);
}

static int cmd_write(uint16_t conn_handle, uint16_t attr_handle, struct ble_gatt_access_ctxt *ctxt, void *arg)
{
    (void)conn_handle;
    (void)attr_handle;
    (void)arg;
    uint8_t buf[8];
    uint16_t len = OS_MBUF_PKTLEN(ctxt->om);
    if (len == 0 || len > sizeof(buf)) {
        return BLE_ATT_ERR_INVALID_ATTR_VALUE_LEN;
    }
    ble_hs_mbuf_to_flat(ctxt->om, buf, len, NULL);
    switch (buf[0]) {
    case VIBEMIC_CMD_GET_CAPS:
        send_caps();
        break;
    case VIBEMIC_CMD_SET_MODE:
        if (len < 2) {
            return BLE_ATT_ERR_INVALID_ATTR_VALUE_LEN;
        }
        s_mode = buf[1];
        if (s_mode == VIBEMIC_MODE_IDLE) {
            vibemic_audio_set_streaming(false);
        }
        break;
    case VIBEMIC_CMD_SET_TOUCHPAD:
        if (len < 2) {
            return BLE_ATT_ERR_INVALID_ATTR_VALUE_LEN;
        }
        s_tp_mode = buf[1];
        vibemic_touchpad_set_enabled(s_tp_mode != VIBEMIC_TP_OFF);
        vibemic_touchpad_set_audio_priority(s_tp_mode == VIBEMIC_TP_AUDIO_PRIORITY);
        break;
    case VIBEMIC_CMD_TEST_TONE: {
        uint16_t ms = 1000;
        if (len >= 3) {
            ms = (uint16_t)(buf[1] | (buf[2] << 8));
        }
        vibemic_audio_request_test_tone(ms);
        break;
    }
    default: {
        uint8_t nack[2] = {VIBEMIC_CTRL_NACK, buf[0]};
        notify_ctrl_raw(nack, sizeof(nack));
        break;
    }
    }
    return 0;
}

static int ctrl_access(uint16_t conn_handle, uint16_t attr_handle, struct ble_gatt_access_ctxt *ctxt, void *arg)
{
    (void)conn_handle;
    (void)attr_handle;
    (void)arg;
    if (ctxt->op == BLE_GATT_ACCESS_OP_READ_CHR) {
        uint8_t z = 0;
        os_mbuf_append(ctxt->om, &z, 1);
        return 0;
    }
    if (ctxt->op == BLE_GATT_ACCESS_OP_WRITE_CHR) {
        return cmd_write(conn_handle, attr_handle, ctxt, arg);
    }
    return 0;
}

static int audio_access(uint16_t conn_handle, uint16_t attr_handle, struct ble_gatt_access_ctxt *ctxt, void *arg)
{
    (void)conn_handle;
    (void)attr_handle;
    (void)arg;
    if (ctxt->op == BLE_GATT_ACCESS_OP_READ_CHR) {
        uint8_t z = 0;
        os_mbuf_append(ctxt->om, &z, 1);
    }
    return 0;
}

static int hid_info_access(uint16_t conn_handle, uint16_t attr_handle, struct ble_gatt_access_ctxt *ctxt, void *arg)
{
    (void)conn_handle;
    (void)attr_handle;
    (void)arg;
    /* bcdHID=1.11, country=0, flags=normally connectable|remote wake */
    static const uint8_t info[4] = {0x11, 0x01, 0x00, 0x02};
    os_mbuf_append(ctxt->om, info, sizeof(info));
    return 0;
}

static int hid_map_access(uint16_t conn_handle, uint16_t attr_handle, struct ble_gatt_access_ctxt *ctxt, void *arg)
{
    (void)conn_handle;
    (void)attr_handle;
    (void)arg;
    uint16_t len = 0;
    const uint8_t *map = vibemic_hid_report_map(&len);
    os_mbuf_append(ctxt->om, map, len);
    return 0;
}

static int hid_report_access(uint16_t conn_handle, uint16_t attr_handle, struct ble_gatt_access_ctxt *ctxt, void *arg)
{
    (void)conn_handle;
    (void)attr_handle;
    (void)arg;
    uint8_t z[8] = {0};
    os_mbuf_append(ctxt->om, z, sizeof(z));
    return 0;
}

static int hid_proto_access(uint16_t conn_handle, uint16_t attr_handle, struct ble_gatt_access_ctxt *ctxt, void *arg)
{
    (void)conn_handle;
    (void)attr_handle;
    (void)arg;
    uint8_t proto = 1; /* report protocol */
    if (ctxt->op == BLE_GATT_ACCESS_OP_READ_CHR) {
        os_mbuf_append(ctxt->om, &proto, 1);
    }
    return 0;
}

/* 128-bit UUIDs little-endian for NimBLE */
static const ble_uuid128_t uuid_svc = BLE_UUID128_INIT(
    0xf0, 0xe5, 0xd4, 0xc3, 0xb2, 0xa1, 0x10, 0x9b, 0x9f, 0x4a, 0x2e, 0x7c, 0x01, 0x00, 0x1d, 0x6b);
static const ble_uuid128_t uuid_cmd = BLE_UUID128_INIT(
    0xf0, 0xe5, 0xd4, 0xc3, 0xb2, 0xa1, 0x10, 0x9b, 0x9f, 0x4a, 0x2e, 0x7c, 0x02, 0x00, 0x1d, 0x6b);
static const ble_uuid128_t uuid_audio = BLE_UUID128_INIT(
    0xf0, 0xe5, 0xd4, 0xc3, 0xb2, 0xa1, 0x10, 0x9b, 0x9f, 0x4a, 0x2e, 0x7c, 0x03, 0x00, 0x1d, 0x6b);
static const ble_uuid128_t uuid_ctrl = BLE_UUID128_INIT(
    0xf0, 0xe5, 0xd4, 0xc3, 0xb2, 0xa1, 0x10, 0x9b, 0x9f, 0x4a, 0x2e, 0x7c, 0x04, 0x00, 0x1d, 0x6b);

static const struct ble_gatt_svc_def gatt_svcs[] = {
    {
        .type = BLE_GATT_SVC_TYPE_PRIMARY,
        .uuid = &uuid_svc.u,
        .characteristics =
            (struct ble_gatt_chr_def[]){
                {
                    .uuid = &uuid_cmd.u,
                    .access_cb = cmd_write,
                    .flags = BLE_GATT_CHR_F_WRITE | BLE_GATT_CHR_F_WRITE_NO_RSP,
                },
                {
                    .uuid = &uuid_audio.u,
                    .access_cb = audio_access,
                    .val_handle = &s_audio_handle,
                    .flags = BLE_GATT_CHR_F_READ | BLE_GATT_CHR_F_NOTIFY,
                },
                {
                    .uuid = &uuid_ctrl.u,
                    .access_cb = ctrl_access,
                    .val_handle = &s_ctrl_handle,
                    .flags = BLE_GATT_CHR_F_READ | BLE_GATT_CHR_F_WRITE | BLE_GATT_CHR_F_NOTIFY,
                },
                {0},
            },
    },
    {
        .type = BLE_GATT_SVC_TYPE_PRIMARY,
        .uuid = BLE_UUID16_DECLARE(0x1812),
        .characteristics =
            (struct ble_gatt_chr_def[]){
                {
                    .uuid = BLE_UUID16_DECLARE(0x2A4A),
                    .access_cb = hid_info_access,
                    .flags = BLE_GATT_CHR_F_READ,
                },
                {
                    .uuid = BLE_UUID16_DECLARE(0x2A4B),
                    .access_cb = hid_map_access,
                    .flags = BLE_GATT_CHR_F_READ,
                },
                {
                    .uuid = BLE_UUID16_DECLARE(0x2A4E),
                    .access_cb = hid_proto_access,
                    .flags = BLE_GATT_CHR_F_READ | BLE_GATT_CHR_F_WRITE_NO_RSP,
                },
                {
                    .uuid = BLE_UUID16_DECLARE(0x2A4D),
                    .access_cb = hid_report_access,
                    .val_handle = &s_hid_input_kb_handle,
                    .flags = BLE_GATT_CHR_F_READ | BLE_GATT_CHR_F_NOTIFY,
                },
                {
                    .uuid = BLE_UUID16_DECLARE(0x2A4D),
                    .access_cb = hid_report_access,
                    .val_handle = &s_hid_input_cons_handle,
                    .flags = BLE_GATT_CHR_F_READ | BLE_GATT_CHR_F_NOTIFY,
                },
                {
                    .uuid = BLE_UUID16_DECLARE(0x2A4D),
                    .access_cb = hid_report_access,
                    .val_handle = &s_hid_input_mouse_handle,
                    .flags = BLE_GATT_CHR_F_READ | BLE_GATT_CHR_F_NOTIFY,
                },
                {0},
            },
    },
    {0},
};

static void on_sync(void)
{
    int rc = ble_hs_util_ensure_addr(0);
    assert(rc == 0);
    /* Prefer public address — Windows is unreliable with rotating RPAs while scanning. */
    rc = ble_hs_id_infer_auto(0, &s_addr_type);
    assert(rc == 0);
    ble_svc_gap_device_name_set(VIBEMIC_NAME);
    start_advertise();

    uint8_t addr[6] = {0};
    int is_nrpa = 0;
    ble_hs_id_copy_addr(s_addr_type, addr, &is_nrpa);
    ESP_LOGI(TAG, "synced, advertising as %s addr=%02x:%02x:%02x:%02x:%02x:%02x own_type=%u nrpa=%d",
             VIBEMIC_NAME, addr[5], addr[4], addr[3], addr[2], addr[1], addr[0], s_addr_type, is_nrpa);
}

static void on_reset(int reason)
{
    ESP_LOGE(TAG, "nimble reset reason=%d", reason);
}

static void start_advertise(void)
{
    /* Windows often gets ADV and SCAN_RSP as separate PDUs. Put the name in BOTH. */
    static const uint8_t mfg[] = {0xFF, 0xFF, 'V', 'M'}; /* company 0xFFFF + "VM" */

    struct ble_hs_adv_fields fields = {0};
    fields.flags = BLE_HS_ADV_F_DISC_GEN | BLE_HS_ADV_F_BREDR_UNSUP;
    fields.name = (uint8_t *)VIBEMIC_NAME;
    fields.name_len = strlen(VIBEMIC_NAME);
    fields.name_is_complete = 1;
    fields.mfg_data = mfg;
    fields.mfg_data_len = sizeof(mfg);
    int rc = ble_gap_adv_set_fields(&fields);
    if (rc != 0) {
        ESP_LOGE(TAG, "adv fields rc=%d", rc);
    }

    struct ble_hs_adv_fields rsp = {0};
    rsp.name = (uint8_t *)VIBEMIC_NAME;
    rsp.name_len = strlen(VIBEMIC_NAME);
    rsp.name_is_complete = 1;
    rsp.uuids128 = (ble_uuid128_t *)&uuid_svc;
    rsp.num_uuids128 = 1;
    rsp.uuids128_is_complete = 1;
    rc = ble_gap_adv_rsp_set_fields(&rsp);
    if (rc != 0) {
        /* Name+UUID may not fit; fall back to UUID only. */
        memset(&rsp, 0, sizeof(rsp));
        rsp.uuids128 = (ble_uuid128_t *)&uuid_svc;
        rsp.num_uuids128 = 1;
        rsp.uuids128_is_complete = 1;
        rc = ble_gap_adv_rsp_set_fields(&rsp);
        ESP_LOGW(TAG, "scan rsp fallback rc=%d", rc);
    }

    struct ble_gap_adv_params adv = {0};
    adv.conn_mode = BLE_GAP_CONN_MODE_UND;
    adv.disc_mode = BLE_GAP_DISC_MODE_GEN;
    /* ~30–60 ms — easier for Windows watcher to catch */
    adv.itvl_min = 48;
    adv.itvl_max = 96;
    rc = ble_gap_adv_start(s_addr_type, NULL, BLE_HS_FOREVER, &adv, gap_event, NULL);
    if (rc != 0) {
        ESP_LOGE(TAG, "adv start rc=%d", rc);
    } else {
        ESP_LOGI(TAG, "advertising started");
    }
}

static int gap_event(struct ble_gap_event *event, void *arg)
{
    (void)arg;
    switch (event->type) {
    case BLE_GAP_EVENT_CONNECT:
        if (event->connect.status == 0) {
            s_conn_handle = event->connect.conn_handle;
            ESP_LOGI(TAG, "connected handle=%u (single link — stop Windows Settings pairing if companion cannot find us)",
                     s_conn_handle);
        } else {
            start_advertise();
        }
        return 0;
    case BLE_GAP_EVENT_DISCONNECT:
        ESP_LOGI(TAG, "disconnected");
        s_conn_handle = BLE_HS_CONN_HANDLE_NONE;
        s_audio_notify = false;
        s_ctrl_notify = false;
        s_hid_notify = false;
        vibemic_audio_set_streaming(false);
        start_advertise();
        return 0;
    case BLE_GAP_EVENT_SUBSCRIBE:
        if (event->subscribe.attr_handle == s_audio_handle) {
            s_audio_notify = event->subscribe.cur_notify;
        } else if (event->subscribe.attr_handle == s_ctrl_handle) {
            s_ctrl_notify = event->subscribe.cur_notify;
            if (s_ctrl_notify) {
                send_caps();
            }
        } else if (event->subscribe.attr_handle == s_hid_input_kb_handle ||
                   event->subscribe.attr_handle == s_hid_input_mouse_handle ||
                   event->subscribe.attr_handle == s_hid_input_cons_handle) {
            s_hid_notify = event->subscribe.cur_notify;
        }
        return 0;
    case BLE_GAP_EVENT_MTU:
        ESP_LOGI(TAG, "mtu %d", event->mtu.value);
        return 0;
    default:
        return 0;
    }
}

static void host_task(void *param)
{
    (void)param;
    nimble_port_run();
    nimble_port_freertos_deinit();
}

void vibemic_ble_start(void)
{
    nimble_port_init();
    ble_hs_cfg.reset_cb = on_reset;
    ble_hs_cfg.sync_cb = on_sync;
    ble_hs_cfg.gatts_register_cb = NULL;

    ble_svc_gap_init();
    ble_svc_gatt_init();
    ble_gatts_count_cfg(gatt_svcs);
    ble_gatts_add_svcs(gatt_svcs);

    nimble_port_freertos_init(host_task);
}