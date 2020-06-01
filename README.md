# firebasemlkitdemo

Flutter MLKit Demo created using FlutterVision  & Camera packages.

## Getting Started

This project is a demo application to showcase how MLVision from Firebase MLKIT works.

Using all scanner types available allowing users:

1) To either take a picture from their camera or upload from gallery
2) Provide it to the MLVision Plugin for procession
3) Navigate the user to the details screen. User is presented with Photo and derived data from the photo.
   ie. Barcode Details, Labels taken from an Image, Face Data from Face Recognition, etc.
   
4) Data points taken from Image( other than Image labler) are outlined with a Red border (barcodes, images, etc).


Packages Used:
(Installed in Order)-
  firebase_core: ^0.4.5
  firebase_analytics: ^5.0.11
  firebase_ml_vision: ^0.9.4
  image_picker: ^0.6.6+4
  camera: ^0.5.2+2
  path_provider: ^1.6.9
