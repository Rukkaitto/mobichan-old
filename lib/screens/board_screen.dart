import 'package:flutter/material.dart';
import 'package:nekochan/classes/board.dart';
import 'package:nekochan/screens/thread_screen.dart';
import 'package:nekochan/widgets/my_drawer.dart';
import 'package:nekochan/utilities/networking.dart';
import 'package:nekochan/widgets/post.dart';

class BoardScreen extends StatefulWidget {
  static final String id = 'boardscreen';
  final String letter, name;

  BoardScreen({this.letter, this.name});

  @override
  _BoardScreenState createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  Board currentBoard;
  var pages = [];
  List posts = [];
  NetworkHelper networkHelper = NetworkHelper();
  Function order;
  bool _isSearching = false;
  String searchQuery = '';
  TextEditingController _searchQuery;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    currentBoard = Board(letter: widget.letter, title: widget.name);
    order = () => posts.sort(
          (b, a) {
            return a['last_modified'].compareTo(b['last_modified']);
          },
        );
    _refresh();
    _searchQuery = TextEditingController();
    super.initState();
  }

  Future<Null> _refresh() {
    posts.clear();
    return getBoardData().then((data) {
      pages = data;

      for (var page in pages) {
        var firstPagePosts = page['threads'];
        for (var post in firstPagePosts) {
          setState(() {
            posts.add(post);
          });
        }
      }
      order();
    });
  }

  Future<dynamic> getBoardData() {
    var data = networkHelper
        .getData('https://a.4cdn.org/${currentBoard.letter}/catalog.json');
    return data;
  }

  void _startSearch() {
    ModalRoute.of(context)
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearching() {
    _clearSearchQuery();

    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearchQuery() {
    setState(() {
      _searchQuery.clear();
      updateSearchQuery('');
    });
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchQuery,
      autofocus: true,
      decoration: InputDecoration(
        hintText: 'Search...',
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.blueGrey),
      ),
      style: TextStyle(color: Colors.blueGrey, fontSize: 16.0),
      onChanged: updateSearchQuery,
    );
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
    });
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            if (_searchQuery == null || _searchQuery.text.isEmpty) {
              Navigator.pop(context);
              return;
            }
            _clearSearchQuery();
          },
        ),
      ];
    }

    return <Widget>[
      IconButton(
        icon: Icon(Icons.search),
        onPressed: _startSearch,
      ),
      PopupMenuButton(
        onSelected: (sort) {
          setState(() {
            sort();
          });
          order = sort;
        },
        itemBuilder: (context) {
          return <PopupMenuEntry>[
            PopupMenuItem(
              child: Text('Sort by bump order'),
              value: () => posts.sort(
                (b, a) {
                  return a['last_modified'].compareTo(b['last_modified']);
                },
              ),
            ),
            PopupMenuItem(
              child: Text('Sort by replies'),
              value: () => posts.sort(
                (b, a) {
                  return a['replies'].compareTo(b['replies']);
                },
              ),
            ),
            PopupMenuItem(
              child: Text('Sort by images'),
              value: () => posts.sort(
                (b, a) {
                  return a['images'].compareTo(b['images']);
                },
              ),
            ),
            PopupMenuItem(
              child: Text('Sort by newest'),
              value: () => posts.sort(
                (b, a) {
                  return a['no'].compareTo(b['no']);
                },
              ),
            ),
            PopupMenuItem(
              child: Text('Sort by oldest'),
              value: () => posts.sort(
                (a, b) {
                  return a['no'].compareTo(b['no']);
                },
              ),
            ),
          ];
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        leading: _isSearching ? BackButton() : null,
        iconTheme: IconThemeData(color: Colors.blueGrey),
        title: _isSearching
            ? _buildSearchField()
            : Text(
                '/${currentBoard.letter}/',
                style: Theme.of(context).textTheme.headline,
              ),
        backgroundColor: Theme.of(context).primaryColor,
        actions: _buildActions(),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refresh,
        child: Scrollbar(
          child: ListView.builder(
            itemCount: posts.length,
            physics: AlwaysScrollableScrollPhysics(),
            addAutomaticKeepAlives: false,
            itemBuilder: (context, i) {
              String com = posts[i]['com'];
              String sub = posts[i]['sub'];
              if ((com != null &&
                      com.toLowerCase().contains(searchQuery.toLowerCase())) ||
                  (sub != null &&
                      sub.toLowerCase().contains(searchQuery.toLowerCase()))) {
                return Post(
                  now: posts[i]['now'],
                  closed: posts[i]['closed'],
                  com: posts[i]['com'],
                  ext: posts[i]['ext'],
                  filename: posts[i]['filename'],
                  name: posts[i]['name'],
                  sticky: posts[i]['sticky'],
                  board: currentBoard.letter,
                  imageId: posts[i]['tim'],
                  sub: posts[i]['sub'],
                  no: posts[i]['no'],
                  maxLines: 5,
                  showTimeStamp: false,
                  images: posts[i]["images"],
                  replies: posts[i]["replies"],
                  width: posts[i]['w'],
                  height: posts[i]['h'],
                  fsize: posts[i]['fsize'],
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ThreadScreen(
                        appBarTitle: posts[i]['sub'] == null
                            ? posts[i]['com']
                            : posts[i]['sub'],
                        no: posts[i]['no'],
                        letter: currentBoard.letter,
                      );
                    }));
                  },
                );
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }
}
