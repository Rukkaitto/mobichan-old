import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';

class ImageViewerScreen extends StatelessWidget {
  String board, ext;
  int imageId;

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
              child: ExtendedImage.network(
                'https://i.4cdn.org/$board/$imageId$ext',
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                fit: BoxFit.contain,
                mode: ExtendedImageMode.gesture,
                initGestureConfigHandler: (state) {
                  return GestureConfig(
                    minScale: 1.0,
                    animationMinScale: 0.7,
                    maxScale: 3.0,
                    animationMaxScale: 3.5,
                    speed: 1.0,
                    inertialSpeed: 100.0,
                    initialScale: 1.0,
                    inPageView: false,
                    cacheGesture: true,
                    initialAlignment: InitialAlignment.center,
                  );
                },
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
