import 'package:flutter/material.dart';
import 'package:nekochan/classes/board.dart';
import 'package:nekochan/classes/data.dart';
import 'package:nekochan/constants.dart';
import 'package:nekochan/my_drawer.dart';
import 'package:nekochan/utilities/networking.dart';
import 'package:provider/provider.dart';

class BoardScreen extends StatefulWidget {
  static final String id = 'boardscreen';

  @override
  _BoardScreenState createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  Board currentBoard;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    currentBoard = Board(
        letter: Provider.of<Data>(context).currentBoardLetter,
        title: Provider.of<Data>(context).currentBoardTitle);

    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Text(
          '/${currentBoard.letter}/ - ${currentBoard.title}',
          style: kAppBarTitleTextStyle,
        ),
      ),
    );
  }
}
