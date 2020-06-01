import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class BarcodePainter extends CustomPainter {
  final ui.Image image;
  final List<Barcode> barcodes;
  final List<Rect> rects = [];

  BarcodePainter(this.image, this.barcodes) {
    for (var i = 0; i < barcodes.length; i++) {
      rects.add(barcodes[i].boundingBox);
    }
  }

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0
      ..color = Colors.redAccent;

    canvas.drawImage(image, Offset.zero, Paint());
    for (var i = 0; i < barcodes.length; i++) {
      canvas.drawRect(rects[i], paint);
    }
  }

  @override
  bool shouldRepaint(BarcodePainter oldDelegate) {
    return image != oldDelegate.image || barcodes != oldDelegate.barcodes;
  }
}
