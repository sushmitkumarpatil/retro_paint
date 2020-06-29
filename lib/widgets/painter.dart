import 'dart:ui';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

typedef ImageSaveCallback = void Function(Picture picture);

class PainterCanvas extends CustomPainter {
  List<PaintedPoints> pointsList;

  List<PaintedSquires> squaresList;
  PaintedSquires unfinishedSquare;

  List<PaintedCircles> circlesList;
  PaintedCircles unfinishedCircle;

  ImageSaveCallback saveCallback;

  bool saveImage;

  PainterCanvas(
      {this.pointsList,
      this.squaresList,
      this.unfinishedSquare,
      this.circlesList,
      this.unfinishedCircle,
      this.saveImage,
      this.saveCallback});

  List<Offset> offsetPoints = List();

  @override
  void paint(Canvas canvas, Size size) {
    final recorder = ui.PictureRecorder();
    if (saveImage) {
      canvas = Canvas(recorder);
    }
    canvas.drawColor(Colors.white, BlendMode.color);

    for (int i = 0; i < pointsList.length - 1; i++) {
      if (pointsList[i] != null && pointsList[i + 1] != null) {
        canvas.drawLine(pointsList[i].points, pointsList[i + 1].points,
            pointsList[i].paint);
      } else if (pointsList[i] != null && pointsList[i + 1] == null) {
        offsetPoints.clear();
        offsetPoints.add(pointsList[i].points);
        offsetPoints.add(Offset(
            pointsList[i].points.dx + 0.1, pointsList[i].points.dy + 0.1));
        canvas.drawPoints(PointMode.points, offsetPoints, pointsList[i].paint);
      }
    }

    for (var i = 0; i < squaresList.length; i++) {
      if (squaresList[i] != null) {
        squaresList[i].paint.style = PaintingStyle.stroke;
        final rect = Rect.fromPoints(squaresList[i].start, squaresList[i].end);
        canvas.drawRect(rect, squaresList[i].paint);
      }
    }

    for (var i = 0; i < circlesList.length; i++) {
      if (circlesList[i] != null) {
        circlesList[i].paint.style = PaintingStyle.stroke;
        double radius = (circlesList[i].end.dx - circlesList[i].start.dx) / 2;
        canvas.drawCircle(circlesList[i].start, radius, circlesList[i].paint);
      }
    }

    if (unfinishedSquare != null) {
      unfinishedSquare.paint.style = PaintingStyle.stroke;
      final rect =
          Rect.fromPoints(unfinishedSquare.start, unfinishedSquare.end);
      canvas.drawRect(rect, unfinishedSquare.paint);
    }

    if (unfinishedCircle != null) {
      unfinishedCircle.paint.style = PaintingStyle.stroke;
      double radius = 0;
      if (unfinishedCircle.start.dx > unfinishedCircle.end.dx)
        radius = (unfinishedCircle.start.dx - unfinishedCircle.end.dx) / 2;
      else
        radius = (unfinishedCircle.end.dx - unfinishedCircle.start.dx) / 2;
      canvas.drawCircle(unfinishedCircle.start, radius, unfinishedCircle.paint);
    }

    if (saveImage) {
      final Picture picture = recorder.endRecording();
      saveCallback(picture);
    }
  }

  @override
  bool shouldRepaint(PainterCanvas oldDelegate) => true;
}

class PaintedPoints {
  Paint paint;
  Offset points;
  PaintedPoints({this.points, this.paint});
}

class PaintedCircles {
  Paint paint;
  Offset start;
  Offset end;
  PaintedCircles({this.start, this.end, this.paint});
}

class PaintedSquires {
  Paint paint;
  Offset start;
  Offset end;
  PaintedSquires({this.paint, this.start, this.end});
}
