import 'dart:ui';
import 'package:flutter/material.dart';

class SwitchPainter extends CustomPainter {
  final double switcherStep;

  final double heightToRadiusRatio;
  final Color switcherColor;
  final Color backgroundColor;

  SwitchPainter(this.switcherStep,
      {this.switcherColor, this.backgroundColor, this.heightToRadiusRatio});

  @override
  void paint(Canvas canvas, Size size) {
    _paintBackground(canvas, size, _paintBuilder(backgroundColor));

    final circlePaint = _paintBuilder(switcherColor);
    final backgroundPaint = _paintBuilder(backgroundColor);

    _paintSwitchOn(
        canvas, size, circlePaint, switcherStep, heightToRadiusRatio);

    _paintSwitchOff(canvas, size, circlePaint, backgroundPaint, switcherStep,
        heightToRadiusRatio);
  }

  @override
  bool shouldRepaint(SwitchPainter oldDelegate) => true;

  void _paintBackground(Canvas canvas, Size size, Paint paintSun) {
    final radiusCircle = size.height / 2;

    final path = Path()
      ..moveTo(radiusCircle, 0)
      ..lineTo(size.width - radiusCircle, 0)
      ..arcToPoint(Offset(size.width - radiusCircle, size.height),
          radius: Radius.circular(radiusCircle), clockwise: true)
      ..lineTo(radiusCircle, size.height)
      ..arcToPoint(Offset(radiusCircle, 0),
          radius: Radius.circular(radiusCircle), clockwise: true);

    canvas.drawPath(path, paintSun);
  }

  void _paintSwitchOn(Canvas canvas, Size size, Paint paintOn, double step,
      double heightToRadiusRatio) {
    final height = _heightSwitcher(size, heightToRadiusRatio);
    final secondHeight = _heightSwitcher(size, heightToRadiusRatio / 2);
    final weight = height - secondHeight;
    final centerPoint = _switcherCenterPoint(size, step);

    final topPoint = height / 2 - weight / 2;

    final leftPoint = centerPoint.dx - weight / 2;
    final rightPoint = centerPoint.dx + weight / 2;

    final path = Path()
      ..moveTo(leftPoint, centerPoint.dy - topPoint)
      ..arcToPoint(Offset(rightPoint, centerPoint.dy - topPoint),
          radius: Radius.circular(weight / 2))
      ..lineTo(rightPoint, centerPoint.dy + topPoint)
      ..arcToPoint(Offset(leftPoint, centerPoint.dy + topPoint),
          radius: Radius.circular(weight / 2))
      ..lineTo(leftPoint, centerPoint.dy - topPoint);

    canvas.drawPath(path, paintOn);
  }

  void _paintSwitchOff(Canvas canvas, Size size, Paint circlePaint,
      Paint paintBackground, double step, double heightToRadiusRatio) {
    final centerCirclePoint = _switcherCenterPoint(size, switcherStep);

    canvas
      ..drawOval(
          Rect.fromCenter(
              center: centerCirclePoint,
              width: _heightSwitcher(size, heightToRadiusRatio) -
                  _heightSwitcher(size, heightToRadiusRatio) * step,
              height: _heightSwitcher(size, heightToRadiusRatio)),
          circlePaint)
      ..drawOval(
          Rect.fromCenter(
              center: centerCirclePoint,
              width: _heightSwitcher(size, heightToRadiusRatio / 2) -
                  _heightSwitcher(size, heightToRadiusRatio / 2) * step,
              height: _heightSwitcher(size, heightToRadiusRatio / 2)),
          paintBackground);
  }

  Paint _paintBuilder(Color color) => Paint()
    ..color = color
    ..style = PaintingStyle.fill;

  double _heightSwitcher(Size size, double heightToRadiusRatio) =>
      size.height - (1 - heightToRadiusRatio) * size.height;

  Offset _switcherCenterPoint(Size size, double step) {
    final dx = size.height / 2 + (size.width - size.height) * step;
    final dy = size.height / 2;
    return Offset(dx, dy);
  }
}
