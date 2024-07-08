import 'package:liveness_detection_flutter_plugin/index.dart';

class LivenessConfig {
   /// Types of checks to be added while detecting the face.
  final List<LivenessDetectionStepItem> steps;

  /// A boolean value that defines weather the detection should start with a `Info` screen or not.
  /// Default is *false*
  final bool startWithInfoScreen;

  LivenessConfig({
    required this.steps,
    this.startWithInfoScreen = false,
  }) {
    assert(
      steps.isNotEmpty,
      '''
Cannot pass an empty array of [LivenessDetectionStepItem].
      ''',
    );
  }
}
