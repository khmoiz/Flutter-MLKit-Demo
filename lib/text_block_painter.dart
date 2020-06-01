import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class TextBlockPainter extends CustomPainter {
  final ui.Image image;
  final List<TextBlock> blocks;
  final List<Rect> rects = [];

  TextBlockPainter(this.image, this.blocks) {
    for (var i = 0; i < blocks.length; i++) {
      rects.add(blocks[i].boundingBox);
    }
  }

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0
      ..color = Colors.redAccent;

    canvas.drawImage(image, Offset.zero, Paint());
    for (var i = 0; i < blocks.length; i++) {
      canvas.drawRect(rects[i], paint);
    }
  }

  @override
  bool shouldRepaint(TextBlockPainter oldDelegate) {
    return image != oldDelegate.image || blocks != oldDelegate.blocks;
  }
}
