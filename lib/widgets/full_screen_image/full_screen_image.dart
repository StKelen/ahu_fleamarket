import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FullScreenWidget extends StatelessWidget {
  FullScreenWidget(
      {@required this.child,
      this.backgroundColor = Colors.black,
      this.backgroundIsTransparent = true});

  final Widget child;
  final Color backgroundColor;
  final bool backgroundIsTransparent;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            PageRouteBuilder(
                opaque: false,
                barrierColor:
                    backgroundIsTransparent ? Colors.white.withOpacity(0) : backgroundColor,
                pageBuilder: (BuildContext context, _, __) {
                  return FullScreenPage(
                    child: child,
                    backgroundColor: backgroundColor,
                    backgroundIsTransparent: backgroundIsTransparent,
                  );
                }));
      },
      child: child,
    );
  }
}

enum DisposeLevel { High, Medium, Low }

class FullScreenPage extends StatefulWidget {
  FullScreenPage(
      {@required this.child,
      this.backgroundColor = Colors.black,
      this.backgroundIsTransparent = true});

  final Widget child;
  final Color backgroundColor;
  final bool backgroundIsTransparent;

  @override
  _FullScreenPageState createState() => _FullScreenPageState();
}

class _FullScreenPageState extends State<FullScreenPage> {
  double initialPositionY = 0;

  double currentPositionY = 0;

  double positionYDelta = 0;

  double opacity = 1;

  double disposeLimit = 150;

  Duration animationDuration;

  @override
  void initState() {
    super.initState();
    animationDuration = Duration.zero;
  }

  setOpacity() {
    double tmp =
        positionYDelta < 0 ? 1 - ((positionYDelta / 1000) * -1) : 1 - (positionYDelta / 1000);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundIsTransparent ? Colors.transparent : widget.backgroundColor,
      body: InkWell(
        onTap: () => Navigator.pop(context),
        child: Container(
          color: widget.backgroundColor.withOpacity(opacity),
          constraints: BoxConstraints.expand(
            height: 1334.h,
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
                child: widget.child,
              )
            ],
          ),
        ),
      ),
    );
  }
}
