import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nekochan/constants.dart';
import 'package:html_unescape/html_unescape.dart';

class Post extends StatelessWidget {
  final String now, name, com, filename, ext, board, sub;
  final int sticky, closed, imageId, no, maxLines, replies, images;
  String convertedCom, convertedName, convertedSub;
  Function onPressed;
  List<TextSpan> textSpans;
  bool showTimeStamp;

  Post(
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
      this.no,
      this.maxLines,
      this.onPressed,
      this.showTimeStamp,
      this.replies,
      this.images});

  RichText processCom(BuildContext context) {
    HtmlUnescape htmlUnescape = HtmlUnescape();
    List<String> strs;
    List<TextSpan> textSpans = List<TextSpan>();

    if (com != null) {
      convertedCom = htmlUnescape.convert(com);
      convertedCom = convertedCom.replaceAll('<br>', '\n');
      convertedCom = convertedCom.replaceAll(
          new RegExp('<a href=".*">|</a>|</?b>|</?u>|</?i>|</?s>|<wbr>'), '');

      strs = convertedCom.split(new RegExp('<span class="quote">|</span>'));

      for (String str in strs) {
        if (str.length > 2 ? str.substring(0, 1).contains('>') : false) {
          textSpans.add(TextSpan(
            text: str,
            style: DefaultTextStyle.of(context).style.copyWith(
                  color: Color(0xff789922),
                ),
          ));
        } else {
          textSpans.add(
              TextSpan(text: str, style: DefaultTextStyle.of(context).style));
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
      convertedSub = convertedSub.replaceAll(
          new RegExp(
              '<a href=".*">|</a>|</?b>|</?u>|</?i>|</?s>|<wbr>|<span class="quote">|</span>'),
          '');
    } else {
      convertedSub = '';
    }

    return RichText(
      maxLines: maxLines,
      overflow: maxLines == null ? TextOverflow.visible : TextOverflow.ellipsis,
      text: TextSpan(
        children: textSpans,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    RichText richText = processCom(context);

    return Padding(
      padding: EdgeInsets.only(
        left: 5.0,
        top: 5.0,
        right: 5.0,
      ),
      child: GestureDetector(
        onTap: onPressed,
        child: Card(
          elevation: 3.0,
          color: Color(0xffd6daf0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(5.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: imageId == null
                      ? SizedBox()
                      : Image.network(
                          'https://i.4cdn.org/$board/${imageId}s.jpg',
                          width: 100.0,
                        ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Thread title
                      convertedSub == ''
                          ? SizedBox()
                          : Text(
                              convertedSub,
                              style: kSubTextStyle,
                            ),
                      // Username
                      Text(
                        convertedName,
                        style: kNameTextStyle,
                      ),
                      showTimeStamp ? Text('$now No.$no') : SizedBox(),
                      SizedBox(
                        height: 10.0,
                      ),
                      // Comment
                      convertedCom == '' ? SizedBox() : richText,
                      replies == null || images == null
                          ? SizedBox()
                          : Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                '${replies}R ${images}I',
                                style: TextStyle(
                                  color: Colors.blueGrey,
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
