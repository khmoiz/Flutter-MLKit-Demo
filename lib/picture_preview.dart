import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:firebasemlkitdemo/scanner_type.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'barcode_painter.dart';
import 'face_painter.dart';
import 'labels_painter.dart';
import 'text_block_painter.dart';

class PicturePreview extends StatefulWidget {
  final File imageFile;
  final ScannerType _currentType;

  PicturePreview(this.imageFile, this._currentType);

  @override
  _PicturePreviewState createState() => _PicturePreviewState();
}

class _PicturePreviewState extends State<PicturePreview> {
  String finalBarcode;
  ui.Image imageDecoded;
  List<Face> _faces;
  List<Barcode> _barcodes;
  List<ImageLabel> _labels;
  VisionText _visionText;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    this.processImageML(widget.imageFile);
  }

  Future<void> processImageML(File imageFile) async {
    final data = await imageFile.readAsBytes();
    await decodeImageFromList(data).then((value) {
      setState(() {
        imageDecoded = value;
      });
    });
    final image = FirebaseVisionImage.fromFile(imageFile);
    switch (widget._currentType) {
      case ScannerType.BarcodeDetector:
        scanBarcode(image);
        break;
      case ScannerType.ImageLabeler:
        scanLabels(image);
        break;
      case ScannerType.FaceDetector:
        scanFace(image);
        break;
      case ScannerType.TextRecognizer:
        scanText(image);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('${widget._currentType}'),
        ),
        body: Center(
          child: Container(
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.all(8),
            child: Column(
              children: [
                Flexible(
                    flex: 3,
                    child: Container(
                      margin: EdgeInsets.all(8),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.black54),
                      child: (widget.imageFile == null || isLoading)
                          ? CircularProgressIndicator()
                          : FittedBox(
                              child: SizedBox(
                                width: imageDecoded.width.toDouble(),
                                height: imageDecoded.height.toDouble(),
                                child: getCustomerPainter(imageDecoded),
                              ),
                            ),
                    )),
                Flexible(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text('Data From Image'),
                  ),
                ),
                Expanded(
                    flex: 2,
                    child: isLoading
                        ? Center(child: CircularProgressIndicator())
                        : Container(
                            width: double.infinity,
                            child: widget._currentType ==
                                    ScannerType.TextRecognizer
                                ? SingleChildScrollView(
                                    child: Text(
                                    "${this._visionText.text}",
                                    textAlign: TextAlign.center,
                                  ))
                                : ListView(
                                    children: getListViewForCurrentType(
                                        widget._currentType)),
                          )),
              ],
            ),
          ),
        ));
  }

  Future<void> scanBarcode(FirebaseVisionImage imageFile) async {
    var detector = FirebaseVision.instance.barcodeDetector();

    final barcodes = await detector.detectInImage(imageFile);

    for (Barcode barcode in barcodes) {
      final Rect boundingBox = barcode.boundingBox;
      final List<Offset> cornerPoints = barcode.cornerPoints;

      print(
          '===================================== BARCODE UPDATE ~ RAW VALUE: ${barcode.rawValue.toString()} =====================================');
      print(
          '===================================== BARCODE UPDATE ~ VALUE TYPE: ${barcode.valueType.toString()} =====================================');
      print(
          '===================================== BARCODE UPDATE ~ DISPLAY VALUE: ${barcode.displayValue.toString()} =====================================');

      final BarcodeValueType valueType = barcode.valueType;

      // See API reference for complete list of supported types
      switch (valueType) {
        case BarcodeValueType.wifi:
          final String ssid = barcode.wifi.ssid;
          final String password = barcode.wifi.password;
          final BarcodeWiFiEncryptionType type = barcode.wifi.encryptionType;
          break;
        case BarcodeValueType.url:
          final String title = barcode.url.title;
          final String url = barcode.url.url;
          break;
        case BarcodeValueType.unknown:
          // TODO: Handle this case.
          break;
        case BarcodeValueType.contactInfo:
          // TODO: Handle this case.
          break;
        case BarcodeValueType.email:
          // TODO: Handle this case.
          break;
        case BarcodeValueType.isbn:
          // TODO: Handle this case.
          break;
        case BarcodeValueType.phone:
          // TODO: Handle this case.
          break;
        case BarcodeValueType.product:
          // TODO: Handle this case.
          break;
        case BarcodeValueType.sms:
          // TODO: Handle this case.
          break;
        case BarcodeValueType.text:
          // TODO: Handle this case.
          break;
        case BarcodeValueType.geographicCoordinates:
          // TODO: Handle this case.
          break;
        case BarcodeValueType.calendarEvent:
          // TODO: Handle this case.
          break;
        case BarcodeValueType.driverLicense:
          // TODO: Handle this case.
          break;
      }
    }

    if (mounted) {
      setState(() {
        _barcodes = barcodes;
        isLoading = false;
      });
    }
    detector.close();
  }

  Future<void> scanFace(FirebaseVisionImage image) async {
    var detector = FirebaseVision.instance
        .faceDetector(FaceDetectorOptions(enableClassification: true));
    List<Face> faces = await detector.processImage(image);

    if (mounted) {
      setState(() {
        _faces = faces;
        isLoading = false;
      });
    }
    detector.close();
  }

  Future<void> scanLabels(FirebaseVisionImage image) async {
    var detector = FirebaseVision.instance.imageLabeler();
    List<ImageLabel> labels = await detector.processImage(image);

    if (mounted) {
      setState(() {
        _labels = labels;
        isLoading = false;
      });
    }
    detector.close();
  }

  Future<void> scanText(FirebaseVisionImage image) async {
    var detector = FirebaseVision.instance.textRecognizer();
    VisionText visionTexts = await detector.processImage(image);

    if (mounted) {
      setState(() {
        _visionText = visionTexts;
        isLoading = false;
      });
    }
    detector.close();
  }

  getListViewForCurrentType(ScannerType currentType) {
    if (currentType == ScannerType.BarcodeDetector) {
      return _barcodes.map<Widget>((e) {
        return BarcodeDetails(e);
      }).toList();
    } else if (currentType == ScannerType.ImageLabeler) {
      return _labels.map<Widget>((e) {
        return LabelDetails(e);
      }).toList();
    }
    /* else if (currentType == ScannerType.TextRecognizer) {
      var temp = _visionText.blocks;
      return temp.toList().map<Widget>((e) {
        return TextBlockDetails(e);
      }).toList();
    } */
    else if (currentType == ScannerType.FaceDetector) {
      return _faces.map<Widget>((e) {
        return FaceDetails(e);
      }).toList();
    }
  }

  getCustomerPainter(ui.Image imageDecoded) {
    var currentType = widget._currentType;
    if (currentType == ScannerType.BarcodeDetector) {
      return CustomPaint(
        painter: BarcodePainter(imageDecoded, _barcodes),
      );
    } else if (currentType == ScannerType.ImageLabeler) {
      return CustomPaint(
        painter: LabelsPainter(imageDecoded, _labels),
      );
    } else if (currentType == ScannerType.TextRecognizer) {
      return CustomPaint(
        painter: TextBlockPainter(imageDecoded, _visionText.blocks),
      );
    } else if (currentType == ScannerType.FaceDetector) {
      return CustomPaint(
        painter: FacePainter(imageDecoded, _faces),
      );
    }
  }
}

class BarcodeDetails extends StatelessWidget {
  final Barcode barcode;

  BarcodeDetails(this.barcode);

  @override
  Widget build(BuildContext context) {
//    face.
    final pos = barcode.boundingBox;
    return ListTile(
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Raw Value: ${barcode.rawValue}'),
          Text('Value Type: ${barcode.valueType}'),
          Text('Bounding Box: ${barcode.boundingBox.toString().substring(13)}'),
          Text('URL ?: ${barcode.url}'),
          Text('Number ?: ${barcode.phone.toString()}'),
          Text('WiFi ?: ${barcode.wifi.toString()}'),
          Text('Email ?: ${barcode.email.toString()}'),
        ],
      ),
      title: Text("Display Value : ${barcode.displayValue}"),
    );
  }
}

class FaceDetails extends StatelessWidget {
  final Face face;

  FaceDetails(this.face);

  @override
  Widget build(BuildContext context) {
//    face.
    final pos = face.boundingBox;
    return ListTile(
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tracking ID: ${face.trackingId.toString()}'),
          Text(
              'Right Eye Open: ${(face.rightEyeOpenProbability * 100).toStringAsPrecision(4)}%'),
          Text(
              'Left Eye Open: ${(face.leftEyeOpenProbability * 100).toStringAsPrecision(4)}%'),
          Text('Bounding Box: ${face.boundingBox.toString().substring(13)}'),
        ],
      ),
      title: Text(
          "Smile Percentage: ${((face.smilingProbability * 100).toStringAsPrecision(4))}%"),
    );
  }
}

class LabelDetails extends StatelessWidget {
  final ImageLabel label;

  LabelDetails(this.label);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              'Confidence: ${(label.confidence * 100).toStringAsPrecision(4)}%'),
          Text('Entity ID: ${label.entityId.toString()}'),
        ],
      ),
      title: Text("${label.text}"),
    );
  }
}

class TextBlockDetails extends StatelessWidget {
  final block;

  TextBlockDetails(this.block);

  @override
  Widget build(BuildContext context) {
    print("${block.text}");
    return ListTile(
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              'Confidence: ${(block.confidence * 100).toStringAsPrecision(4)}%'),
          Text('Lines: ${block.lines.toString()}'),
          Text('Recognized Languages: ${block.recognizedLanguages.toString()}'),
        ],
      ),
      title: Text("${block.text}"),
    );
  }
}
