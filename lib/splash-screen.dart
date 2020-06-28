import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';

import 'paint95.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    redirect();
  }

  void redirect() async {
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ClassicPaint(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, //top bar color
      statusBarIconBrightness: Brightness.light, //top bar icons
      systemNavigationBarColor: Colors.transparent, //bottom bar color
      systemNavigationBarIconBrightness: Brightness.dark, //bottom bar icons
    ));
    return Scaffold(
      backgroundColor: const Color(0xFFf7f7f7),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Spacer(),
          Container(
            width: 400,
            child: Center(
              child: Image.asset('assets/images/logo.jpeg'),
            ),
          ),
          Spacer(),
          Icon(FontAwesomeIcons.hourglassHalf),
          SizedBox(
            height: 10,
          ),
          Center(
            child: Text(
              "Loading..",
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .apply(color: Colors.black),
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
