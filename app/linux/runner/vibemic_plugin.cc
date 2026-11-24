#include "vibemic_plugin.h"

#include <cstring>

static void audio_handler(FlMethodChannel* /*channel*/, FlMethodCall* method_call,
                          gpointer /*user_data*/) {
  const gchar* method = fl_method_call_get_name(method_call);
  if (strcmp(method, "listOutputDevices") == 0) {
    g_autoptr(FlValue) list = fl_value_new_list();
    g_autoptr(FlValue) map = fl_value_new_map();
    fl_value_set_string_take(map, "id", fl_value_new_string("vibemic-loopback"));
    fl_value_set_string_take(map, "name",
                             fl_value_new_string("VibeMicLoopback (PipeWire)"));
    fl_value_append_take(list, map);
    g_autoptr(FlMethodResponse) response =
        FL_METHOD_RESPONSE(fl_method_success_response_new(list));
    fl_method_call_respond(method_call, response, nullptr);
    return;
  }
  g_autoptr(FlMethodResponse) response =
      FL_METHOD_RESPONSE(fl_method_success_response_new(nullptr));
  fl_method_call_respond(method_call, response, nullptr);
}

static void input_handler(FlMethodChannel* /*channel*/, FlMethodCall* method_call,
                          gpointer /*user_data*/) {
  g_autoptr(FlMethodResponse) response =
      FL_METHOD_RESPONSE(fl_method_success_response_new(nullptr));
  fl_method_call_respond(method_call, response, nullptr);
}

void vibemic_plugin_register_with_registrar(FlPluginRegistrar* registrar) {
  g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
  FlMethodChannel* audio = fl_method_channel_new(
      fl_plugin_registrar_get_messenger(registrar), "vibemic/audio",
      FL_METHOD_CODEC(codec));
  fl_method_channel_set_method_call_handler(audio, audio_handler, nullptr, nullptr);

  FlMethodChannel* input = fl_method_channel_new(
      fl_plugin_registrar_get_messenger(registrar), "vibemic/input",
      FL_METHOD_CODEC(codec));
  fl_method_channel_set_method_call_handler(input, input_handler, nullptr, nullptr);
}