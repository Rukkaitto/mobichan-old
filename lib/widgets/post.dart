import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nekochan/constants.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:nekochan/screens/image_viewer_screen.dart';
import 'package:nekochan/utilities/parsing.dart';
import 'package:nekochan/widgets/greentext.dart';
import 'package:nekochan/widgets/quotelink.dart';
import 'package:extended_image/extended_image.dart';

class Post extends StatelessWidget {
  final String now, name, com, filename, ext, board, sub;
  final int sticky,
      closed,
      imageId,
      no,
      maxLines,
      replies,
      images,
      width,
      height,
      fsize;
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
      this.images,
      this.width,
      this.height,
      this.fsize});

  String convertBytes(int bytes) {
    String result = '';
    if (bytes >= 1000000) {
      result = (bytes / 1000000).toStringAsFixed(1) + 'MB';
    } else if (bytes >= 1000) {
      result = (bytes / 1000).toStringAsFixed(0) + 'KB';
    }
    return result;
  }

  RichText processCom(BuildContext context) {
    HtmlUnescape htmlUnescape = HtmlUnescape();
    List<String> strs;
    List<TextSpan> textSpans = List<TextSpan>();

    if (com != null) {
      convertedCom = htmlUnescape.convert(com);
      convertedCom = convertedCom.replaceAll('<br>', '\n');
      convertedCom = convertedCom.replaceAll(
          new RegExp('</?b>|</?u>|</?i>|</?s>|<wbr>'), '');

      strs = convertedCom.split(new RegExp(
          '<span class="quote">|</span>|<a .*class="quotelink">|</a>'));

      for (String str in strs) {
        if (str.length > 3 ? str.substring(0, 2).contains('>>') : false) {
          int postNo;
          try {
            postNo = int.parse(str.replaceAll('>>', ''));
          } catch (e) {
            postNo = -1;
          }

          textSpans.add(
            QuoteLink(
              str,
              tapGestureRecognizer: TapGestureRecognizer()
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
            ),
          );
        } else if (str.length > 2 ? str.substring(0, 1).contains('>') : false) {
          textSpans.add(
            GreenText(str),
          );
        } else {
          textSpans.add(
            TextSpan(
              text: str,
              style: DefaultTextStyle.of(context).style,
            ),
          );
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
      convertedSub = Parser.removeTags(sub);
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
        left: 3.0,
        top: 3.0,
        right: 3.0,
      ),
      child: GestureDetector(
        onTap: onPressed,
        child: Card(
          elevation: 2.0,
          color: Color(0xffd6daf0),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                imageId == null
                    ? SizedBox()
                    : Padding(
                        padding:
                            EdgeInsets.only(left: 5.0, top: 5.0, bottom: 5.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  opaque: false,
                                  transitionDuration: Duration(seconds: 1),
                                  pageBuilder: (context, _, __) {
                                    return ImageViewerScreen(
                                        board, imageId, ext);
                                  },
                                ),
                              );
                            },
                            child: ExtendedImage.network(
                              'https://i.4cdn.org/$board/${imageId}s.jpg',
                              width: 120.0,
                              scale: 0.5,
                              retries: 3,
                            ),
                          ),
                        ),
                      ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 5.0, left: 15.0, bottom: 5.0, right: 5.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            imageId != null
                                ? Text(
                                    '$filename$ext ${width}x$height ${convertBytes(fsize)}',
                                    style: kSmallGreyTextStyle,
                                  )
                                : SizedBox(),
                            // Thread title
                            convertedSub == ''
                                ? SizedBox()
                                : Text(
                                    convertedSub,
                                    style: kSubTextStyle,
                                  ),
                            // Username
                            RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: convertedName,
                                    style: kNameTextStyle,
                                  ),
                                  TextSpan(
                                    text: showTimeStamp ? ' No.$no' : '',
                                    style: kSmallGreyTextStyle,
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(
                              height: 5.0,
                            ),
                            // Comment
                            convertedCom == '' ? SizedBox() : richText,
                          ],
                        ),
                        Align(
                          child: replies == null || images == null
                              ? SizedBox()
                              : Text(
                                  '${replies}R ${images}I',
                                  style: kSmallGreyTextStyle,
                                ),
                          alignment: Alignment.bottomRight,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
