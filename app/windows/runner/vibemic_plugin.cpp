// MethodChannels: vibemic/audio (WASAPI render to virtual cable), vibemic/input

#include "vibemic_plugin.h"

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include <windows.h>
#include <shellapi.h>
#include <mmdeviceapi.h>
#include <audioclient.h>
#include <mmreg.h>
#include <functiondiscoverykeys_devpkey.h>

#include <algorithm>
#include <cctype>
#include <cmath>
#include <cstdlib>
#include <memory>
#include <string>
#include <vector>

#pragma comment(lib, "ole32.lib")
#pragma comment(lib, "uuid.lib")
#pragma comment(lib, "shell32.lib")

namespace {

std::wstring Utf8ToWide(const std::string& s) {
  if (s.empty()) return L"";
  int n = MultiByteToWideChar(CP_UTF8, 0, s.c_str(), (int)s.size(), nullptr, 0);
  std::wstring out(n, 0);
  MultiByteToWideChar(CP_UTF8, 0, s.c_str(), (int)s.size(), out.data(), n);
  return out;
}

std::string WideToUtf8(const wchar_t* w) {
  if (!w) return {};
  int n = WideCharToMultiByte(CP_UTF8, 0, w, -1, nullptr, 0, nullptr, nullptr);
  if (n <= 1) return {};
  std::string out(n - 1, 0);
  WideCharToMultiByte(CP_UTF8, 0, w, -1, out.data(), n, nullptr, nullptr);
  return out;
}

std::string ToLowerAscii(std::string s) {
  for (char& c : s) c = (char)tolower((unsigned char)c);
  return s;
}

WORD VkFromName(const std::string& raw) {
  const std::string name = ToLowerAscii(raw);
  if (name == "control" || name == "ctrl") return VK_CONTROL;
  if (name == "lcontrol" || name == "lctrl") return VK_LCONTROL;
  if (name == "rcontrol" || name == "rctrl") return VK_RCONTROL;
  if (name == "win" || name == "meta" || name == "cmd" || name == "super") return VK_LWIN;
  if (name == "shift") return VK_SHIFT;
  if (name == "alt" || name == "option") return VK_MENU;
  if (name == "lalt") return VK_LMENU;
  if (name == "ralt") return VK_RMENU;
  if (name == "space") return VK_SPACE;
  if (name == "enter" || name == "return") return VK_RETURN;
  if (name == "tab") return VK_TAB;
  if (name == "escape" || name == "esc") return VK_ESCAPE;
  if (name == "backspace") return VK_BACK;
  if (name == "delete" || name == "del") return VK_DELETE;
  if (name == "up") return VK_UP;
  if (name == "down") return VK_DOWN;
  if (name == "left") return VK_LEFT;
  if (name == "right") return VK_RIGHT;
  if (name == "home") return VK_HOME;
  if (name == "end") return VK_END;
  if (name == "pageup") return VK_PRIOR;
  if (name == "pagedown") return VK_NEXT;
  if (name == "mediaplaypause" || name == "playpause") return VK_MEDIA_PLAY_PAUSE;
  if (name == "medianext") return VK_MEDIA_NEXT_TRACK;
  if (name == "mediaprev" || name == "mediaprevious") return VK_MEDIA_PREV_TRACK;
  if (name == "mediastop") return VK_MEDIA_STOP;
  if (name == "volumeup") return VK_VOLUME_UP;
  if (name == "volumedown") return VK_VOLUME_DOWN;
  if (name == "volumemute" || name == "mute") return VK_VOLUME_MUTE;
  if (name == "printscreen" || name == "prtsc" || name == "prtscr" || name == "snapshot") {
    return VK_SNAPSHOT;
  }
  if (name.size() >= 2 && name[0] == 'f') {
    bool digits = true;
    for (size_t i = 1; i < name.size(); i++) {
      if (!isdigit((unsigned char)name[i])) {
        digits = false;
        break;
      }
    }
    if (digits) {
      int n = atoi(name.c_str() + 1);
      if (n >= 1 && n <= 24) return (WORD)(VK_F1 + (n - 1));
    }
  }
  if (name.size() == 1) {
    SHORT scanned = VkKeyScanA(name[0]);
    if (scanned != -1) return (WORD)(scanned & 0xff);
  }
  return 0;
}

std::vector<WORD> VksFromList(const flutter::EncodableList& keys) {
  std::vector<WORD> vks;
  vks.reserve(keys.size());
  for (const auto& k : keys) {
    if (!std::holds_alternative<std::string>(k)) continue;
    WORD vk = VkFromName(std::get<std::string>(k));
    if (vk) vks.push_back(vk);
  }
  return vks;
}

void SendVks(const std::vector<WORD>& vks, bool down) {
  if (!down) {
    for (auto it = vks.rbegin(); it != vks.rend(); ++it) {
      INPUT up{};
      up.type = INPUT_KEYBOARD;
      up.ki.wVk = *it;
      up.ki.dwFlags = KEYEVENTF_KEYUP;
      SendInput(1, &up, sizeof(INPUT));
    }
    return;
  }
  for (WORD vk : vks) {
    INPUT in{};
    in.type = INPUT_KEYBOARD;
    in.ki.wVk = vk;
    SendInput(1, &in, sizeof(INPUT));
  }
}

void TapShortcut(const flutter::EncodableList& keys) {
  auto vks = VksFromList(keys);
  SendVks(vks, true);
  SendVks(vks, false);
}

void SendModifierChord(const std::string& modifier, bool down) {
  const std::string m = ToLowerAscii(modifier);
  std::vector<WORD> vks;
  if (m == "none") {
    return;
  } else if (m == "fn") {
    // Windows has no Fn; approximate with Left Alt for host bring-up.
    vks.push_back(VK_LMENU);
  } else if (m == "leftcontrol") {
    vks.push_back(VK_LCONTROL);
  } else if (m == "rightcontrol") {
    vks.push_back(VK_RCONTROL);
  } else if (m == "leftalt") {
    vks.push_back(VK_LMENU);
  } else if (m == "rightalt") {
    vks.push_back(VK_RMENU);
  } else if (m == "leftmeta") {
    vks.push_back(VK_LWIN);
  } else if (m == "rightmeta") {
    vks.push_back(VK_RWIN);
  } else {
    // ctrlWin (WeChat IME style) and unknown -> Ctrl+Win
    vks.push_back(VK_CONTROL);
    vks.push_back(VK_LWIN);
  }

  if (!down) {
    std::reverse(vks.begin(), vks.end());
  }
  for (WORD vk : vks) {
    INPUT in{};
    in.type = INPUT_KEYBOARD;
    in.ki.wVk = vk;
    if (!down) in.ki.dwFlags = KEYEVENTF_KEYUP;
    SendInput(1, &in, sizeof(INPUT));
  }
}

bool OpenAppById(const std::string& id_raw) {
  const std::string id = ToLowerAscii(id_raw);
  std::wstring target;
  if (id == "chrome") {
    target = L"chrome.exe";
  } else if (id == "edge") {
    target = L"msedge.exe";
  } else if (id == "firefox") {
    target = L"firefox.exe";
  } else if (id == "notepad") {
    target = L"notepad.exe";
  } else if (id == "calc" || id == "calculator") {
    target = L"calc.exe";
  } else if (id == "explorer") {
    target = L"explorer.exe";
  } else if (id == "cmd") {
    target = L"cmd.exe";
  } else if (id == "powershell") {
    target = L"powershell.exe";
  } else if (id == "cursor") {
    target = L"cursor.exe";
  } else if (id == "codex" || id == "chatgpt") {
    target = L"ChatGPT.exe";
  } else if (id == "code" || id == "vscode") {
    target = L"code.exe";
  } else if (id == "wechat" || id == "weixin") {
    // Try common install paths; ShellExecuteW still searches PATH/App Paths.
    target = L"WeChat.exe";
  } else if (id == "qq") {
    target = L"QQ.exe";
  } else if (id.find('\\') != std::string::npos || id.find('/') != std::string::npos ||
             id.find('.') != std::string::npos) {
    target = Utf8ToWide(id_raw);
  } else {
    target = Utf8ToWide(id_raw + ".exe");
  }

  HINSTANCE rc = ShellExecuteW(nullptr, L"open", target.c_str(), nullptr, nullptr, SW_SHOWNORMAL);
  return reinterpret_cast<INT_PTR>(rc) > 32;
}

class WasapiWriter {
 public:
  ~WasapiWriter() { Close(); }

  void SetDeviceId(const std::string& id) { device_id_ = id; }

  flutter::EncodableList ListDevices() {
    flutter::EncodableList list;
    EnsureCom();
    IMMDeviceEnumerator* enumerator = nullptr;
    if (FAILED(CoCreateInstance(__uuidof(MMDeviceEnumerator), nullptr, CLSCTX_ALL,
                                __uuidof(IMMDeviceEnumerator), (void**)&enumerator))) {
      return list;
    }
    IMMDeviceCollection* coll = nullptr;
    if (SUCCEEDED(enumerator->EnumAudioEndpoints(eRender, DEVICE_STATE_ACTIVE, &coll))) {
      UINT count = 0;
      coll->GetCount(&count);
      for (UINT i = 0; i < count; i++) {
        IMMDevice* dev = nullptr;
        if (FAILED(coll->Item(i, &dev))) continue;
        LPWSTR id = nullptr;
        dev->GetId(&id);
        IPropertyStore* props = nullptr;
        std::string name = "Device";
        if (SUCCEEDED(dev->OpenPropertyStore(STGM_READ, &props))) {
          PROPVARIANT var;
          PropVariantInit(&var);
          if (SUCCEEDED(props->GetValue(PKEY_Device_FriendlyName, &var)) && var.pwszVal) {
            name = WideToUtf8(var.pwszVal);
          }
          PropVariantClear(&var);
          props->Release();
        }
        flutter::EncodableMap m;
        m[flutter::EncodableValue("id")] = flutter::EncodableValue(WideToUtf8(id));
        m[flutter::EncodableValue("name")] = flutter::EncodableValue(name);
        list.push_back(flutter::EncodableValue(m));
        if (id) CoTaskMemFree(id);
        dev->Release();
      }
      coll->Release();
    }
    enumerator->Release();
    if (list.empty()) {
      flutter::EncodableMap cable;
      cable[flutter::EncodableValue("id")] = flutter::EncodableValue("vb-cable");
      cable[flutter::EncodableValue("name")] =
          flutter::EncodableValue("CABLE Input (install VB-Audio Virtual Cable)");
      list.push_back(flutter::EncodableValue(cable));
    }
    return list;
  }

  bool Begin(int sample_rate, int channels) {
    Close();
    EnsureCom();
    src_rate_ = sample_rate > 0 ? sample_rate : 16000;
    src_ch_ = channels > 0 ? channels : 1;

    IMMDeviceEnumerator* enumerator = nullptr;
    if (FAILED(CoCreateInstance(__uuidof(MMDeviceEnumerator), nullptr, CLSCTX_ALL,
                                __uuidof(IMMDeviceEnumerator), (void**)&enumerator))) {
      return false;
    }

    IMMDevice* device = nullptr;
    HRESULT hr = E_FAIL;
    if (!device_id_.empty() && device_id_ != "vb-cable" && device_id_ != "stub-loopback") {
      hr = enumerator->GetDevice(Utf8ToWide(device_id_).c_str(), &device);
    }
    if (FAILED(hr) || !device) {
      // Prefer a device whose name contains CABLE / BlackHole / VibeMic.
      IMMDeviceCollection* coll = nullptr;
      if (SUCCEEDED(enumerator->EnumAudioEndpoints(eRender, DEVICE_STATE_ACTIVE, &coll))) {
        UINT count = 0;
        coll->GetCount(&count);
        for (UINT i = 0; i < count && !device; i++) {
          IMMDevice* cand = nullptr;
          if (FAILED(coll->Item(i, &cand))) continue;
          IPropertyStore* props = nullptr;
          std::string name;
          if (SUCCEEDED(cand->OpenPropertyStore(STGM_READ, &props))) {
            PROPVARIANT var;
            PropVariantInit(&var);
            if (SUCCEEDED(props->GetValue(PKEY_Device_FriendlyName, &var)) && var.pwszVal) {
              name = WideToUtf8(var.pwszVal);
            }
            PropVariantClear(&var);
            props->Release();
          }
          std::string lower = name;
          for (char& c : lower) c = (char)tolower((unsigned char)c);
          if (lower.find("cable") != std::string::npos ||
              lower.find("blackhole") != std::string::npos ||
              lower.find("vibemic") != std::string::npos ||
              lower.find("voicemeeter") != std::string::npos) {
            device = cand;
          } else {
            cand->Release();
          }
        }
        coll->Release();
      }
    }
    if (!device) {
      enumerator->GetDefaultAudioEndpoint(eRender, eConsole, &device);
    }
    enumerator->Release();
    if (!device) return false;

    hr = device->Activate(__uuidof(IAudioClient), CLSCTX_ALL, nullptr, (void**)&client_);
    device->Release();
    if (FAILED(hr) || !client_) return false;

    WAVEFORMATEX* mix = nullptr;
    hr = client_->GetMixFormat(&mix);
    if (FAILED(hr) || !mix) {
      Close();
      return false;
    }
    mix_ = *mix;
    // Keep ext size if WAVEFORMATEXTENSIBLE ? store pointer copy via heap.
    mix_bytes_ = sizeof(WAVEFORMATEX) + mix->cbSize;
    mix_raw_.assign((uint8_t*)mix, (uint8_t*)mix + mix_bytes_);
    CoTaskMemFree(mix);

    WAVEFORMATEX* fmt = (WAVEFORMATEX*)mix_raw_.data();
    hr = client_->Initialize(AUDCLNT_SHAREMODE_SHARED, 0, 10000000, 0, fmt, nullptr);
    if (FAILED(hr)) {
      Close();
      return false;
    }
    hr = client_->GetService(__uuidof(IAudioRenderClient), (void**)&render_);
    if (FAILED(hr) || !render_) {
      Close();
      return false;
    }
    client_->GetBufferSize(&buffer_frames_);
    client_->Start();
    open_ = true;
    phase_ = 0;
    return true;
  }

  void WriteFloat32(const uint8_t* bytes, size_t len) {
    if (!open_ || !client_ || !render_ || len < 4) return;
    const size_t n_src = len / 4;
    const float* src = reinterpret_cast<const float*>(bytes);

    WAVEFORMATEX* fmt = (WAVEFORMATEX*)mix_raw_.data();
    const int dst_ch = fmt->nChannels;
    const int dst_rate = fmt->nSamplesPerSec;
    const bool is_float = (fmt->wFormatTag == WAVE_FORMAT_IEEE_FLOAT) ||
                          (fmt->wFormatTag == WAVE_FORMAT_EXTENSIBLE && fmt->wBitsPerSample == 32);
    const int bytes_per_samp = fmt->wBitsPerSample / 8;

    // Simple nearest resample 16k ? device rate.
    const double ratio = (double)dst_rate / (double)src_rate_;
    const UINT32 need = (UINT32)std::ceil(n_src * ratio);
    if (need == 0) return;

    UINT32 padding = 0;
    client_->GetCurrentPadding(&padding);
    UINT32 avail = buffer_frames_ > padding ? buffer_frames_ - padding : 0;
    UINT32 frames = need < avail ? need : avail;
    if (frames == 0) return;

    BYTE* data = nullptr;
    if (FAILED(render_->GetBuffer(frames, &data)) || !data) return;

    for (UINT32 i = 0; i < frames; i++) {
      size_t src_i = (size_t)((phase_ + i) / ratio);
      if (src_i >= n_src) src_i = n_src - 1;
      float s = src[src_i];
      if (s > 1.f) s = 1.f;
      if (s < -1.f) s = -1.f;
      BYTE* frame = data + i * fmt->nBlockAlign;
      for (int ch = 0; ch < dst_ch; ch++) {
        if (is_float && bytes_per_samp == 4) {
          *reinterpret_cast<float*>(frame + ch * 4) = s;
        } else if (bytes_per_samp == 2) {
          int16_t v = (int16_t)(s * 32767.f);
          *reinterpret_cast<int16_t*>(frame + ch * 2) = v;
        } else if (bytes_per_samp == 4) {
          *reinterpret_cast<float*>(frame + ch * 4) = s;
        }
      }
    }
    phase_ += frames;
    // Keep phase relative to this packet only.
    phase_ = 0;
    render_->ReleaseBuffer(frames, 0);
  }

  void Close() {
    if (client_) {
      client_->Stop();
    }
    if (render_) {
      render_->Release();
      render_ = nullptr;
    }
    if (client_) {
      client_->Release();
      client_ = nullptr;
    }
    mix_raw_.clear();
    open_ = false;
  }

 private:
  void EnsureCom() {
    static bool once = false;
    if (!once) {
      CoInitializeEx(nullptr, COINIT_MULTITHREADED);
      once = true;
    }
  }

  std::string device_id_;
  IAudioClient* client_ = nullptr;
  IAudioRenderClient* render_ = nullptr;
  WAVEFORMATEX mix_{};
  std::vector<uint8_t> mix_raw_;
  size_t mix_bytes_ = 0;
  UINT32 buffer_frames_ = 0;
  int src_rate_ = 16000;
  int src_ch_ = 1;
  double phase_ = 0;
  bool open_ = false;
};

class VibeMicPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows* registrar) {
    auto audio = std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
        registrar->messenger(), "vibemic/audio",
        &flutter::StandardMethodCodec::GetInstance());
    auto input = std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
        registrar->messenger(), "vibemic/input",
        &flutter::StandardMethodCodec::GetInstance());

    auto plugin = std::make_unique<VibeMicPlugin>();
    auto* raw = plugin.get();
    audio->SetMethodCallHandler(
        [raw](const auto& call, auto result) { raw->HandleAudio(call, std::move(result)); });
    input->SetMethodCallHandler(
        [raw](const auto& call, auto result) { raw->HandleInput(call, std::move(result)); });
    registrar->AddPlugin(std::move(plugin));
  }

  void HandleAudio(const flutter::MethodCall<flutter::EncodableValue>& call,
                   std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
    if (call.method_name() == "listOutputDevices") {
      result->Success(flutter::EncodableValue(wasapi_.ListDevices()));
      return;
    }
    if (call.method_name() == "selectDevice") {
      const auto* args = std::get_if<flutter::EncodableMap>(call.arguments());
      if (args) {
        auto it = args->find(flutter::EncodableValue("id"));
        if (it != args->end()) {
          if (const auto* id = std::get_if<std::string>(&it->second)) {
            wasapi_.SetDeviceId(*id);
          }
        }
      }
      result->Success();
      return;
    }
    if (call.method_name() == "beginSession") {
      int rate = 16000, ch = 1;
      const auto* args = std::get_if<flutter::EncodableMap>(call.arguments());
      if (args) {
        auto r = args->find(flutter::EncodableValue("sampleRate"));
        auto c = args->find(flutter::EncodableValue("channels"));
        if (r != args->end()) {
          if (const auto* v = std::get_if<int32_t>(&r->second)) rate = *v;
        }
        if (c != args->end()) {
          if (const auto* v = std::get_if<int32_t>(&c->second)) ch = *v;
        }
      }
      wasapi_.Begin(rate, ch);
      result->Success();
      return;
    }
    if (call.method_name() == "endSession") {
      wasapi_.Close();
      result->Success();
      return;
    }
    if (call.method_name() == "writeFloat32") {
      const auto* args = std::get_if<flutter::EncodableMap>(call.arguments());
      if (args) {
        auto it = args->find(flutter::EncodableValue("bytes"));
        if (it != args->end()) {
          if (const auto* bytes = std::get_if<std::vector<uint8_t>>(&it->second)) {
            wasapi_.WriteFloat32(bytes->data(), bytes->size());
          }
        }
      }
      result->Success();
      return;
    }
    result->NotImplemented();
  }

  void HandleInput(const flutter::MethodCall<flutter::EncodableValue>& call,
                   std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
    if (call.method_name() == "tapShortcut" ||
        call.method_name() == "keyDown" ||
        call.method_name() == "keyUp") {
      const auto* args = std::get_if<flutter::EncodableMap>(call.arguments());
      if (args) {
        auto it = args->find(flutter::EncodableValue("keys"));
        if (it != args->end()) {
          if (const auto* keys = std::get_if<flutter::EncodableList>(&it->second)) {
            if (call.method_name() == "tapShortcut") {
              TapShortcut(*keys);
            } else {
              SendVks(VksFromList(*keys), call.method_name() == "keyDown");
            }
          }
        }
      }
      result->Success();
      return;
    }
    if (call.method_name() == "voiceBegin" || call.method_name() == "voiceEnd") {
      std::string modifier = "ctrlWin";
      const auto* args = std::get_if<flutter::EncodableMap>(call.arguments());
      if (args) {
        auto it = args->find(flutter::EncodableValue("modifier"));
        if (it != args->end()) {
          if (const auto* s = std::get_if<std::string>(&it->second)) {
            modifier = *s;
          }
        }
      }
      SendModifierChord(modifier, call.method_name() == "voiceBegin");
      result->Success();
      return;
    }
    if (call.method_name() == "openApp") {
      const auto* args = std::get_if<flutter::EncodableMap>(call.arguments());
      if (args) {
        auto it = args->find(flutter::EncodableValue("id"));
        if (it != args->end()) {
          if (const auto* id = std::get_if<std::string>(&it->second)) {
            OpenAppById(*id);
          }
        }
      }
      result->Success();
      return;
    }
    result->NotImplemented();
  }

 private:
  WasapiWriter wasapi_;
};

}  // namespace

void VibeMicPluginRegisterWithRegistrar(FlutterDesktopPluginRegistrarRef registrar) {
  VibeMicPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
