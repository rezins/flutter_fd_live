import 'package:liveness_detection_flutter_plugin/index.dart';

class LivenessDetectionTutorialScreen extends StatefulWidget {
  final VoidCallback onStartTap;
  const LivenessDetectionTutorialScreen({super.key, required this.onStartTap});

  @override
  State<LivenessDetectionTutorialScreen> createState() =>
      _LivenessDetectionTutorialScreenState();
}

class _LivenessDetectionTutorialScreenState
    extends State<LivenessDetectionTutorialScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Spacer(
              flex: 2,
            ),
            Text(
              LivenessDetectionStringConstant.label.livenessDetection,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              LivenessDetectionStringConstant.label.infoSubText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.blueGrey,
                fontWeight: FontWeight.normal,
                fontSize: 18,
                height: 1.5,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 5,
                        spreadRadius: 2.5,
                        color: Colors.black12,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Center(
                            child: Container(
                              child: _buildPointWidget(
                                index: 1,
                                title: LivenessDetectionStringConstant
                                    .label.goodLighting,
                                subTitle: LivenessDetectionStringConstant
                                    .label.goodLightingSubText,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Center(
                            child: _buildPointWidget(
                              index: 2,
                              title: LivenessDetectionStringConstant
                                  .label.lookStraight,
                              subTitle: LivenessDetectionStringConstant
                                  .label.lookStraightSubText,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Center(
              child: ElevatedButton(
                onPressed: () => widget.onStartTap(),
                style: TextButton.styleFrom(
                  elevation: 3,
                  backgroundColor: const Color(0xff267CFD),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                child: Text(
                  LivenessDetectionStringConstant.button.start,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildPointWidget({
    required int index,
    required String title,
    required String subTitle,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          backgroundColor: Colors.green.shade900,
          child: Text(
            "$index",
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        const Spacer(),
        Expanded(
          flex: 10,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                textAlign: TextAlign.start,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                subTitle,
                textAlign: TextAlign.start,
                style: const TextStyle(
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
