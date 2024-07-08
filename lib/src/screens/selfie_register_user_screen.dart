import 'dart:async';
import 'dart:ui' as ui;
import 'package:collection/collection.dart';
import 'package:liveness_detection_flutter_plugin/index.dart';

List<CameraDescription> availableCams = [];

class SelfieRegisterUserScreen extends StatefulWidget {
  final LivenessConfig config;
  const SelfieRegisterUserScreen({super.key, required this.config});

  @override
  State<SelfieRegisterUserScreen> createState() =>
      _SelfieRegisterUserScreenState();
}

class _SelfieRegisterUserScreenState extends State<SelfieRegisterUserScreen> {
  late bool _isInfoStepCompleted;
  late final List<LivenessDetectionStepItem> steps;
  CameraController? _cameraController;
  CustomPaint? _customPaint;
  int _cameraIndex = 0;
  bool _isBusy = false;
  final GlobalKey<SelfieRegisterStepsOverlayState> _stepsKey =
      GlobalKey<SelfieRegisterStepsOverlayState>();
  bool _isProcessingStep = false;
  bool _didCloseEyes = false;
  bool _isTakingPicture = false;
  Timer? _timerToDetectFace;
  List<String> imagesPath = [];

  late final List<LivenessDetectionStepItem> _steps;

  @override
  void initState() {
    _preInitCallBack();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _postFrameCallBack(),
    );
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _timerToDetectFace?.cancel();
    _timerToDetectFace = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _buildBody(),
      ),
    );
  }

  void _preInitCallBack() {
    _steps = widget.config.steps;
    _isInfoStepCompleted = !widget.config.startWithInfoScreen;
  }

  void _postFrameCallBack() async {
    availableCams = await availableCameras();
    if (availableCams.any(
      (element) =>
          element.lensDirection == CameraLensDirection.front &&
          element.sensorOrientation == 90,
    )) {
      _cameraIndex = availableCams.indexOf(
        availableCams.firstWhere((element) =>
            element.lensDirection == CameraLensDirection.front &&
            element.sensorOrientation == 90),
      );
    } else {
      _cameraIndex = availableCams.indexOf(
        availableCams.firstWhere(
          (element) => element.lensDirection == CameraLensDirection.front,
        ),
      );
    }
    if (!widget.config.startWithInfoScreen) {
      _startLiveFeed();
    }
  }

  void _startLiveFeed() async {
    final camera = availableCams[_cameraIndex];
    _cameraController = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
    );
    _cameraController?.initialize().then((_) {
      if (!mounted) {
        return;
      }
      _cameraController?.startImageStream(_processCameraImage);
      setState(() {});
    });
  }

  Future<void> _processCameraImage(CameraImage cameraImage) async {
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in cameraImage.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize = Size(
      cameraImage.width.toDouble(),
      cameraImage.height.toDouble(),
    );

    final camera = availableCams[_cameraIndex];
    final imageRotation = InputImageRotationValue.fromRawValue(
      camera.sensorOrientation,
    );
    if (imageRotation == null) return;

    final inputImageFormat = InputImageFormatValue.fromRawValue(
      cameraImage.format.raw,
    );
    if (inputImageFormat == null) return;

    final planeData = cameraImage.planes.map(
      (Plane plane) {
        return InputImagePlaneMetadata(
          bytesPerRow: plane.bytesPerRow,
          height: plane.height,
          width: plane.width,
        );
      },
    ).toList();

    final inputImageData = InputImageData(
      size: imageSize,
      imageRotation: imageRotation,
      inputImageFormat: inputImageFormat,
      planeData: planeData,
    );

    final inputImage = InputImage.fromBytes(
      bytes: bytes,
      inputImageData: inputImageData,
    );

    _processImage(inputImage);
  }

  Future<void> _processImage(InputImage inputImage) async {
    if (_isBusy) {
      return;
    }
    _isBusy = true;
    final faces =
        await MachineLearningHelper.instance.processInputImage(inputImage);

    if (inputImage.inputImageData?.size != null &&
        inputImage.inputImageData?.imageRotation != null) {
      if (faces.isEmpty) {
        _resetSteps();
      } else {
        final firstFace = faces.first;
        final painter = LivenessDetectionPainter(
          firstFace,
          inputImage.inputImageData!.size,
          inputImage.inputImageData!.imageRotation,
        );
        _customPaint = CustomPaint(
          painter: painter,
          child: Container(
            color: Colors.transparent,
            height: double.infinity,
            width: double.infinity,
          ),
        );
        if (_isProcessingStep &&
            _steps[_stepsKey.currentState?.currentIndex ?? 0].step ==
                LivenessDetectionStep.blink) {
          if (_didCloseEyes) {
            if ((faces.first.leftEyeOpenProbability ?? 1.0) < 0.75 &&
                (faces.first.rightEyeOpenProbability ?? 1.0) < 0.75) {
              await _completeStep(
                step: _steps[_stepsKey.currentState?.currentIndex ?? 0].step,
              );
            }
          }
        }
        _detect(
          face: faces.first,
          step: _steps[_stepsKey.currentState?.currentIndex ?? 0].step,
        );
      }
    } else {
      _resetSteps();
    }
    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _completeStep({
    required LivenessDetectionStep step,
  }) async {
    final int indexToUpdate = _steps.indexWhere(
      (p0) => p0.step == step,
    );

    _steps[indexToUpdate] = _steps[indexToUpdate].copyWith(
      isCompleted: true,
    );
    if (mounted) {
      setState(() {});
    }
    await _stepsKey.currentState?.nextPage();
    _stopProcessing();
  }

  void _takePicture(int pictureNumber) async {
    try {
      if (_cameraController == null) return;
      if (_isTakingPicture) {
        return;
      }
      setState(() => _isTakingPicture = true);
      final XFile? clickedImage = await _cameraController?.takePicture();
      if (clickedImage == null) {
        _startLiveFeed();
        return;
      }
      imagesPath.add(clickedImage.path);
      if (pictureNumber == 5) {
        await _cameraController?.stopImageStream();
        _onDetectionCompleted();
      }
    } catch (e) {
      _startLiveFeed();
    } finally {
      if (pictureNumber != 5) {
        setState(() => _isTakingPicture = false);
      }
    }
  }

  void _onDetectionCompleted() {
    if (mounted) {
      Navigator.of(context).pop(imagesPath);
    }
  }

  // void _resetSteps() async {
  //   for (var p0 in _steps) {
  //     final int index = _steps.indexWhere(
  //       (p1) => p1.step == p0.step,
  //     );
  //     _steps[index] = _steps[index].copyWith(
  //       isCompleted: false,
  //     );
  //   }
  //   _customPaint = null;
  //   _didCloseEyes = false;
  //   if (_stepsKey.currentState?.currentIndex != 0) {
  //     _stepsKey.currentState?.reset();
  //   }
  //   if (mounted) {
  //     setState(() {});
  //   }
  // }

  void _resetSteps() async {
    for (var p0 in _steps) {
      final int index = _steps.indexWhere(
        (p1) => p1.step == p0.step,
      );
      _steps[index] = _steps[index].copyWith(
        isCompleted: false,
      );
    }
    _customPaint = null;
    _didCloseEyes = false;
    if (_stepsKey.currentState?.currentIndex != 0) {
      _stepsKey.currentState?.reset();
    }
    imagesPath.clear(); // Hapus semua path gambar
    if (mounted) {
      setState(() {});
    }
  }

  void _startProcessing() {
    if (!mounted) {
      return;
    }
    setState(
      () => _isProcessingStep = true,
    );
  }

  void _stopProcessing() {
    if (!mounted) {
      return;
    }
    setState(
      () => _isProcessingStep = false,
    );
  }

  void _detect({
    required Face face,
    required LivenessDetectionStep step,
  }) async {
    if (_isProcessingStep) {
      return;
    }
    switch (step) {
      case LivenessDetectionStep.smile:
        final LivenessThresholdSmile? smileThreshold =
            LivenessDetectionFlutterPlugin.instance.thresholdConfig
                .firstWhereOrNull(
          (p0) => p0 is LivenessThresholdSmile,
        ) as LivenessThresholdSmile?;
        if ((face.smilingProbability ?? 0) >
            (smileThreshold?.probability ?? 0.75)) {
          _startProcessing();
          _takePicture(1);
          await _completeStep(step: step);
        }
        break;
      case LivenessDetectionStep.turnRight:
        final LivenessThresholdHead? headTurnThreshold =
            LivenessDetectionFlutterPlugin.instance.thresholdConfig
                .firstWhereOrNull(
          (p0) => p0 is LivenessThresholdHead,
        ) as LivenessThresholdHead?;
        if ((face.headEulerAngleY ?? 0) <
            (headTurnThreshold?.rotationAngle ?? -25)) {
          _startProcessing();
          _takePicture(2);
          await _completeStep(step: step);
        }
        break;
      case LivenessDetectionStep.turnLeft:
        final LivenessThresholdHead? headTurnThreshold =
            LivenessDetectionFlutterPlugin.instance.thresholdConfig
                .firstWhereOrNull(
          (p0) => p0 is LivenessThresholdHead,
        ) as LivenessThresholdHead?;
        if ((face.headEulerAngleY ?? 0) >
            (headTurnThreshold?.rotationAngle ?? 25)) {
          _startProcessing();
          _takePicture(3);
          await _completeStep(step: step);
        }
        break;
      case LivenessDetectionStep.lookUp:
        final LivenessThresholdHead? headTurnThreshold =
            LivenessDetectionFlutterPlugin.instance.thresholdConfig
                .firstWhereOrNull(
          (p0) => p0 is LivenessThresholdHead,
        ) as LivenessThresholdHead?;
        if ((face.headEulerAngleX ?? 0) >
            (headTurnThreshold?.rotationAngle ?? 15)) {
          _startProcessing();
          _takePicture(4);
          await _completeStep(step: step);
        }
        break;
      case LivenessDetectionStep.lookDown:
        final LivenessThresholdHead? headTurnThreshold =
            LivenessDetectionFlutterPlugin.instance.thresholdConfig
                .firstWhereOrNull(
          (p0) => p0 is LivenessThresholdHead,
        ) as LivenessThresholdHead?;
        if ((face.headEulerAngleX ?? 0) <
            (headTurnThreshold?.rotationAngle ?? -15)) {
          _startProcessing();
          _takePicture(5);
          await _completeStep(step: step);
        }
        break;
      default:
        break;
    }
  }

  Widget _buildBody() {
    return Stack(
      children: [
        _isInfoStepCompleted
            ? _buildDetectionBody()
            : LivenessDetectionTutorialScreen(
                onStartTap: () {
                  if (mounted) {
                    setState(
                      () => _isInfoStepCompleted = true,
                    );
                  }
                  _startLiveFeed();
                },
              ),
      ],
    );
  }

  Widget _buildDetectionBody() {
    if (_cameraController == null ||
        _cameraController?.value.isInitialized == false) {
      return const Center(
        child: CircularProgressIndicator.adaptive(),
      );
    }
    final size = MediaQuery.of(context).size;
    var scale = size.aspectRatio * _cameraController!.value.aspectRatio;
    if (scale < 1) scale = 1 / scale;
    final Widget cameraView = CameraPreview(_cameraController!);
    return Stack(
      fit: StackFit.expand,
      children: [
        Center(
          child: cameraView,
        ),
        BackdropFilter(
          filter: ui.ImageFilter.blur(
            sigmaX: 5.0,
            sigmaY: 5.0,
          ),
          child: Container(
            color: Colors.transparent,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        Center(
          child: cameraView,
        ),
        if (_customPaint != null) _customPaint!,
        SelfieRegisterStepsOverlay(
          key: _stepsKey,
          steps: _steps,
          onCompleted: () {},
        ),
      ],
    );
  }
}
