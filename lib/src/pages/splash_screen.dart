import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../controllers/splash_screen_controller.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends StateMVC<SplashScreen> {
  SplashScreenController _con;

  SplashScreenState() : super(SplashScreenController()) {
    _con = controller;
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void loadData() {
      _con.progress.addListener(() async{
        double progress = 0;
        _con.progress.value.values.forEach((_progress) {
          progress += _progress;
        });
        if (progress == 100) {
          try {
             await Future.delayed(const Duration(seconds: 4));
            Navigator.of(context).pushReplacementNamed('/Pages', arguments: 2);
          } catch (e) {}
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/img/logo_animation.gif',
                width: 150,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 50),
              //LoadingProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
