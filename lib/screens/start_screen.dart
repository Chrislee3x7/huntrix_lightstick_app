import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:huntrix_lightstick_app/widgets/pulsing_animator.dart';
import 'package:huntrix_lightstick_app/screens/connection_screen.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ConnectionScreen()),
        );
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: .spaceAround,
            children: [
              Flexible(
                flex: 2,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: FractionallySizedBox(
                    widthFactor: 0.7,
                    child: Image.asset('assets/logo.png'),
                    // child: SvgPicture.asset(
                    //   'assets/logo.svg',
                    //   height: 150.h,
                    //   width: 150.w,
                    // ),
                  ),
                ),
              ),
              Spacer(),
              Flexible(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: PulsingAnimator(
                    duration: Duration(milliseconds: 1500),
                    child: Text("Tap anywhere to start"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
