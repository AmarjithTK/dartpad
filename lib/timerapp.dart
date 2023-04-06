import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'dart:async';

// add assets and improvise this app further in another day

import 'package:timerapp/components/cardbutton.dart';

class TimerApp extends StatefulWidget {
  const TimerApp({super.key});

  @override
  State<TimerApp> createState() => _TimerAppState();
}

class _TimerAppState extends State<TimerApp> {
  late Timer _timer = Timer(Duration.zero, () {});
  // late int _durationInSeconds = 0;
  // late int _initialDurationInSeconds = 0;
  // int _currentSliderValue = 5;
  bool _isRunning = false;
  bool _isFinished = true;

  final AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();

  List<int> presets = [
    1,
    2,
    3,
    4,
    5,
    10,
    15,
    20,
    25,
    30,
    35,
    40,
    50,
    60,
    70,
    80,
    90,
    100,
    110,
    120
  ];

  late int _durationInSeconds = 0;

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Widget build(BuildContext context) {
    // int durationInSeconds = _currentSliderValue * 60;

    return Scaffold(
      appBar: AppBar(
        // leading: Icon(Icons.menu),
        title: Center(child: Text("Timer App")),
        actions: [Icon(Icons.menu_rounded)],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisSize: MainAxisSize.max,
          children: [
            SleekCircularSlider(
                innerWidget: (percentage) {
                  return Icon(
                    Icons.work_history_rounded,
                    color: Colors.white,
                    size: 40,
                  );
                },
                min: 5,
                max: 121,
                appearance: CircularSliderAppearance(
                    size: 150,
                    // size: 5,
                    infoProperties: InfoProperties(
                        mainLabelStyle:
                            TextStyle(fontSize: 25, color: Colors.white))),
                onChange: (double value) {
                  setState(() {
                    if (_isRunning == false && _isFinished == true)
                      _durationInSeconds = value.toInt() * 60;
                  });
                }),
            Container(
              width: double.infinity,
              height: 100,
              child: Container(
                decoration: BoxDecoration(
                    // color: Colors.,
                    border: Border.all(color: Color.fromARGB(255, 34, 34, 34)),
                    borderRadius: BorderRadius.circular(4)),
                child: Center(
                    child: Text(formatDuration(_durationInSeconds),
                        style: TextStyle(fontSize: 40.0))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          // _isRunning = !_isRunning; // true now
                          if (_isRunning == false) {
                            _durationInSeconds =
                                _durationInSeconds > 0 ? _durationInSeconds : 0;

                            startTimer();
                            _isRunning = true;
                          }
                        });
                      },
                      child: Text('start')),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          stopTimer();
                        });
                      },
                      child: Text('stop')),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          // _currentSliderValue = 5;
                          _durationInSeconds = 0;
                          resetTimer();
                        });
                      },
                      child: Text('reset')),
                ],
              ),
            ),
            GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                ),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                itemCount: presets.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        if (_isRunning == false) {
                          _durationInSeconds = _durationInSeconds > 0
                              ? _durationInSeconds
                              : presets[index] * 60;

                          startTimer();
                          _isRunning = true;
                        }
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          // color: Colors.,
                          border: Border.all(
                              color: Color.fromARGB(255, 34, 34, 34)),
                          borderRadius: BorderRadius.circular(4)),
                      child: Center(
                        child: Text(
                          presets[index].toString(),
                        ),
                      ),
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }

  void startTimer() {
    _isFinished = false;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _durationInSeconds--;
        audioPlayer.open(Audio('assets/river-2.mp3'),
            loopMode: LoopMode.single);
        audioPlayer.play();

        if (_durationInSeconds <= 0) {
          audioPlayer.stop();
          timer.cancel();
          _isRunning = false;
          _isFinished = true;
        }
      });
    });
  }

  void stopTimer() {
    _timer.cancel();
    audioPlayer.stop();
    _isRunning = false;
  }

  void resetTimer() {
    stopTimer();
    _timer = Timer(Duration.zero, () {});
    _isFinished = true;
  }

  String formatDuration(int durationInSeconds) {
    int minutes = durationInSeconds ~/ 60;
    int seconds = durationInSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  // void startTimerGlobal() {
  //   if (_isRunning == false) {
  //     _durationInSeconds = _durationInSeconds > 0 ? _durationInSeconds : 5 * 60;

  //     startTimer();
  //     _isRunning = true;
  //   }
  // }
}
