#include "include/liveness_detection_flutter_plugin/liveness_detection_flutter_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "liveness_detection_flutter_plugin.h"

void LivenessDetectionFlutterPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  liveness_detection_flutter_plugin::LivenessDetectionFlutterPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
