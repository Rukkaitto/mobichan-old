import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImageViewerScreen extends StatelessWidget {
  final String board, ext;
  final int imageId;

  ImageViewerScreen(this.board, this.imageId, this.ext);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xaa000000),
      body: Builder(
        builder: (context) => Stack(
          alignment: Alignment.topRight,
          children: <Widget>[
            Center(
              child: Hero(
                tag: imageId.toString(),
                child: InteractiveViewer(
                  child: Image.network(
                    'https://i.4cdn.org/$board/$imageId$ext',
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    MaterialButton(
                      padding: EdgeInsets.zero,
                      minWidth: 0.0,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      child: Icon(
                        Icons.save,
                        color: Colors.white,
                        size: 30.0,
                      ),
                      onPressed: () {
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Saved'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                    MaterialButton(
                      padding: EdgeInsets.zero,
                      minWidth: 0.0,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 30.0,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
