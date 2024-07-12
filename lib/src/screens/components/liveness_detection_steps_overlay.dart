import 'dart:ui';

import 'package:dashed_circular_progress_bar/dashed_circular_progress_bar.dart';
import 'package:flutter_stepindicator/flutter_stepindicator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liveness_detection_flutter_plugin/index.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LivenessDetectionStepOverlay extends StatefulWidget {
  final List<LivenessDetectionStepItem> steps;
  final VoidCallback onCompleted;
  final VoidCallback onTakingPicture;
  const LivenessDetectionStepOverlay({super.key, required this.steps, required this.onCompleted, required this.onTakingPicture});

  @override
  State<LivenessDetectionStepOverlay> createState() => LivenessDetectionStepOverlayState();
}

class LivenessDetectionStepOverlayState extends State<LivenessDetectionStepOverlay> {
   int get currentIndex {
    return _currentIndex;
  }

   int page = 0;
   int counter = 0;
   List list = [];

  bool _isLoading = false;
  double progress = 0.0;
  bool _progressBar = false;

  //* MARK: - Private Variables
  //? =========================================================
  int _currentIndex = 0;

  late final PageController _pageController;

  //* MARK: - Life Cycle Methods
  //? =========================================================
  @override
  void initState() {
    _pageController = PageController(
      initialPage: 0,
    );
    var idx = 0;
    widget.steps.forEach((element) {
      list.add(idx); idx++;
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
       return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.transparent,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _buildBody(),
          Visibility(
            visible: _isLoading,
            child: Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                color: const Color.fromARGB(255, 0, 112, 224),
                size: 80,
              ),
            ),
          ),
        ],
      ),
    );
  }
   Future<void> nextPage() async {
    if (_isLoading) {
      return;
    }
    if ((_currentIndex + 1) <= (widget.steps.length - 1)) {
      //Move to next step
      _showLoader();
      await Future.delayed(
        const Duration(
          seconds: 2,
        ),
      );
      setState(() {
        page++;
        counter++;
      });
      await _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeIn,
      );
      await Future.delayed(
        const Duration(milliseconds: 250),
      );

      _hideLoader();
      setState(() => _currentIndex++);

    } else {
      setState(() {
        page++;
        counter++;
      });

      await Future.delayed(
        const Duration(milliseconds: 250),
      );

      widget.onTakingPicture();

      setState(() {
        _progressBar = true;
      });

      for (int i = 0; i <= 110; i++) {
        progress = i.toDouble();
        setState(() {

        });
        await Future.delayed(const Duration(milliseconds: (3000 ~/ 100))); // Delay calculation
      }

      setState(() {
        _progressBar = false;
      });

      widget.onCompleted();
    }
  }

  void reset() {
    page = 0;
    counter = 0;
    _pageController.jumpToPage(0);
    setState(() => _currentIndex = 0);
  }

  //* MARK: - Private Methods for Business Logic
  //? =========================================================
  void _showLoader() => setState(
        () => _isLoading = true,
      );

  void _hideLoader() => setState(
        () => _isLoading = false,
      );

  //* MARK: - Private Methods for UI Components
  //? =========================================================
  Widget _buildBody() {
    if(_progressBar){
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 350,
            width: 350,
            child: Center(
              child: DashedCircularProgressBar.aspectRatio(
                aspectRatio: 1, // width ÷ height
                progress: progress,
                startAngle: 0,
                sweepAngle: 360,
                foregroundColor: const Color.fromARGB(255, 0, 112, 224),
                backgroundColor: const Color(0xffeeeeee),
                foregroundStrokeWidth: 15,
                backgroundStrokeWidth: 15,
                animation: true,
                seekSize: 6,
                seekColor: const Color(0xffeeeeee),
              ),
            ),
          ),
          const SizedBox(height: 20,),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15)
              ),
              width: 100.0, // Adjust width as needed
              height: 40.0, // Adjust height as needed
              child: Center(child: Text("Pengambilan Foto", style: GoogleFonts.workSans(fontSize: 20), )),
            ),
          ),
          const SizedBox(height: 100,)
        ],
      );
    }else{
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Spacer(
            flex: 14,
          ),
          Flexible(
            flex: 2,
            child: AbsorbPointer(
              absorbing: true,
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.steps.length + 1,
                itemBuilder: (context, index) {
                  return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      padding: const EdgeInsets.all(10),
                      child: _actionBox(widget.steps[index].title));
                },
              ),
            ),
          ),
          const SizedBox(height: 10,),
          SizedBox(height: 40,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7),
              child: FlutterStepIndicator(
                height: 28,
                paddingLine: const EdgeInsets.symmetric(horizontal: 0),
                positiveColor: const Color.fromARGB(255, 0, 112, 224),
                progressColor: const Color(0xFFEA9C00),
                negativeColor: const Color(0xFFD5D5D5),
                padding: const EdgeInsets.all(4),
                list: list,division: counter,
                onChange: (i) {},
                page: page,
                onClickItem: (p0) {

                },
              ),
            ),
          ),
          const SizedBox(height: 30,)
        ],
      );
    }
  }

  Widget _actionBox(String text){
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0), // Adjust as needed
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0), // Adjust sigmaX and sigmaY for blur intensity
        child: Container(
          alignment: Alignment.center,
          width: 100.0, // Adjust width as needed
          height: 70.0, // Adjust height as needed
          color: Colors.black45.withOpacity(0.2), // Adjust opacity and color as needed
          child: Center(
            child: Text(
              text,
              style: GoogleFonts.workSans(color: Colors.white, fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }

}