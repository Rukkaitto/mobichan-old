import 'package:flutter/material.dart';
import '../screens/image_viewer_screen.dart';
import '../screens/webm_viewer_screen.dart';
import 'package:extended_image/extended_image.dart';

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
            print(ext);
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
            alignment: Alignment.center,
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: Hero(
                  tag: imageId.toString(),
                  child: ExtendedImage.network(
                    'https://i.4cdn.org/$board/${imageId}s.jpg',
                    width: 120.0,
                    scale: 0.5,
                    retries: 3,
                  ),
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
