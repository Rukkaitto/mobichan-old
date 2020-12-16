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

  static String convertBytes(int bytes) {
    String result = '';
    if (bytes >= 1000000) {
      result = (bytes / 1000000).toStringAsFixed(1) + 'MB';
    } else if (bytes >= 1000) {
      result = (bytes / 1000).toStringAsFixed(0) + 'KB';
    }
    return result;
  }
}
