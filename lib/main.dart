import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:matrix4_transform/matrix4_transform.dart';
import 'package:align_positioned/align_positioned.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kinetic Text',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  bool isOnRight(double rotation) => math.cos(rotation) < 0;
  bool isOnLeft(double rotation) =>
      math.cos(rotation) > 0; //<---- check if angle is on the left

  @override
  Widget build(BuildContext context) {
    final numberOfTexts = 20;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox.expand(
        child: Stack(
          alignment: Alignment.center,
          children: List.generate(
            numberOfTexts,
            (index) {
              double rotation = 2 * math.pi * index / numberOfTexts +
                  math.pi / 2; //<----add 90 degrees

              return AnimatedBuilder(
                //<--- wrap everything in AnimatedBuilder
                animation: _animationController, //<--- pass the controller
                child:
                    LinearText(), //<--- set child for performance optimization
                builder: (context, child) {
                  final animationRotationValue = _animationController.value *
                      2 *
                      math.pi /
                      numberOfTexts; //<-- calculate animation rotation value
                  double rotation = 2 * math.pi * index / numberOfTexts +
                      math.pi / 2 +
                      animationRotationValue; //<-- add the animation value
                  if (isOnLeft(rotation)) {
                    rotation = -rotation +
                        2 * animationRotationValue - //<-- adjust the formula on the left side
                        math.pi * 2 / numberOfTexts;
                  }
                  return Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2,
                          0.001) //<--add perspective to the transformation
                      ..rotateY(rotation) //<----use the updated rotation
                      ..translate(-120.0),
                    child: LinearText(),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class LinearText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: 3,
      child: Container(
        child: Text(
          'FLUTTER',
          style: TextStyle(
            color: Colors.white,
            fontSize: 110,
          ),
        ),
        foregroundDecoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.9),
              Colors.transparent
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            stops: [0.0, 0.2, 0.8],
          ),
        ),
      ),
    );
  }
}
