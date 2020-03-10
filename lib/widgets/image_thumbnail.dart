import 'package:flutter/material.dart';
import '../screens/image_viewer_screen.dart';
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
            Navigator.of(context).push(
              PageRouteBuilder(
                opaque: false,
                transitionDuration: Duration(seconds: 1),
                pageBuilder: (context, _, __) {
                  return ImageViewerScreen(board, imageId, ext);
                },
              ),
            );
          },
          child: ExtendedImage.network(
            'https://i.4cdn.org/$board/${imageId}s.jpg',
            width: 120.0,
            scale: 0.5,
            retries: 3,
          ),
        ),
      ),
    );
  }
}
