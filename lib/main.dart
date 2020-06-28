import 'package:flutter/material.dart';
import 'package:retro_painter/splash-screen.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIOverlays([]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      checkerboardOffscreenLayers: false,
      title: 'Retro Painter',
      theme: ThemeData(
        fontFamily: "Arial",
        primarySwatch: Colors.grey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        buttonTheme: ButtonThemeData(
          buttonColor: Color(0x00BDBDBD),
        ),
      ),
      //home: PainterScreen(),
      home: SplashScreen(),
    );
  }
}
