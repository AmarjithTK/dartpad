import 'package:flutter/material.dart';
// import 'components/timertest.dart';
import 'timerapp.dart';

void main() {
  runApp(MaterialApp(
    // routes: {
    //   // '/timertest': (context) => TimerTest(),
    // },
    theme: ThemeData.dark(
      useMaterial3: true,
    ),
    home: TimerApp(),
  ));
}
