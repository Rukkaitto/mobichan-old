import 'package:flutter/material.dart';
import 'package:nekochan/constants.dart';

class GreenText extends TextSpan {
  String text;

  GreenText(this.text)
      : super(
          text: text,
          style: kGreenTextTextStyle,
        );
}
