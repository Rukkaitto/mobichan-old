import 'package:html_unescape/html_unescape.dart';

class Parser {
  static String removeTags(String str) {
    HtmlUnescape unescape = HtmlUnescape();
    String convertedStr = unescape.convert(str);
    convertedStr = convertedStr.replaceAll(
        new RegExp(
            '<a href=".*">|</a>|</?b>|</?u>|</?i>|</?s>|<wbr>|<span class="quote">|</span>'),
        '');
    return convertedStr;
  }
}
