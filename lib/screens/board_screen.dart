import 'package:flutter/material.dart';
import 'package:nekochan/classes/board.dart';
import 'package:nekochan/classes/data.dart';
import 'package:nekochan/constants.dart';
import 'package:nekochan/widgets/my_drawer.dart';
import 'package:nekochan/utilities/networking.dart';
import 'package:nekochan/widgets/thread_preview.dart';
import 'package:provider/provider.dart';

class BoardScreen extends StatefulWidget {
  static final String id = 'boardscreen';
  String letter, name;

  BoardScreen({this.letter, this.name});

  @override
  _BoardScreenState createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  Board currentBoard;
  var threads = [];
  List<ThreadPreview> threadPreviews = [];
  NetworkHelper networkHelper = NetworkHelper();

  @override
  void initState() {
    currentBoard = Board(letter: widget.letter, title: widget.name);
    getBoardData();
    super.initState();
  }

  void getBoardData() async {
    print('Getting data...');
    var data = await networkHelper
        .getData('https://a.4cdn.org/${currentBoard.letter}/1.json');
    threadPreviews.clear();
    threads = data["threads"];

    setState(() {
      for (var thread in threads) {
        var firstPost = thread['posts'][0];
        threadPreviews.add(ThreadPreview(
          now: firstPost['now'],
          closed: firstPost['closed'],
          com: firstPost['com'],
          ext: firstPost['ext'],
          filename: firstPost['filename'],
          name: firstPost['name'],
          sticky: firstPost['sticky'],
          board: currentBoard.letter,
          imageId: firstPost['tim'],
          sub: firstPost['sub'],
          no: firstPost['no'],
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Text(
          '/${currentBoard.letter}/ - ${currentBoard.title}',
          style: kAppBarTitleTextStyle,
        ),
      ),
      body: ListView.builder(
        itemCount: threadPreviews.length,
        itemBuilder: (context, i) => threadPreviews[i],
      ),
    );
  }
}
