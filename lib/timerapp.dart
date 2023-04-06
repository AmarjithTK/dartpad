// import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_tts/flutter_tts_web.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'dart:io';
import 'package:flutter_tts/flutter_tts.dart';

// add assets and improvise this app further in another day

class TimerApp extends StatefulWidget {
  const TimerApp({super.key});

  @override
  State<TimerApp> createState() => _TimerAppState();
}

class _TimerAppState extends State<TimerApp> {
  late Timer _timer = Timer(Duration.zero, () {});

  FlutterTts flutterTts = FlutterTts();

  Future _speak(String word) async {
    var result = await flutterTts.speak(word);
    // if (result == 1) setState(() => ttsState = TtsState.playing);
    await flutterTts.setLanguage("en-US");

    await flutterTts.setSpeechRate(1.0);

    await flutterTts.setVolume(1.0);
  }

  // late int _durationInSeconds = 0;
  // late int _initialDurationInSeconds = 0;
  // int _currentSliderValue = 5;
  bool _isRunning = false;
  bool _isFinished = true;

  String user = "Amarjith TK";

  List<int> presets = [
    1,
    2,
    3,
    4,
    5,
    6,
    10,
    15,
    20,
    25,
    30,
    35,
    40,
    45,
    50,
    60,
    70,
    80,
    90,
    100,
    110,
    120,
    180,
    240,
    150,
  ];

  // presets.sort();

  late int _durationInSeconds = 0;

  void initState() {
    super.initState();
    loadAudio();
  }

  AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;

  double setVolume = .5;

  Future<void> loadAudio() async {
    // await audioPlayer.setAsset('assets/audio.mp3');
    await audioPlayer.setSourceAsset('river-2.mp3');
    await audioPlayer.setReleaseMode(ReleaseMode.loop);
    audioPlayer.setVolume(setVolume);
  }

  Future<void> playAudio() async {
    await audioPlayer.resume();
    setState(() {
      isPlaying = true;
    });
  }

  Future<void> stopAudio() async {
    await audioPlayer.stop();
    setState(() {
      isPlaying = false;
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
    _timer.cancel();
  }

  Widget build(BuildContext context) {
    // int durationInSeconds = _currentSliderValue * 60;
    // presets = presets.sort((a, b) => a.compareTo(b));

    presets.sort(
      (a, b) => a.compareTo(b),
    );

    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.star),
        title: Center(
            child: Text(
          "Timer App",
          style: TextStyle(fontSize: 30.0),
        )),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.menu))],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: SleekCircularSlider(
                  initialValue: 10,
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
                      customWidths: CustomSliderWidths(progressBarWidth: 15),
                      // angleRange: 360,
                      // startAngle: 180,
                      size: 200,
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
            ),
            Container(
              width: double.infinity,
              height: 100,
              margin: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  // color: Colors.,
                  border: Border.all(
                      width: 4.0, color: Color.fromARGB(255, 52, 52, 52))),
              child: Center(
                  child: Text(formatDuration(_durationInSeconds),
                      style: TextStyle(fontSize: 50.0))),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 15, 0, 10),
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
                          // color:kkk Colors.,
                          border: Border.all(
                              width: 4.0,
                              color: Color.fromARGB(255, 52, 52, 52)),
                          borderRadius: BorderRadius.circular(4)),
                      child: Center(
                        child: Text(
                          presets[index].toString(),
                          style: TextStyle(fontSize: 22),
                        ),
                      ),
                    ),
                  );
                }),
            Slider(
              value: setVolume * 10,
              // label: (setVolume * 10).toString(),
              onChanged: (value) {
                setState(() {
                  setVolume = value / 10;
                });
              },
              min: 1,
              max: 10,
            )
          ],
        ),
      ),
    );
  }

  void startTimer() async {
    _isFinished = false;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _durationInSeconds--;

        if (Platform.isAndroid) {
          if (_durationInSeconds % 60 == 0) {
            _speak("$_durationInSeconds/60 seconds");
          }
        }

        playAudio();

        if (_durationInSeconds <= 0) {
          stopAudio();
          timer.cancel();
          if (Platform.isAndroid) {
            if (_durationInSeconds % 60 == 0) {
              // var user;
              _speak("Timer is finished $user");
            }
          }

          _timer = Timer(Duration.zero, () {});
          _isRunning = false;
          _isFinished = true;
        }
      });
    });
  }

  void stopTimer() {
    _timer.cancel();
    // audioPlayer.stop();
    stopAudio();
    _timer = Timer(Duration.zero, () {});

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
