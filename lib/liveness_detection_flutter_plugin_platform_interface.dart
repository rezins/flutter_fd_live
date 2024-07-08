import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'liveness_detection_flutter_plugin_method_channel.dart';

abstract class LivenessDetectionFlutterPluginPlatform extends PlatformInterface {
  /// Constructs a LivenessDetectionFlutterPluginPlatform.
  LivenessDetectionFlutterPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static LivenessDetectionFlutterPluginPlatform _instance = MethodChannelLivenessDetectionFlutterPlugin();

  /// The default instance of [LivenessDetectionFlutterPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelLivenessDetectionFlutterPlugin].
  static LivenessDetectionFlutterPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [LivenessDetectionFlutterPluginPlatform] when
  /// they register themselves.
  static set instance(LivenessDetectionFlutterPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
