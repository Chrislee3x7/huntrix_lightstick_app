import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huntrix_lightstick_app/screens/start_screen.dart';

void main() {
  runApp(const HuntrixLightstickApp());
}

class HuntrixLightstickApp extends StatelessWidget {
  const HuntrixLightstickApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(414, 932), // <- match your Figma design size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Huntrix Lightstick App',
          theme: ThemeData(
            textTheme: Theme.of(context).textTheme.apply(
              fontSizeFactor: 24.sp / 16, // scale base font size
            ),
            colorScheme: .fromSeed(seedColor: Colors.deepPurple),
          ),
          home: StartScreen(title: 'Start'),
        );
      },
    );
  }
}
