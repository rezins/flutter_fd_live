import 'package:liveness_detection_flutter_plugin/index.dart';

class MachineLearningHelper {
  MachineLearningHelper._privateConstructor();
  static final MachineLearningHelper instance =
      MachineLearningHelper._privateConstructor();

  final FaceDetector faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableClassification: true,
      enableLandmarks: true,
      enableTracking: true,
      performanceMode: FaceDetectorMode.accurate,
    ),
  );

  Future<List<Face>> processInputImage(InputImage imgFile) async {
    for (var i = 0; i < 3; i++) {
      final List<Face> faces = await faceDetector.processImage(
        imgFile,
      );
      if (faces.isNotEmpty) {
        return faces;
      }
    }
    return [];
  }
}
