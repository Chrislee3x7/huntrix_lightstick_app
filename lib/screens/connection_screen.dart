import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

import 'package:huntrix_lightstick_app/bluetooth/ble_service.dart';
import 'package:huntrix_lightstick_app/widgets/floating_animator.dart';
import 'package:huntrix_lightstick_app/widgets/pulsing_animator.dart';
import 'package:huntrix_lightstick_app/widgets/pulsing_opacity_animator.dart';
import 'package:huntrix_lightstick_app/widgets/rotating_animator.dart';
import 'package:huntrix_lightstick_app/widgets/sheen_animator.dart';

import 'dart:math';

class ConnectionScreen extends StatefulWidget {
  const ConnectionScreen({super.key});

  @override
  State<ConnectionScreen> createState() => _MyConnectionScreenState();
}

class _MyConnectionScreenState extends State<ConnectionScreen> {
  bool lightstickDiscovered = false;
  final BleService _bleService = BleService();
  DiscoveredDevice? _foundLightstick;

  @override
  void initState() {
    super.initState();
    _startScan();
  }

  void _startScan() async {
    print("Starting scan");
    _foundLightstick = await _bleService.scanForLightstick(
      name: 'Huntrix Lightstick',
      timeout: Duration(seconds: 10),
    );
    if (_foundLightstick == null) {
      print("Was not able to find lightstick :(");
      return;
    }
    setState(() {
      lightstickDiscovered = true;
    });
    print("Found lightstick!!!");
  }

  void _connectLightstick() async {
    await _bleService.connectLightstick(
      _foundLightstick!,
      onConnect: () {
        print("successfully connected to lightstick");
      },
      onDisconnect: () {
        setState(() {
          lightstickDiscovered = false;
        });
      },
    );
  }

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
                    child: FloatingAnimator(
                      offset: 12,
                      duration: Duration(milliseconds: 2500),
                      child: FractionallySizedBox(
                        heightFactor: 0.75,
                        child: Transform.rotate(
                          angle: pi / 6,
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
                ),
                Expanded(
                  flex: 1,
                  child: !lightstickDiscovered
                      ? Container(
                          margin: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 12.w,
                                ),
                                decoration: BoxDecoration(
                                  color: Color(0xFFC4E3FF),
                                  borderRadius: BorderRadius.circular(
                                    8.r,
                                  ), // rounded corners
                                ),
                                child: Text(
                                  "Make sure your lightstick has battery and is set to bluetooth mode indicated by a pulsing blue pattern.",
                                  textAlign: .center,
                                  style: TextStyle(fontSize: 14.sp),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topCenter,
                                child: Container(
                                  margin: EdgeInsets.only(top: 20.h),
                                  child: SheenAnimator(
                                    duration: Duration(milliseconds: 1000),
                                    delay: Duration(milliseconds: 1500),
                                    sheenOpacity: 1,
                                    sheenColor: Color.fromRGBO(
                                      255,
                                      255,
                                      255,
                                      1,
                                    ),
                                    sheenWidth: 0.5,
                                    child: Text("Searching..."),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Center(
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: FractionallySizedBox(
                              widthFactor: 0.5,
                              heightFactor: 0.5,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  SvgPicture.asset('assets/connect_button.svg'),
                                  PulsingAnimator(
                                    minScale: 1.05,
                                    maxScale: 1.12,
                                    duration: Duration(seconds: 4),
                                    child: RotatingAnimator(
                                      duration: Duration(
                                        seconds: 5,
                                      ), // rotation speed
                                      direction: RotationDirection.clockwise,
                                      child: SvgPicture.asset(
                                        'assets/connect_button_effect_gold.svg',
                                      ),
                                    ),
                                  ),
                                  PulsingAnimator(
                                    minScale: 1.05,
                                    maxScale: 1.12,
                                    duration: Duration(seconds: 5),
                                    child: RotatingAnimator(
                                      duration: Duration(
                                        seconds: 8,
                                      ), // rotation speed
                                      direction: RotationDirection.clockwise,
                                      child: SvgPicture.asset(
                                        'assets/connect_button_effect_blue.svg',
                                      ),
                                    ),
                                  ),
                                  PulsingAnimator(
                                    minScale: 1.05,
                                    maxScale: 1.12,
                                    duration: Duration(seconds: 3),
                                    child: RotatingAnimator(
                                      duration: Duration(
                                        seconds: 7,
                                      ), // rotation speed
                                      direction:
                                          RotationDirection.counterClockwise,
                                      child: SvgPicture.asset(
                                        'assets/connect_button_effect_purple.svg',
                                      ),
                                    ),
                                  ),
                                  ClipOval(
                                    child: Material(
                                      color: Colors
                                          .transparent, // Keep visuals from SVGs
                                      child: InkWell(
                                        onTap: () {
                                          _connectLightstick();
                                        },
                                        splashColor: Colors.white.withValues(
                                          alpha: 0.1,
                                        ),
                                        highlightColor: Colors.white.withValues(
                                          alpha: 0.2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                ),
                // TextButton(
                //   onPressed: () {
                //     setState(() {
                //       lightstickDiscovered = !lightstickDiscovered;
                //     });
                //   },
                //   child: Text("test discovered"),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
