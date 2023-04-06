import 'package:flutter/material.dart';
// import 'package:timerapp/timerapp.dart';

class CardButton extends StatefulWidget {
  const CardButton({super.key});

  @override
  State<CardButton> createState() => _CardButtonState();
}

class _CardButtonState extends State<CardButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      child: Card(
        child: Center(
          child: Text('50'),
        ),
      ),
    );
  }
}

// class CardButton extends StatefulWidget {
//   // const CardButton(int value, Function onTap);
// const CardButton(super.key);
//   @override
//   State<CardButton> createState() => _CardButtonState();
// }

// class _CardButtonState extends State<CardButton> {
//   @override
//   Widget build(BuildContext context) {
//     return 
//   }
// }
