import 'package:flutter/material.dart';
import 'package:nekochan/classes/board.dart';
import 'package:nekochan/constants.dart';
import 'package:nekochan/screens/board_screen.dart';

final String url = 'https://a.4cdn.org/boards.json';

class BoardListScreen extends StatefulWidget {
  static final String id = 'boardlist';
  final List<Board> boards;

  BoardListScreen(this.boards);

  @override
  _BoardListScreenState createState() => _BoardListScreenState();
}

class _BoardListScreenState extends State<BoardListScreen> {
  @override
  Widget build(BuildContext context) {
    List<Board> boards = widget.boards;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Boards',
          style: kAppBarTitleTextStyle,
        ),
      ),
      body: ListView.builder(
        itemCount: boards.length,
        padding: EdgeInsets.symmetric(vertical: 20.0),
        itemBuilder: (BuildContext context, int index) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FlatButton(
                child: Text(
                  '/${boards[index].letter}/ - ${boards[index].title}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xffaf0a0f),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return BoardScreen(
                        name: boards[index].title,
                        letter: boards[index].letter);
                  }));
                },
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 150.0),
                child: Divider(
                  thickness: 2.0,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
