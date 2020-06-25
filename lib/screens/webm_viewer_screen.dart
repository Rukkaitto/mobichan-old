import 'dart:async';
import 'dart:math';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

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
  VlcPlayerController _controller;
  double sliderValue = 0.0;
    bool isPlaying = true;
    double currentPlayerTime = 0;

  @override
  void initState() {

     super.initState();

    _controller = new VlcPlayerController(onInit: () {
      _controller.play();
    });

    _controller.addListener(() {
      setState( (){});
    });

    Timer.periodic(Duration(seconds: 1), (Timer timer) {
      String state = _controller.playingState.toString();
      if (this.mounted) {
        setState(() {
          if (state == "PlayingState.PLAYING" &&
              sliderValue < _controller.duration.inSeconds) {
            sliderValue = _controller.position.inSeconds.toDouble();
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
             SizedBox(
              height: 360,
              child: new VlcPlayer(
                aspectRatio: 16 / 9,
                url:
                    'https://i.4cdn.org/${widget.board}/${widget.imageId}${widget.ext}',
                controller: _controller,
                placeholder: Container(
                  height: 250.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[CircularProgressIndicator()],
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
                          _controller.setTime(0);
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
                          playOrPauseVideo();
                        },
                        icon: Icon(
                          isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                          color: Colors.white,
                        ),
                      ),
                      // IconButton(
                      //   onPressed: () {
                      //     setState(() {
                      //       _controller.value.volume == 0.0
                      //           ? _controller.setVolume(1.0)
                      //           : _controller.setVolume(0.0);
                      //     });
                      //   },
                      //   icon: Icon(
                      //     _controller.value.volume == 0.0
                      //         ? Icons.volume_off
                      //         : Icons.volume_up,
                      //     color: Colors.white,
                      //   ),
                      // ),
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
                            max:  _controller.duration == null ? 1.0 :  _controller.duration.inSeconds.toDouble(),
                            onChanged: (progress) {
                              setState(() {
                                sliderValue = progress.floor().toDouble();
                                print('set state: $sliderValue');
                              });
                              print('set time:  $sliderValue');
                              _controller.setTime(sliderValue.toInt());
                            },
                          ),
                        ),
                        Text(
                          _controller.duration == null
                              ? '0:00'
                              : '${_controller.duration.inMinutes}:${(_controller.duration.inSeconds % 60).toString().padLeft(2, '0')}',
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
    void playOrPauseVideo() {
    String state = _controller.playingState.toString();
    
    if  ( state == "PlayingState.PLAYING" ){
      _controller.pause();
     setState(() {
       isPlaying = false;
     });
    } else {
      _controller.play();
     setState(() {
        isPlaying = true;
     });
    }
  
  }
}

