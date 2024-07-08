import 'package:flutter_test/flutter_test.dart';
import 'package:liveness_detection_flutter_plugin/liveness_detection_flutter_plugin.dart';
import 'package:liveness_detection_flutter_plugin/liveness_detection_flutter_plugin_platform_interface.dart';
import 'package:liveness_detection_flutter_plugin/liveness_detection_flutter_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockLivenessDetectionFlutterPluginPlatform
    with MockPlatformInterfaceMixin
    implements LivenessDetectionFlutterPluginPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final LivenessDetectionFlutterPluginPlatform initialPlatform = LivenessDetectionFlutterPluginPlatform.instance;

  test('$MethodChannelLivenessDetectionFlutterPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelLivenessDetectionFlutterPlugin>());
  });

  test('getPlatformVersion', () async {
    LivenessDetectionFlutterPlugin livenessDetectionFlutterPlugin = LivenessDetectionFlutterPlugin.instance;
    MockLivenessDetectionFlutterPluginPlatform fakePlatform = MockLivenessDetectionFlutterPluginPlatform();
    LivenessDetectionFlutterPluginPlatform.instance = fakePlatform;

    expect(await livenessDetectionFlutterPlugin.getPlatformVersion(), '42');
  });
}
