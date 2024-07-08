import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liveness_detection_flutter_plugin/liveness_detection_flutter_plugin_method_channel.dart';

void main() {
  MethodChannelLivenessDetectionFlutterPlugin platform = MethodChannelLivenessDetectionFlutterPlugin();
  const MethodChannel channel = MethodChannel('liveness_detection_flutter_plugin');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
