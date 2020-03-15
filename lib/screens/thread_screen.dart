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
  List posts = [];
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
      postsData = data["posts"];
      for (var post in postsData) {
        setState(() {
          posts.add(post);
        });
      }
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
            physics: AlwaysScrollableScrollPhysics(),
            addAutomaticKeepAlives: false,
            itemCount: posts.length,
            itemBuilder: (context, i) => Post(
              now: posts[i]['now'],
              closed: posts[i]['closed'],
              com: posts[i]['com'],
              ext: posts[i]['ext'],
              filename: posts[i]['filename'],
              name: posts[i]['name'],
              sticky: posts[i]['sticky'],
              board: widget.letter,
              imageId: posts[i]['tim'],
              sub: posts[i]['sub'],
              no: posts[i]['no'],
              width: posts[i]['w'],
              height: posts[i]['h'],
              fsize: posts[i]['fsize'],
              showTimeStamp: true,
            ),
          ),
        ),
      ),
    );
  }
}
