#ifndef FLUTTER_PLUGIN_LIVENESS_DETECTION_FLUTTER_PLUGIN_H_
#define FLUTTER_PLUGIN_LIVENESS_DETECTION_FLUTTER_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace liveness_detection_flutter_plugin {

class LivenessDetectionFlutterPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  LivenessDetectionFlutterPlugin();

  virtual ~LivenessDetectionFlutterPlugin();

  // Disallow copy and assign.
  LivenessDetectionFlutterPlugin(const LivenessDetectionFlutterPlugin&) = delete;
  LivenessDetectionFlutterPlugin& operator=(const LivenessDetectionFlutterPlugin&) = delete;

 private:
  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace liveness_detection_flutter_plugin

#endif  // FLUTTER_PLUGIN_LIVENESS_DETECTION_FLUTTER_PLUGIN_H_
