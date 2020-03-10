import 'package:flutter/material.dart';
import 'package:nekochan/classes/board.dart';
import 'package:nekochan/constants.dart';
import 'package:nekochan/utilities/parsing.dart';
import 'package:nekochan/widgets/my_drawer.dart';
import 'package:nekochan/utilities/networking.dart';
import 'package:nekochan/widgets/post.dart';

class ThreadScreen extends StatefulWidget {
  static final String id = 'threadscreen';
  String letter;
  int no;
  String appBarTitle;

  ThreadScreen(
      {@required this.letter, @required this.no, @required this.appBarTitle});

  @override
  _ThreadScreenState createState() => _ThreadScreenState();
}

class _ThreadScreenState extends State<ThreadScreen> {
  var postsData = [];
  List<Post> posts = [];
  NetworkHelper networkHelper = NetworkHelper();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    _refresh();
    super.initState();
  }

  Future<Null> _refresh() {
    return getBoardData().then((data) {
      posts.clear();
      postsData = data["posts"];

      setState(() {
        for (var post in postsData) {
          var firstPost = post;
          posts.add(Post(
            now: firstPost['now'],
            closed: firstPost['closed'],
            com: firstPost['com'],
            ext: firstPost['ext'],
            filename: firstPost['filename'],
            name: firstPost['name'],
            sticky: firstPost['sticky'],
            board: widget.letter,
            imageId: firstPost['tim'],
            sub: firstPost['sub'],
            no: firstPost['no'],
            width: firstPost['w'],
            height: firstPost['h'],
            fsize: firstPost['fsize'],
            showTimeStamp: true,
          ));
        }
      });
    });
  }

  Future<dynamic> getBoardData() {
    var data = networkHelper.getData(
        'https://a.4cdn.org/${widget.letter}/thread/${widget.no}.json');
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.blueGrey),
        title: Text(
          Parser.removeTags(widget.appBarTitle.replaceAll('<br>', ' ')),
          style: Theme.of(context)
              .textTheme
              .headline
              .copyWith(color: kSubTextStyle.color),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refresh,
        child: Scrollbar(
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: posts.length,
            itemBuilder: (context, i) => posts[i],
          ),
        ),
      ),
    );
  }
}
