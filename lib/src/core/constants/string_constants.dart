// ignore_for_file: library_private_types_in_public_api

class LivenessDetectionStringConstant {
  static _LivenessDetectionString label = _LivenessDetectionString();
  static _LivenessButtonString button = _LivenessButtonString();
}

class _LivenessDetectionString {
  final String livenessDetection = "Liveness Detection";
  final String goodLighting = "Pencahayaan Cukup";
  final String lookStraight = "Pandangan Lurus Kedepan";
  final String goodLightingSubText =
      "Pastikan kamu berada di area yang memiliki pencahayaan yang cukup dan kedua telinga tidak tertutup oleh apapun";
  final String lookStraightSubText =
      "Pegang ponselmu sejajar dengan mata dan luruskan pandangan ke kamera";
  final String infoSubText =
      "Sistem menggunakan selfie untuk membandingkan foto untuk langkah selanjutnya";
}

class _LivenessButtonString {
  final String start = "Mulai Sistem Liveness Detection";
}
