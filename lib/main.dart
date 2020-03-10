import 'package:flutter/material.dart';
import 'package:nekochan/classes/board.dart';
import 'package:nekochan/constants.dart';
import 'package:nekochan/screens/board_list_screen.dart';
import 'package:nekochan/utilities/networking.dart';
import 'screens/board_screen.dart';

void main() => runApp(Nekochan());

class Nekochan extends StatefulWidget {
  @override
  _NekochanState createState() => _NekochanState();
}

class _NekochanState extends State<Nekochan> {
  NetworkHelper networkHelper = NetworkHelper();
  List<Board> boards = [];

  @override
  void initState() {
    getBoards();
    super.initState();
  }

  void getBoards() async {
    var boardsJson = await networkHelper.getData(url);
    for (var board in boardsJson["boards"]) {
      setState(() {
        boards.add(
          Board(
            letter: board["board"],
            title: board["title"],
          ),
        );
      });
    }
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xffeef2ff),
        primaryColor: Color(0xffd6daf0),
        textTheme: TextTheme(
          title: kSubTextStyle,
          subtitle: kNameTextStyle,
          caption: kSmallGreyTextStyle,
          headline: kAppBarTitleTextStyle,
          display1: kGreenTextTextStyle,
          display2: kQuoteLinkTextStyle,
        ),
      ),
      initialRoute: BoardScreen.id,
      routes: {
        BoardScreen.id: (context) => BoardScreen(
              letter: 'a',
              name: 'Anime & Manga',
            ),
        BoardListScreen.id: (context) => BoardListScreen(boards),
      },
    );
  }
}
