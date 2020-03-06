import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:nekochan/constants.dart';

import 'package:html/parser.dart' show parse;

class ThreadPreview extends StatelessWidget {
  final String now, name, com, filename, ext, board, sub;
  final int sticky, closed, imageId, no;
  String convertedCom, convertedName, convertedSub;
  List<TextSpan> textSpans;

  ThreadPreview(
      {this.now,
      this.name,
      this.com,
      this.filename,
      this.ext,
      this.sticky,
      this.closed,
      this.board,
      this.imageId,
      this.sub,
      this.no});

  void processCom() {
    HtmlUnescape htmlUnescape = HtmlUnescape();

    if (com != null) {
      convertedCom = htmlUnescape.convert(com);
      convertedCom = convertedCom.replaceAll('<br>', '\n');

      var document = parse(convertedCom);
      var quotes = document.getElementsByClassName('quote');

      if (quotes.length > 0) {
        for (var quote in quotes) {
          print(quote.firstChild);
        }
      }
    } else {
      convertedCom = '';
    }

    if (name != null) {
      convertedName = htmlUnescape.convert(name);
    } else {
      convertedName = '';
    }

    if (sub != null) {
      convertedSub = htmlUnescape.convert(sub);
    } else {
      convertedSub = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    processCom();

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.0),
      child: Card(
        color: Color(0xffd6daf0),
        child: Row(
          children: <Widget>[
            Image.network(
              'https://i.4cdn.org/$board/${imageId}s.jpg',
              width: 100.0,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Thread title
                    Text(
                      convertedSub,
                      style: kSubTextStyle,
                    ),
                    // Username
                    Text(
                      convertedName,
                      style: kNameTextStyle,
                    ),
                    Text('$now No.$no'),
                    SizedBox(
                      height: 10.0,
                    ),
                    // Comment
                    Text(
                      convertedCom.length > kThreadPreviewCharacterLimit
                          ? convertedCom.substring(
                                  0, kThreadPreviewCharacterLimit) +
                              '...'
                          : convertedCom,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
