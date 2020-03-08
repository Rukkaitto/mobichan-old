import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class QuoteLink extends TextSpan {
  String text;
  TapGestureRecognizer tapGestureRecognizer;

  QuoteLink(this.text, {this.tapGestureRecognizer})
      : super(
          text: text,
          style: TextStyle(
            color: Color(0xffdd0000),
            decoration: TextDecoration.underline,
          ),
          recognizer: tapGestureRecognizer,
        );
}
