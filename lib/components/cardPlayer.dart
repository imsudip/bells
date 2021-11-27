import 'dart:async';
import 'dart:ui';

import 'package:audio/audio.dart';
import 'package:bells/business/ResponseModel.dart';
import 'package:bells/business/ringtone.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:ringtone_set/ringtone_set.dart';

import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:velocity_x/velocity_x.dart';

import '../styles.dart';

class CardPlayer extends StatefulWidget {
  final RingtoneModel r;
  final Animation<double> animation;
  CardPlayer({Key key, this.r, this.animation}) : super(key: key);

  @override
  _CardPlayerState createState() => _CardPlayerState();
}

class _CardPlayerState extends State<CardPlayer> {
  Audio audioPlayer = new Audio(single: true, positionInterval: 500);
  AudioPlayerState state = AudioPlayerState.STOPPED;
  double position = 0;
  int buffering = 0;
  StreamSubscription<AudioPlayerState> _playerStateSubscription;
  StreamSubscription<double> _playerPositionController;
  StreamSubscription<int> _playerBufferingSubscription;
  StreamSubscription<AudioPlayerError> _playerErrorSubscription;
  void initState() {
    _playerStateSubscription =
        audioPlayer.onPlayerStateChanged.listen((AudioPlayerState state) {
      if (mounted) {
        setState(() => this.state = state);
      }
    });

    _playerPositionController =
        audioPlayer.onPlayerPositionChanged.listen((double position) {
      if (mounted) setState(() => this.position = position);
    });

    _playerBufferingSubscription =
        audioPlayer.onPlayerBufferingChanged.listen((int percent) {
      if (mounted && buffering != percent) setState(() => buffering = percent);
    });

    _playerErrorSubscription =
        audioPlayer.onPlayerError.listen((AudioPlayerError error) {
      throw ("onPlayerError: ${error.code} ${error.message}");
    });

    //audioPlayer.preload(widget.r.audioUrl);

    super.initState();
  }

  @override
  void dispose() {
    _playerStateSubscription.cancel();
    _playerPositionController.cancel();
    _playerBufferingSubscription.cancel();
    _playerErrorSubscription.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(
        begin: 0.2,
        end: 1,
      ).animate(widget.animation),
      // And slide transition
      child: [
        Positioned.fill(
          left: 26,
          right: 16,
          child: LinearPercentIndicator(
            width: MediaQuery.of(context).size.width - 80,
            animation: true,
            lineHeight: 56,
            curve: Curves.linear,
            animationDuration: 500,
            animateFromLastPercent: true,
            percent: (position / widget.r.meta.durationMs) >= 1
                ? 1
                : position / widget.r.meta.durationMs,
            backgroundColor: white.withOpacity(0.0),
            linearStrokeCap: LinearStrokeCap.roundAll,
            progressColor: Vx.hexToColor('#' + widget.r.meta.gradientStart)
                .withOpacity(0.15),
          ),
        ),
        _cardPart(widget.r, orange).py(10),
      ].zStack().box.color(white).make().onInkTap(() async {
        if (state == AudioPlayerState.STOPPED ||
            state == AudioPlayerState.PAUSED)
          await audioPlayer.play(widget.r.meta.previewUrl);
        await audioPlayer.pause();
      }),
    );
  }

  onPlay() {
    audioPlayer.play(widget.r.meta.previewUrl);
  }

  onPause() {
    audioPlayer.pause();
  }

  onSeek(double value) {
    // Note: We can only seek if the audio is ready
    audioPlayer.seek(value);
  }

  Widget _cardPart(RingtoneModel r, Color orange) {
    Widget status = Container();

    // print(
    //     "[build] uid=${audioPlayer.uid} duration=${audioPlayer.duration} state=$state");

    switch (state) {
      case AudioPlayerState.LOADING:
        {
          status = Container(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                width: 24.0,
                height: 24.0,
                child: Center(
                    child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: <Widget>[
                    CircularProgressIndicator(
                      strokeWidth: 1,
                      backgroundColor:
                          Vx.hexToColor('#' + r.meta.gradientStart),
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ],
                )),
              ));
          break;
        }

      case AudioPlayerState.PLAYING:
        {
          status = IconButton(
              icon: Icon(
                Icons.pause,
                size: 28.0,
                color: white,
              ),
              onPressed: onPause);
          break;
        }

      case AudioPlayerState.READY:
      case AudioPlayerState.PAUSED:
      case AudioPlayerState.STOPPED:
        {
          status = IconButton(
              icon: Icon(Icons.play_arrow, size: 28.0, color: white),
              onPressed: onPlay);

          if (state == AudioPlayerState.STOPPED) audioPlayer.seek(0.0);

          break;
        }
    }
    return [
      10.widthBox,
      Container(
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Vx.hexToColor('#' + r.meta.gradientStart)
                      .withOpacity(0.2),
                  blurRadius: 6,
                  offset: Offset(3, 3),
                  spreadRadius: 3)
            ],
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Vx.hexToColor('#' + r.meta.gradientEnd),
                  Vx.hexToColor('#' + r.meta.gradientStart)
                ]),
            shape: BoxShape.circle),
        child: Hero(
          tag: audioPlayer.uid,
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: white, width: 2),
                shape: BoxShape.circle),
            child: status,
          ),
        ),
      ),
      10.widthBox,
      [
        [
          r.title.text.bold.textStyle(subtitle1).color(black).make(),
          r.profile.name.text.textStyle(subtitle2).gray500.make()
        ].vStack(crossAlignment: CrossAxisAlignment.start),
        ((r.meta.durationMs / 1000).toInt().toString() + 's')
            .text
            .textStyle(subtitle2)
            .gray500
            .make(),
      ].hStack(alignment: MainAxisAlignment.spaceBetween).expand(),
      16.widthBox
    ].hStack(axisSize: MainAxisSize.max).onInkTap(() {
      showDialog(
          context: context,
          builder: (context) {
            onPause();
            return PopupWidget(
              rr: r,
            );
          });
    });
  }
}

class PopupWidget extends StatefulWidget {
  final RingtoneModel rr;
  PopupWidget({Key key, this.rr}) : super(key: key);

  @override
  _PopupWidgetState createState() => _PopupWidgetState();
}

class _PopupWidgetState extends State<PopupWidget> {
  RingtoneModel r;
  Audio audioPlayer = new Audio(single: true, positionInterval: 500);
  AudioPlayerState state = AudioPlayerState.STOPPED;
  double position = 0;
  int buffering = 0;
  StreamSubscription<AudioPlayerState> _playerStateSubscription;
  StreamSubscription<double> _playerPositionController;
  StreamSubscription<int> _playerBufferingSubscription;
  StreamSubscription<AudioPlayerError> _playerErrorSubscription;
  void initState() {
    _playerStateSubscription =
        audioPlayer.onPlayerStateChanged.listen((AudioPlayerState state) {
      if (mounted) setState(() => this.state = state);
    });

    _playerPositionController =
        audioPlayer.onPlayerPositionChanged.listen((double position) {
      if (mounted) setState(() => this.position = position);
    });

    _playerBufferingSubscription =
        audioPlayer.onPlayerBufferingChanged.listen((int percent) {
      if (mounted && buffering != percent) setState(() => buffering = percent);
    });

    _playerErrorSubscription =
        audioPlayer.onPlayerError.listen((AudioPlayerError error) {
      throw ("onPlayerError: ${error.code} ${error.message}");
    });

    //audioPlayer.preload(widget.r.audioUrl);

    super.initState();
    r = widget.rr;
  }

  Widget circleIcon(Color color, IconData icon) {
    return Container(
      height: 45,
      width: 45,
      child: Icon(
        icon,
        color: color,
      ).centered(),
    );
  }

  Widget status = Icon(
    EvaIcons.playCircleOutline,
    size: 40,
    color: black,
  );
  @override
  void dispose() {
    _playerBufferingSubscription.cancel();
    _playerErrorSubscription.cancel();
    _playerPositionController.cancel();
    _playerStateSubscription.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case AudioPlayerState.LOADING:
        {
          status = Container(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                width: 24.0,
                height: 24.0,
                child: Center(
                    child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: <Widget>[
                    CircularProgressIndicator(
                      strokeWidth: 1,
                      backgroundColor:
                          Vx.hexToColor('#' + r.meta.gradientStart),
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ],
                )),
              ));
          break;
        }

      case AudioPlayerState.PLAYING:
        {
          status = status = Icon(
            Icons.pause,
            size: 25,
            color: Vx.hexToColor('#' + r.meta.gradientStart),
          );
          break;
        }

      case AudioPlayerState.READY:
      case AudioPlayerState.PAUSED:
      case AudioPlayerState.STOPPED:
        {
          status = Icon(
            EvaIcons.arrowRightOutline,
            size: 40,
            color: Vx.hexToColor('#' + r.meta.gradientStart),
          );

          if (state == AudioPlayerState.STOPPED) audioPlayer.seek(0.0);

          break;
        }
    }
    return Container(
        color: white.withOpacity(0.05),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: Center(
            child: [
              Container(
                width: context.percentWidth * 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: white,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    20.heightBox,
                    CircularPercentIndicator(
                      radius: 80,
                      lineWidth: 1,
                      animation: true,
                      animationDuration: 500,
                      curve: Curves.linear,
                      animateFromLastPercent: true,
                      percent: (position / widget.rr.meta.durationMs) >= 1
                          ? 1
                          : position / widget.rr.meta.durationMs,
                      circularStrokeCap: CircularStrokeCap.round,
                      backgroundColor: black.withOpacity(0.05),
                      progressColor: Vx.hexToColor('#' + r.meta.gradientStart),
                      center: Container(
                          margin: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color:
                                      Vx.hexToColor('#' + r.meta.gradientStart)
                                          .withOpacity(0.2),
                                  blurRadius: 6,
                                  offset: Offset(3, 3),
                                  spreadRadius: 3)
                            ],
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Vx.hexToColor('#' + r.meta.gradientEnd),
                                  Vx.hexToColor('#' + r.meta.gradientStart)
                                ]),
                          ),
                          child: Icon(
                            EvaIcons.musicOutline,
                            size: 38,
                            color: Vx.hexToColor('#' + r.meta.gradientEnd)
                                        .computeLuminance() >
                                    0.6
                                ? black
                                : white,
                          ).centered()),
                    ),
                    12.heightBox,
                    r.title.text.bold.textStyle(subtitle1).color(black).make(),
                    r.profile.name.text.textStyle(subtitle2).gray500.make(),
                    20.heightBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        circleIcon(Vx.hexToColor('#' + r.meta.gradientStart),
                            EvaIcons.cloudDownload),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            splashColor:
                                Vx.hexToColor('#' + r.meta.gradientStart),
                            enableFeedback: true,
                            onTap: () async {
                              if (state == AudioPlayerState.STOPPED ||
                                  state == AudioPlayerState.PAUSED) {
                                await audioPlayer
                                    .play(widget.rr.meta.previewUrl);
                              } else
                                await audioPlayer.pause();
                            },
                            child: status.circle(
                                radius: 60,
                                backgroundColor: Colors.transparent,
                                border: Border.all(
                                    width: 1,
                                    color: Vx.hexToColor(
                                        '#' + r.meta.gradientStart))),
                          ),
                        ),
                        circleIcon(Vx.hexToColor('#' + r.meta.gradientStart),
                            EvaIcons.heartOutline)
                      ],
                    ).px20(),
                    20.heightBox,
                    Container(
                      height: 50,
                      width: 210,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Vx.hexToColor('#' + r.meta.gradientStart)
                                  .withOpacity(0.2),
                              blurRadius: 6,
                              offset: Offset(3, 3),
                              spreadRadius: 3)
                        ],
                        borderRadius: BorderRadius.circular(32),
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Vx.hexToColor('#' + r.meta.gradientEnd),
                              Vx.hexToColor('#' + r.meta.gradientStart)
                            ]),
                      ),
                      child: 'Apply'
                          .text
                          .color(Vx.hexToColor('#' + r.meta.gradientEnd)
                                      .computeLuminance() >
                                  0.6
                              ? black
                              : white)
                          .capitalize
                          .bold
                          .textStyle(subtitle1)
                          .make()
                          .centered(),
                    ).onTap(() {
                      RingtoneSet.setRingtoneFromNetwork(
                              r.meta.previewUrl, r.title.removeAllWhiteSpace())
                          .then((value) {
                        if (value) {
                          context.showToast(msg: 'Ringtone set');
                        } else {
                          context.showToast(msg: 'Ringtone set failed');
                        }
                      });
                    }),
                    20.heightBox,
                  ],
                ),
              ),
              Positioned(
                  top: 10,
                  right: 10,
                  child: Icon(
                    EvaIcons.close,
                    size: 28,
                  ).onTap(() {
                    audioPlayer.stop();
                    context.pop();
                  }))
            ].zStack(),
          ),
        ));
  }
}
