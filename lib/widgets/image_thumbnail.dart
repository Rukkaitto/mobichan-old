import 'package:flutter/material.dart';
import '../screens/image_viewer_screen.dart';
import '../screens/webm_viewer_screen.dart';

class ImageThumbnail extends StatelessWidget {
  final String board, ext;
  final int imageId;

  ImageThumbnail(
      {@required this.imageId, @required this.ext, @required this.board});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
        child: GestureDetector(
          onTap: () {
            if (ext == '.webm') {
              Navigator.of(context).push(
                PageRouteBuilder(
                  opaque: false,
                  pageBuilder: (context, _, __) {
                    return WebmViewerScreen(board, imageId, ext);
                  },
                ),
              );
            } else {
              Navigator.of(context).push(
                PageRouteBuilder(
                  opaque: false,
                  pageBuilder: (context, _, __) {
                    return ImageViewerScreen(board, imageId, ext);
                  },
                ),
              );
            }
          },
          child: Stack(
            alignment: ext == '.webm' ? Alignment.center : Alignment.topLeft,
            children: <Widget>[
              Hero(
                tag: imageId.toString(),
                child: Image.network(
                  'https://i.4cdn.org/$board/${imageId}s.jpg',
                  width: 120.0,
                  scale: 0.5,
                ),
              ),
              ext == '.webm'
                  ? Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 40.0,
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
