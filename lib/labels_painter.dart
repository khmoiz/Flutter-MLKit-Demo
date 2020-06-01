import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class LabelsPainter extends CustomPainter {
  final ui.Image image;
  final List<ImageLabel> labels;
  final List<Rect> rects = [];

  LabelsPainter(this.image, this.labels) {
    /*for (var i = 0; i < labels.length; i++) {
      rects.add(labels[i].);
    }*/
  }

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    final Paint paint = Paint();
//      ..style = PaintingStyle.stroke
//      ..strokeWidth = 10.0
//      ..color = Colors.redAccent;

    canvas.drawImage(image, Offset.zero, Paint());
//    for (var i = 0; i < labels.length; i++) {
//      canvas.drawRect(rects[i], paint);
//    }
  }

  @override
  bool shouldRepaint(LabelsPainter oldDelegate) {
    return image != oldDelegate.image || labels != oldDelegate.labels;
  }
}
