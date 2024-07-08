import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'liveness_detection_flutter_plugin_platform_interface.dart';


class MethodChannelLivenessDetectionFlutterPlugin extends LivenessDetectionFlutterPluginPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('liveness_detection_flutter_plugin');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
