import 'package:flutter/material.dart';
import 'package:nekochan/classes/board.dart';
import 'package:nekochan/constants.dart';
import 'package:nekochan/screens/thread_screen.dart';
import 'package:nekochan/widgets/my_drawer.dart';
import 'package:nekochan/utilities/networking.dart';
import 'package:nekochan/widgets/post.dart';

class BoardScreen extends StatefulWidget {
  static final String id = 'boardscreen';
  String letter, name;

  BoardScreen({this.letter, this.name});

  @override
  _BoardScreenState createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  Board currentBoard;
  var pages = [];
  List<Post> threadPreviews = [];
  NetworkHelper networkHelper = NetworkHelper();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    currentBoard = Board(letter: widget.letter, title: widget.name);
    _refresh();
    super.initState();
  }

  Future<Null> _refresh() {
    return getBoardData().then((data) {
      threadPreviews.clear();
      pages = data;

      setState(() {
        for (var page in pages) {
          var firstPagePosts = page['threads'];
          for (var post in firstPagePosts) {
            threadPreviews.add(Post(
              now: post['now'],
              closed: post['closed'],
              com: post['com'],
              ext: post['ext'],
              filename: post['filename'],
              name: post['name'],
              sticky: post['sticky'],
              board: currentBoard.letter,
              imageId: post['tim'],
              sub: post['sub'],
              no: post['no'],
              maxLines: 5,
              showTimeStamp: false,
              images: post["images"],
              replies: post["replies"],
              width: post['w'],
              height: post['h'],
              fsize: post['fsize'],
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ThreadScreen(
                    appBarTitle:
                        post['sub'] == null ? post['com'] : post['sub'],
                    no: post['no'],
                    letter: currentBoard.letter,
                  );
                }));
              },
            ));
          }
        }
      });
    });
  }

  Future<dynamic> getBoardData() {
    print('https://a.4cdn.org/${currentBoard.letter}/catalog.json');
    var data = networkHelper
        .getData('https://a.4cdn.org/${currentBoard.letter}/catalog.json');
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.blueGrey),
        title: Text(
          '/${currentBoard.letter}/ - ${currentBoard.title}',
          style: kAppBarTitleTextStyle,
        ),
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refresh,
        child: Scrollbar(
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: threadPreviews.length,
            itemBuilder: (context, i) => threadPreviews[i],
          ),
        ),
      ),
    );
  }
}
