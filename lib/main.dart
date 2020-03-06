import 'package:flutter/material.dart';
import 'package:nekochan/classes/board.dart';
import 'package:nekochan/classes/data.dart';
import 'package:nekochan/screens/board_list_screen.dart';
import 'package:nekochan/utilities/networking.dart';
import 'package:provider/provider.dart';
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
    return ChangeNotifierProvider(
      create: (context) => Data(),
      child: MaterialApp(
        theme: ThemeData.light().copyWith(
          appBarTheme: AppBarTheme(
            color: Color(0xffd7dbf1),
          ),
          scaffoldBackgroundColor: Color(0xffeef2ff),
        ),
        initialRoute: BoardScreen.id,
        routes: {
          BoardScreen.id: (context) => BoardScreen(),
          BoardListScreen.id: (context) => BoardListScreen(boards),
        },
      ),
    );
  }
}
