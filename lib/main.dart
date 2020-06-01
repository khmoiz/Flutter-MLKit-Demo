import 'dart:async';
import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:firebasemlkitdemo/picture_preview.dart';
import 'package:firebasemlkitdemo/scanner_type.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase MLKit Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: MyHomePage(title: 'Firebase MLKit Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState();

  ScannerType _currentType = ScannerType.BarcodeDetector;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
//      floatingActionButton:
//          FloatingActionButton(child: const Icon(Icons.tab), onPressed: () {}),
      body: Center(
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 150,
                height: 150,
                child: Center(
                  child: Image.network(
                    "https://cdn4.iconfinder.com/data/icons/google-i-o-2016/512/google_firebase-2-512.png",
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              Container(
                child: Text(
                  'If data cannot be read from captured image then try uploading from device gallery. As sometimes pictures of monitors can be pixelated. (ie. for Barcode & QR)',
                  textAlign: TextAlign.center,
                ),
                margin: EdgeInsets.all(8),
                padding: EdgeInsets.all(8),
              ),
              Container(
                child: radioButtonOptions(),
                margin: EdgeInsets.all(8),
                padding: EdgeInsets.all(8),
              ),
              Container(
                child: Text('${_currentType.toString()}'),
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.all(8),
              ),
              RaisedButton(
                child: Text('Take a Picture'),
                onPressed: () {
                  _captureImageEvent();
                },
              ),
              RaisedButton(
                child: Text('Select from Gallery'),
                onPressed: () {
                  _selectImageEvent();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectImageEvent() async {
    try {
      final imageFile =
          await ImagePicker.pickImage(source: ImageSource.gallery);

      if (imageFile == null) {
        throw Exception("File is not available");
      }

      Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => PicturePreview(imageFile, _currentType)),
      );
    } catch (e) {
      print("$e");
    }
  }

  Future<void> _captureImageEvent() async {
    try {
      final imageFile = await ImagePicker.pickImage(source: ImageSource.camera);

      if (imageFile == null) {
        throw Exception("File is not available");
      }

      Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => PicturePreview(imageFile, _currentType)),
      );
    } catch (e) {
      print("$e");
    }
  }

  radioButtonOptions() {
    return Column(
      children: [
        ListTile(
          title: const Text('Barcode & QR Detector'),
          leading: Radio(
            value: ScannerType.BarcodeDetector,
            groupValue: _currentType,
            onChanged: (ScannerType value) {
              setState(() {
                _currentType = value;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Image Labels Detector'),
          leading: Radio(
            value: ScannerType.ImageLabeler,
            groupValue: _currentType,
            onChanged: (ScannerType value) {
              setState(() {
                _currentType = value;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Faces & Smiles Detector'),
          leading: Radio(
            value: ScannerType.FaceDetector,
            groupValue: _currentType,
            onChanged: (ScannerType value) {
              setState(() {
                _currentType = value;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('OCR Text Recognizer'),
          leading: Radio(
            value: ScannerType.TextRecognizer,
            groupValue: _currentType,
            onChanged: (ScannerType value) {
              setState(() {
                _currentType = value;
              });
            },
          ),
        )
      ],
    );
  }
}
