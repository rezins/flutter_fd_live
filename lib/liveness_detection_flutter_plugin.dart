import 'package:liveness_detection_flutter_plugin/index.dart';
import 'package:liveness_detection_flutter_plugin/src/screens/selfie_register_user_screen.dart';

class LivenessDetectionFlutterPlugin {
  LivenessDetectionFlutterPlugin._privateConstructor();
  static final LivenessDetectionFlutterPlugin instance =
      LivenessDetectionFlutterPlugin._privateConstructor();
  final List<LivenessThreshold> _thresholds = [];
  Color? _contourDetectionColor;

  late EdgeInsets _safeAreaPadding;

  List<LivenessThreshold> get thresholdConfig {
    return _thresholds;
  }

  EdgeInsets get safeAreaPadding {
    return _safeAreaPadding;
  }

  Color? get contourDetectionColor {
    return _contourDetectionColor;
  }

  // Fungsi Liveness Detection
  Future<String?> livenessDetection(
    BuildContext context, {
    required LivenessConfig config,
  }) async {
    final String? capturedFacePath = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LivenessDetectionScreen(
          config: config,
        ),
      ),
    );
    return capturedFacePath;
  }

// Fungsi Selfie Automatic Face Motion
  Future<List<String?>> selfiesRegisterUser(
    BuildContext context, {
    required LivenessConfig config,
  }) async {
    List<String?>? listCapturedFacePath = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SelfieRegisterUserScreen(config: config),
      ),
    );
    return listCapturedFacePath ?? [];
  }

  void configure({
    required List<LivenessThreshold> thresholds,
    Color contourColor = const Color(0xffab48e0),
  }) {
    assert(
      thresholds.isNotEmpty,
      "Threshold configuration cannot be empty",
    );
    _thresholds.clear();
    _thresholds.addAll(thresholds);
    _contourDetectionColor = contourColor;
  }

  Future<String?> getPlatformVersion() {
    return LivenessDetectionFlutterPluginPlatform.instance.getPlatformVersion();
  }
}
