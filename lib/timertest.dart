import 'dart:async';
import 'package:flutter/material.dart';

class TimerTest extends StatefulWidget {
  @override
  _TimerTestState createState() => _TimerTestState();
}

class _TimerTestState extends State<TimerTest> {
  late Timer _timer = Timer(Duration.zero, () {});
  late int _durationInSeconds = 0;
  late int _initialDurationInSeconds = 0;

  bool _isRunning = false;
  bool _isFinished = false;

  final _textEditingController = TextEditingController();

  @override
  void dispose() {
    _timer.cancel();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Timer App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              formatDuration(_durationInSeconds),
              style: TextStyle(fontSize: 64.0),
            ),
            SizedBox(height: 32.0),
            if (!_isRunning && !_isFinished)
              Container(
                width: 200.0,
                child: TextField(
                  controller: _textEditingController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: 'Enter duration in seconds',
                  ),
                ),
              ),
            SizedBox(height: 32.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  child: Text(_isRunning ? 'Stop' : 'Start'),
                  onPressed: () {
                    setState(() {
                      _isRunning = !_isRunning;
                      if (_isRunning) {
                        _initialDurationInSeconds =
                            int.parse(_textEditingController.text);
                        _durationInSeconds = _initialDurationInSeconds;
                        startTimer();
                      } else {
                        stopTimer();
                      }
                    });
                  },
                ),
                ElevatedButton(
                  child: Text('Reset'),
                  onPressed: () {
                    setState(() {
                      _isRunning = false;
                      _isFinished = false;
                      _durationInSeconds = _initialDurationInSeconds;
                      _textEditingController.clear();
                    });
                    resetTimer();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _durationInSeconds--;
        if (_durationInSeconds <= 0) {
          timer.cancel();
          _isRunning = false;
          _isFinished = true;
        }
      });
    });
  }

  void stopTimer() {
    _timer.cancel();
  }

  void resetTimer() {
    stopTimer();
  }

  String formatDuration(int durationInSeconds) {
    int minutes = durationInSeconds ~/ 60;
    int seconds = durationInSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
