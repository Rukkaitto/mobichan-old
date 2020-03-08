import 'package:flutter/material.dart';

class ImageViewerScreen extends StatelessWidget {
  String board, ext;
  int imageId;

  ImageViewerScreen(this.board, this.imageId, this.ext);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xaa000000),
      body: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Center(
          child: Image.network('https://i.4cdn.org/$board/$imageId$ext'),
        ),
      ),
    );
  }
}
