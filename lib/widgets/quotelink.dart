import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nekochan/constants.dart';

class QuoteLink extends TextSpan {
  String text;
  TapGestureRecognizer tapGestureRecognizer;

  QuoteLink(this.text, {this.tapGestureRecognizer})
      : super(
          text: text,
          style: kQuoteLinkTextStyle,
          recognizer: tapGestureRecognizer,
        );
}
