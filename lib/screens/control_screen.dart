import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:huntrix_lightstick_app/bluetooth/ble_service.dart';
import 'package:huntrix_lightstick_app/widgets/floating_animator.dart';
import 'package:huntrix_lightstick_app/widgets/pulsing_animator.dart';
import 'package:huntrix_lightstick_app/widgets/pulsing_opacity_animator.dart';
import 'package:huntrix_lightstick_app/widgets/rotating_animator.dart';
import 'package:huntrix_lightstick_app/widgets/sheen_animator.dart';

import 'dart:math';

class ControlScreen extends StatefulWidget {
  const ControlScreen({super.key});

  @override
  State<ControlScreen> createState() => _MyControlScreenState();
}

class _MyControlScreenState extends State<ControlScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque, // ensures taps anywhere are detected
      onTap: () {
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => const NextScreen()),
        // );
      },
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: .spaceEvenly,
              children: [
                Expanded(
                  flex: 2,
                  child: Align(
                    alignment: Alignment.center,
                    child: FractionallySizedBox(
                      heightFactor: 0.75,
                      child: Transform.rotate(
                        angle: 0,
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            PulsingOpacityAnimator(
                              duration: Duration(milliseconds: 2500),
                              minOpacity: 0,
                              maxOpacity: 1,
                              child: SvgPicture.asset(
                                'assets/lightstick_glow_overlay.svg',
                              ),
                            ),
                            SvgPicture.asset('assets/lightstick_drawing.svg'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
