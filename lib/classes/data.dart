import 'package:flutter/material.dart';
import 'package:nekochan/classes/thread.dart';
import 'package:nekochan/utilities/networking.dart';

class Data extends ChangeNotifier {
  String currentBoardLetter = 'a', currentBoardTitle = 'Anime & Manga';

  void setCurrentBoard(String currentBoard, String currentBoardTitle) {
    this.currentBoardLetter = currentBoard;
    this.currentBoardTitle = currentBoardTitle;

    notifyListeners();
  }
}
