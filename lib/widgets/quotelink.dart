import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nekochan/constants.dart';

import 'post.dart';

class QuoteLink extends TextSpan {
  String text;
  BuildContext context;

  QuoteLink(this.text, {this.context})
      : super(
          text: text,
          style: kQuoteLinkTextStyle,
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      backgroundColor: Colors.transparent,
                      child: Post(
                        no: Random().nextInt(999999),
                        name: 'Anonymous',
                        com: '>>88888888',
                        now: '3/8/2020 6:52PM',
                        showTimeStamp: true,
                      ),
                    );
                  });
            },
        );
}
