// ignore_for_file: implementation_imports
import 'package:liveness_detection_flutter_plugin/index.dart';

void main() {
  runApp(const MaterialApp(
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String?> capturedImages = [];
  String? imgPath;
  List<LivenessDetectionStepItem> stepLiveness = [
    LivenessDetectionStepItem(
      step: LivenessDetectionStep.blink,
      title: "testing kedip",
      isCompleted: false,
    ),
    LivenessDetectionStepItem(
      step: LivenessDetectionStep.lookUp,
      title: "testing atas",
      isCompleted: false,
    ),
    LivenessDetectionStepItem(
      step: LivenessDetectionStep.lookDown,
      title: "testing bawah",
      isCompleted: false,
    ),
    LivenessDetectionStepItem(
      step: LivenessDetectionStep.turnRight,
      title: "testing kanan",
      isCompleted: false,
    ),
    LivenessDetectionStepItem(
      step: LivenessDetectionStep.turnLeft,
      title: "testing kiri",
      isCompleted: false,
    ),
    LivenessDetectionStepItem(
      step: LivenessDetectionStep.smile,
      title: "testing senyum",
      isCompleted: false,
    ),
  ];
  List<LivenessDetectionStepItem> stepSelfies = [
    LivenessDetectionStepItem(
      step: LivenessDetectionStep.smile,
      title: "Senyum",
      isCompleted: false,
    ),
    LivenessDetectionStepItem(
      step: LivenessDetectionStep.turnRight,
      title: "Kanan",
      isCompleted: false,
    ),
    LivenessDetectionStepItem(
      step: LivenessDetectionStep.turnLeft,
      title: "Kiri",
      isCompleted: false,
    ),
    LivenessDetectionStepItem(
      step: LivenessDetectionStep.lookUp,
      title: "Atas",
      isCompleted: false,
    ),
    LivenessDetectionStepItem(
      step: LivenessDetectionStep.lookDown,
      title: "Bawah",
      isCompleted: false,
    ),
  ];
  @override
  void initState() {
    super.initState();
    stepLiveness.shuffle();
  }

  @override
  Widget build(BuildContext context) {
    stepLiveness.shuffle();
    return Scaffold(
      body: Center(
          child: ListView(
        shrinkWrap: true,
        children: [
          imgPath != null
              ? Align(
                  child: SizedBox(
                    height: 100,
                    width: 100,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.file(
                        File(imgPath!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
          ElevatedButton(
              onPressed: () async {
                final String? response = await LivenessDetectionFlutterPlugin
                    .instance
                    .livenessDetection(
                  context,
                  config: LivenessConfig(

                    steps: stepLiveness,
                    startWithInfoScreen: false,
                  ),
                );
                setState(() {
                  imgPath = response;
                  print(imgPath);
                });
              },
              child: const Text('Sistem Liveness Detection')),
          ElevatedButton(
              onPressed: () async {
                final List<String?> listFace =
                    await LivenessDetectionFlutterPlugin.instance
                        .selfiesRegisterUser(
                  context,
                  config: LivenessConfig(
                    steps: stepSelfies,
                  ),
                );
                setState(() {
                  capturedImages = listFace;
                });
              },
              child: const Text('Sistem Selfie Automatic Face Motion')),
          ListView.builder(
            shrinkWrap: true,
            primary: false,
            itemCount: capturedImages.length,
            itemBuilder: (context, index) {
              if (capturedImages[index] != null) {
                return Align(
                  child: SizedBox(
                    height: 100,
                    width: 100,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.file(
                        File(capturedImages[index]!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
        ],
      )),
    );
  }
}
