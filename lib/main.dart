import 'dart:convert';
import 'dart:io';
import 'package:blinkid_flutter/microblink_scanner.dart';
import 'package:blinkid_flutter/overlays/blinkid_overlays.dart';
import 'package:blinkid_flutter/recognizers/blink_id_combined_recognizer.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'Components/costumAlert.dart';
import 'ReadID/UAEIDProvider/uaeIDProvider.dart';
import 'controller.dart';
import 'form.dart';
import 'home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ID Scanner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

