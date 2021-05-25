library full_screen_image;

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class FullScreenWidget extends StatefulWidget {
  FullScreenWidget({
    required this.child,
    this.backgroundColor = Colors.black,
    this.backgroundIsTransparent = true,
    required this.disposeLevel,
  });

  final Widget child;
  final Color backgroundColor;
  final bool backgroundIsTransparent;
  final DisposeLevel disposeLevel;

  _FullScreenWidgetState createState() => _FullScreenWidgetState();
}

class _FullScreenWidgetState extends State<FullScreenWidget> {
  bool isOpenFullScreenMode = false;

  void changeOpenFullScreenMode (value) {
    setState(() {
      isOpenFullScreenMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        changeOpenFullScreenMode(true);
        Navigator.push(
            context,
            PageRouteBuilder(
                opaque: false,
                barrierColor: widget.backgroundIsTransparent
                    ? Colors.white.withOpacity(0)
                    : widget.backgroundColor,
                pageBuilder: (BuildContext context, _, __) {
                  return FullScreenPage(
                    backgroundColor: widget.backgroundColor,
                    backgroundIsTransparent: widget.backgroundIsTransparent,
                    disposeLevel: widget.disposeLevel,
                    changeOpenFullScreenMode: changeOpenFullScreenMode,
                    child: widget.child,
                  );
                }
            )
        );
      },
      child: widget.child,
    );
  }
}

enum DisposeLevel { High, Medium, Low }

class FullScreenPage extends StatefulWidget {
  FullScreenPage({
    required this.child,
    this.changeOpenFullScreenMode,
    this.backgroundColor = Colors.black,
    this.backgroundIsTransparent = true,
    this.disposeLevel = DisposeLevel.Medium
  });

  final Widget child;
  final Color backgroundColor;
  final bool backgroundIsTransparent;
  final DisposeLevel disposeLevel;
  final Function? changeOpenFullScreenMode;

  @override
  _FullScreenPageState createState() => _FullScreenPageState();
}

class _FullScreenPageState extends State<FullScreenPage> {
  double initialPositionY = 0;

  double currentPositionY = 0;

  double positionYDelta = 0;

  double opacity = 1;

  double disposeLimit = 150;

  late Duration animationDuration;

  double opacityLevel = 1.0;

  late PhotoViewScaleStateController scaleStateController;

  bool isScaleStateZooming = false;

  void _changeOpacity() {
    setState(() => opacityLevel = opacityLevel == 0 ? 1.0 : 0.0);
  }

  void onScaleState(PhotoViewScaleState scaleState) {
    setState(() {
      isScaleStateZooming = scaleState.isScaleStateZooming;
    });
  }

  @override
  void dispose() {
    scaleStateController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    setDisposeLevel();
    scaleStateController = PhotoViewScaleStateController()
      ..outputScaleStateStream.listen(onScaleState);
    super.initState();
    animationDuration = Duration.zero;
  }

  setDisposeLevel() {
    setState(() {
      if (widget.disposeLevel == DisposeLevel.High)
        disposeLimit = 300;
      else if (widget.disposeLevel == DisposeLevel.Medium)
        disposeLimit = 200;
      else
        disposeLimit = 100;
    });
  }

  void _startVerticalDrag(PointerDownEvent details) {
    setState(() {
      initialPositionY = details.position.dy.toDouble();
    });
  }

  void _whileVerticalDrag(PointerMoveEvent details) {
    if (!isScaleStateZooming) {
      setState(() {
        currentPositionY = details.position.dy.toDouble();
        positionYDelta = currentPositionY - initialPositionY;
        setOpacity();
      });
    }
  }

  setOpacity() {
    double tmp = positionYDelta < 0
        ? 1 - ((positionYDelta / 1000) * -1)
        : 1 - (positionYDelta / 1000);
    if (tmp > 1)
      opacity = 1;
    else if (tmp < 0)
      opacity = 0;
    else
      opacity = tmp;

    if (positionYDelta > disposeLimit || positionYDelta < -disposeLimit) {
      opacity = 0.5;
    }
  }

  _endVerticalDrag(PointerUpEvent details) {
    if (!isScaleStateZooming && (positionYDelta > disposeLimit || positionYDelta < -disposeLimit)) {
      Navigator.of(context).pop();
      _changeOpacity();
      setState(() {
        animationDuration = Duration(milliseconds: 300);
        opacity = 0;
        positionYDelta = positionYDelta > disposeLimit ? positionYDelta + 530 : positionYDelta - 530;
      });

      Future.delayed(animationDuration).then((_){
        setState(() {
          animationDuration = Duration.zero;
        });
      });

      if(widget.changeOpenFullScreenMode != null) {
        widget.changeOpenFullScreenMode!(false);
      }
    } else {
      setState(() {
        animationDuration = Duration(milliseconds: 300);
        opacity = 1;
        positionYDelta = 0;
      });

      Future.delayed(animationDuration).then((_){
        setState(() {
          animationDuration = Duration.zero;
        });
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundIsTransparent
          ? Colors.transparent
          : widget.backgroundColor,
      body: Listener(
        onPointerDown: _startVerticalDrag,
        onPointerMove: _whileVerticalDrag,
        onPointerUp: _endVerticalDrag,
        child: Container(
          color: widget.backgroundColor.withOpacity(opacity),
          constraints: BoxConstraints.expand(
            height: MediaQuery.of(context).size.height,
          ),
          child: Stack(
            children: <Widget>[
              AnimatedPositioned(
                duration: animationDuration,
                curve: Curves.fastOutSlowIn,
                top: 0 + positionYDelta,
                bottom: 0 - positionYDelta,
                left: 0,
                right: 0,
                child: PhotoView.customChild(
                  scaleStateController: scaleStateController,
                  gestureDetectorBehavior: HitTestBehavior.deferToChild,
                  tightMode: true,
                  childSize: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height),
                  child: widget.child,
                  backgroundDecoration: BoxDecoration(color: Colors.transparent),
                  customSize: MediaQuery.of(context).size,
                  heroAttributes: const PhotoViewHeroAttributes(
                    tag: "photo",
                    transitionOnUserGestures: true,
                  ),
                  enableRotation: false,
                  minScale: PhotoViewComputedScale.contained * 0.8,
                  maxScale: PhotoViewComputedScale.covered * 3,
                  initialScale: PhotoViewComputedScale.contained,
                  basePosition: Alignment.center,
                ),
              ),
              Positioned(
                top: 76,
                right: 20,
                child: AnimatedOpacity(
                  opacity: opacityLevel,
                  duration: Duration(milliseconds: 300),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    ),
                    child: MaterialButton(
                      onPressed: (){
                        _changeOpacity();
                        Navigator.pop(context);
                        if(widget.changeOpenFullScreenMode != null) {
                          widget.changeOpenFullScreenMode!(false);
                        }
                      },
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(5),
                      child: Icon(
                        Icons.close_rounded,
                        size: 22,
                        color: Color(0xFF00172C).withOpacity(0.9),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

