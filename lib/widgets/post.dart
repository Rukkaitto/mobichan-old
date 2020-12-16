import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:nekochan/utilities/parsing.dart';
import 'package:nekochan/widgets/greentext.dart';
import 'package:nekochan/widgets/quotelink.dart';

import 'greentext.dart';
import 'image_thumbnail.dart';

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

  RichText processCom(BuildContext context) {
    HtmlUnescape htmlUnescape = HtmlUnescape();
    List<String> strs;
    List<TextSpan> textSpans = List<TextSpan>();

    if (com != null) {
      convertedCom = htmlUnescape
          .convert(com)
          .replaceAll('<br>', '\n')
          .replaceAll(new RegExp('</?b>|</?u>|</?i>|</?s>|<wbr>'), '');

      strs = convertedCom.split(new RegExp(
          '<span class="quote">|</span>|<a .*class="quotelink">|</a>'));

      for (String str in strs) {
        bool isQuotelink =
            str.length > 3 ? str.substring(0, 2).contains('>>') : false;
        bool isGreentext =
            str.length > 2 ? str.substring(0, 1).contains('>') : false;
        TextSpan textSpan;

        if (isQuotelink) {
          textSpan = QuoteLink(
            str,
            context: context,
          );
        } else if (isGreentext) {
          textSpan = GreenText(str);
        } else {
          textSpan = TextSpan(
            text: str,
            style: DefaultTextStyle.of(context).style,
          );
        }

        textSpans.add(textSpan);
      }
    }

    convertedName = htmlUnescape.convert(name ?? '');
    convertedSub = Parser.removeTags(sub ?? '');

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
      padding: EdgeInsets.only(left: 5.0, top: 5.0, right: 5.0),
      child: MaterialButton(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        padding: EdgeInsets.all(5.0),
        onPressed: onPressed,
        elevation: 0.0,
        color: Theme.of(context).primaryColor,
        disabledColor: Theme.of(context).primaryColor,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              imageId == null
                  ? Container()
                  : ImageThumbnail(
                      imageId: imageId,
                      board: board,
                      ext: ext,
                    ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          imageId != null
                              ? Text(
                                  '$filename$ext ${width}x$height ${Parser.convertBytes(fsize)}',
                                  style: Theme.of(context).textTheme.caption,
                                )
                              : Container(),
                          // Thread title
                          convertedSub == ''
                              ? Container()
                              : Text(
                                  convertedSub ?? '',
                                  style: Theme.of(context).textTheme.title,
                                ),
                          // Username
                          RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: convertedName ?? '',
                                  style: Theme.of(context).textTheme.subtitle,
                                ),
                                TextSpan(
                                  text: showTimeStamp ? ' No.$no' : '',
                                  style: Theme.of(context).textTheme.caption,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          // Comment
                          convertedCom == null ? Container() : richText,
                        ],
                      ),
                      Align(
                        child: replies == null || images == null
                            ? Container()
                            : Text(
                                '${replies}R ${images}I',
                                style: Theme.of(context).textTheme.caption,
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
    );
  }
}
