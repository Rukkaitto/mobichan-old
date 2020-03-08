import 'package:flutter/material.dart';

class GreenText extends TextSpan {
  String text;

  GreenText(this.text)
      : super(
          text: text,
          style: TextStyle(
            color: Color(0xff789922),
          ),
        );
}
