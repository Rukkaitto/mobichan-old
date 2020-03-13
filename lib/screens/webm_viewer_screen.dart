import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class WebmViewerScreen extends StatefulWidget {
  final String board, ext;
  final int imageId;

  WebmViewerScreen(this.board, this.imageId, this.ext);

  @override
  _WebmViewerScreenState createState() => _WebmViewerScreenState();
}

class _WebmViewerScreenState extends State<WebmViewerScreen> {
  VideoPlayerController _controller;
  double sliderValue = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
        'https://i.4cdn.org/${widget.board}/${widget.imageId}${widget.ext}')
      ..initialize().then((_) {
        setState(() {
          _controller.play();
        });
      });
    _controller.setLooping(true);
    _controller.setVolume(0.0);

    Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (this.mounted) {
        setState(() {
          if (_controller.value.isPlaying &&
              sliderValue < _controller.value.duration.inSeconds) {
            sliderValue = _controller.value.position.inSeconds.toDouble();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xaa000000),
      body: Builder(
        builder: (context) => Stack(
          alignment: Alignment.topRight,
          children: <Widget>[
            _controller.value.initialized
                ? Center(
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                  )
                : Container(),
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
                        _controller.pause();
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
            SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        onPressed: () {
                          _controller.seekTo(Duration(seconds: 0));
                          setState(() {
                            sliderValue = 0.0;
                          });
                        },
                        icon: Icon(
                          Icons.fast_rewind,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _controller.value.isPlaying
                                ? _controller.pause()
                                : _controller.play();
                          });
                        },
                        icon: Icon(
                          _controller.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _controller.value.volume == 0.0
                                ? _controller.setVolume(1.0)
                                : _controller.setVolume(0.0);
                          });
                        },
                        icon: Icon(
                          _controller.value.volume == 0.0
                              ? Icons.volume_off
                              : Icons.volume_up,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '${(sliderValue ~/ 60).toString().padRight(1, '0')}:${(sliderValue % 60).toStringAsFixed(0).padLeft(2, '0')}',
                          style: TextStyle(color: Colors.white),
                        ),
                        Expanded(
                          child: Slider(
                            activeColor: Colors.white,
                            value: sliderValue,
                            min: 0.0,
                            max: _controller.value.duration == null
                                ? 1.0
                                : _controller.value.duration.inSeconds
                                    .toDouble(),
                            onChanged: (progress) {
                              setState(() {
                                sliderValue = progress.floor().toDouble();
                              });
                              _controller.seekTo(
                                  Duration(seconds: sliderValue.toInt()));
                            },
                          ),
                        ),
                        Text(
                          _controller.value.duration == null
                              ? '0.00'
                              : '${_controller.value.duration.inMinutes}:${(_controller.value.duration.inSeconds % 60).toString().padLeft(2, '0')}',
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
