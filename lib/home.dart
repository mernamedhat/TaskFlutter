import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:blinkid_flutter/microblink_scanner.dart';
import 'package:blinkid_flutter/overlays/blinkid_overlays.dart';
import 'package:blinkid_flutter/recognizers/blink_id_combined_recognizer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'Components/costumAlert.dart';
import 'ReadID/UAEIDProvider/uaeIDProvider.dart';
import 'controller.dart';
import 'form.dart';

import 'package:http/http.dart' as http;


import 'package:googleapis/drive/v3.dart' as drive;
import 'package:google_sign_in/google_sign_in.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool isScan = false;

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController landlineController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController nationalIdController = TextEditingController();





  void saveBase64ToDrive(String fileName, List<int> bytes) async {


    final googleSignIn = GoogleSignIn(scopes: ['https://www.googleapis.com/auth/drive.file']);
    final account = await googleSignIn.signIn();

    final authHeaders = await account?.authHeaders;
    final driveApi = drive.DriveApi(authHeaders as http.Client);
    final media = drive.Media(Stream.fromIterable(bytes as Iterable<List<int>>), bytes.length);
    final file = drive.File()
      ..name = fileName
      ..parents = ['parent-folder-id'];

    await driveApi.files.create(file, uploadMedia: media);

  }
  // newypdate
  Future<void> scan() async {
    String license;
    // Set the license key depending on the target platform you are building for.
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      license = "";
    } else if (Theme.of(context).platform == TargetPlatform.android) {
      license =
          "sRwAAAAcY29tLnRhc2tmbHV0dGVyLnRhc2tfZmx1dHRlcmJfqz3N4E3f1yNkxw9Q0gF+mGmWqIWxN9UcN2p4mtDK7gx/jhbh7RZND6AR4feNOCTjKo2av7Ekz+03U+4Y1z+CK42GT+FivzpFdORgLyXASF8ZhasyVnrVh90ysIqXpSspL1GFCdW1SSBZ3i58PpM+WZwZDVqgwEh6/A1FWhG7m3pLo3Fg8QDQOl1wJab5SKYMGyD9EXmmuyHhXYd0UyNk+sjWk1/N/dQ=";
    } else {
      license =
          "sRwAAAAcY29tLnRhc2tmbHV0dGVyLnRhc2tfZmx1dHRlcmJfqz3N4E3f1yNkxw9Q0gF+mGmWqIWxN9UcN2p4mtDK7gx/jhbh7RZND6AR4feNOCTjKo2av7Ekz+03U+4Y1z+CK42GT+FivzpFdORgLyXASF8ZhasyVnrVh90ysIqXpSspL1GFCdW1SSBZ3i58PpM+WZwZDVqgwEh6/A1FWhG7m3pLo3Fg8QDQOl1wJab5SKYMGyD9EXmmuyHhXYd0UyNk+sjWk1/N/dQ=";
    }

    var idRecognizer = BlinkIdCombinedRecognizer();
    idRecognizer.returnFullDocumentImage = true;
    idRecognizer.returnFaceImage = true;
    idRecognizer.returnSignatureImage = true;

    BlinkIdOverlaySettings settings = BlinkIdOverlaySettings();

    var results = await MicroblinkScanner.scanWithCamera(
        RecognizerCollection([idRecognizer]), settings, license);

    if (!mounted) {
      return;
    }
    // When the scan is cancelled, the result is null therefore we return to the the main screen.
    if (results.isEmpty) {
      return;
    }
    //When the result is not null, we check if it is a passport then obtain the details using the `getPassportDetails` method and display them in the UI. If the document type is a national id, we get the details using the `getIdDetails` method and display them in the UI.
    for (var result in results) {
      if (result is BlinkIdCombinedRecognizerResult) {
        if (result.mrzResult?.documentType == MrtdDocumentType.Passport) {
          //UAEIdProvider.resultString = getPassportResultString(result);
          return;
        } else {
          UAEIdProvider.resultString = getIdResultString(result);
        }

        setState(() {
          UAEIdProvider.resultString = UAEIdProvider.resultString;
          UAEIdProvider.fullDocumentFrontImageBase64 =
              result.fullDocumentFrontImage ?? "";
          UAEIdProvider.fullDocumentBackImageBase64 =
              result.fullDocumentBackImage ?? "";
          UAEIdProvider.faceImageBase64 = result.faceImage ?? "";
          UAEIdProvider.signatureImageBase64 = result.signatureImage ?? "";
          nationalIdController = TextEditingController(
              text: UAEIdProvider.resultString?['Personal Id Number']);
        });

        isScan = true;
        UAEIdProvider.successResult = Future<bool>.value(true);
        return;
      }
    }
  }

  Map<String, dynamic> getIdResultString(
      BlinkIdCombinedRecognizerResult result) {
    // The information below will be otained from the natioal id if they are available.
    // In the case a field is not found, then it is skipped. For example, some national ids do not have the profession field.

    return {
      "Full name": result.fullName != ''
          ? buildResult(result.fullName)
          : result.mrzResult!.mrzVerified!
              ? buildResult(result.mrzResult!.primaryId)
              : buildResult(result.lastName),
      "Document number": result.documentNumber != ''
          ? buildResult(result.documentNumber)
          : result.mrzResult!.mrzVerified!
              ? buildResult(result.mrzResult!.documentNumber)
              : '',
      "Sex": result.sex != ''
          ? buildResult(result.sex)
          : result.mrzResult!.mrzVerified!
              ? buildResult(result.mrzResult!.gender)
              : '',
      "Nationality": result.nationality != ''
          ? buildResult(result.nationality)
          : result.mrzResult!.mrzVerified!
              ? buildResult(result.mrzResult!.nationality)
              : '',
      "Date of birth": buildDateResult(result.dateOfBirth),
      "Age": buildIntResult(result.age),
      "Date of expiry": buildDateResult(result.dateOfExpiry),
      "Date of expiry permanent":
          buildResult(result.dateOfExpiryPermanent.toString()),
      "Personal Id Number": result.personalIdNumber != ''
          ? buildResult(result.personalIdNumber)
          : result.mrzResult!.mrzVerified!
              ? buildResult(result.mrzResult!.opt1)
              : '',
      "Text": result.mrzResult!.mrzVerified! ? result.mrzResult!.mrzText : '',
    };
  }

  String buildResult(String? result) {
    if (result == null || result.isEmpty) {
      return "";
    }
    return result.replaceAll('\n', ' ');
  }

  String buildDateResult(Date? result) {
    if (result == null || result.year == 0) {
      return "";
    }
    return buildResult("${result.day}.${result.month}.${result.year}");
  }

  String buildIntResult(int? result) {
    if (result == null || result < 0) {
      return "";
    }
    return buildResult(result.toString());
  }

  Future<void> submitData() async {

    saveBase64ToDrive("merna",Base64Decoder().convert(UAEIdProvider.fullDocumentFrontImageBase64),);
    if (_formKey.currentState!.validate()) {
      UserForm userForm = UserForm(
        firstNameController.text,
        lastNameController.text,
        addressController.text,
        areaController.text,
        landlineController.text,
        mobileController.text,
        nationalIdController.text,
        mobileController.text,
        nationalIdController.text,
      );

      FormController formController = FormController((String response) {
        print("Response: $response");
        if (response == FormController.STATUS_SUCCESS) {
          //
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              "Feedback Submitted",
              textAlign: TextAlign.center,
            ),
            // backgroundColor: Colors.teal,
            behavior: SnackBarBehavior.floating,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(50),
              ),
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 10,
            ),

            width: 200,
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              "Feedback Submitteddd",
              textAlign: TextAlign.center,
            ),
            // backgroundColor: Colors.teal,
            behavior: SnackBarBehavior.floating,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(50),
              ),
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 10,
            ),

            width: 200,
          ));
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Submitting Feedback",
          textAlign: TextAlign.center,
        ),
        // backgroundColor: Colors.teal,
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(50),
          ),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 10,
        ),

        width: 200,
      ));

      // Submit 'feedbackForm' and save it in Google Sheet

      formController.submitForm(userForm);
    }
  }

  String dropdownValue = 'Zamalek';

//newypdate
  @override
  Widget build(BuildContext context) {
    Uint8List bytes = base64.decode(UAEIdProvider.fullDocumentFrontImageBase64);
    print("merna");
    print(bytes);
    print("merna");
    print(UAEIdProvider.fullDocumentFrontImageBase64 != null);

    print(UAEIdProvider.fullDocumentFrontImageBase64.toString());
    print(UAEIdProvider.fullDocumentBackImageBase64.toString());
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('ID Scanner'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Basic Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                TextField(
                  keyboardType: TextInputType.name,
                  controller: firstNameController,

                  decoration: InputDecoration(labelText: 'First Name'),
                ),
                TextField(
                  keyboardType: TextInputType.name,
                  controller: lastNameController,
                  decoration: InputDecoration(labelText: 'Last Name'),
                ),
                TextField(
                  keyboardType: TextInputType.streetAddress,
                  controller: addressController,
                  decoration: InputDecoration(labelText: 'Address'),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 18.0),
                  child: Text(
                    'Area',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey),
                  ),
                ),
                DropdownButton<String>(
                  value: dropdownValue,
                  items: <String>[
                    'Zamalek',
                    'Maadi',
                    'Downtown',
                    'Pyramids',
                    'New Cairo'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(fontSize: 18),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                      newValue!=""?
                      areaController.text = newValue:areaController.text=dropdownValue;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.phone,
                  controller: landlineController,
                  decoration: InputDecoration(labelText: 'Landline'),
                ),
                TextField(
                  keyboardType: TextInputType.phone,
                  controller: mobileController,
                  decoration: InputDecoration(labelText: 'Mobile'),
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  maxLength: 13,
                  controller: nationalIdController,
                  decoration: InputDecoration(labelText: 'National ID'),
                ),
                SizedBox(height: 16),
                Text(
                  'Scan ID Card',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async => {
                    await scan(),
                    if (!isScan)
                      {
                        showDialog(
                          barrierColor: Colors.black26,
                          context: context,
                          builder: (context) {
                            return CustomAlertDialog(
                              title: "Scan Error",
                              description:
                                  "The identity has not been properly identified",
                            );
                          },
                        )
                      }
                  },
                  // scanFrontID,
                  child: Text('Scan ID'),
                ),
                SizedBox(height: 16),
                Center(
                  child: Column(
                    children: [
                      UAEIdProvider.fullDocumentFrontImageBase64 == ""
                          ? Container()
                          : Image.memory(
                              const Base64Decoder().convert(
                                  UAEIdProvider.fullDocumentFrontImageBase64),
                            ),
                      UAEIdProvider.fullDocumentBackImageBase64 == ""
                          ? Container()
                          : Image.memory(
                              const Base64Decoder().convert(
                                  UAEIdProvider.fullDocumentBackImageBase64),
                            ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: submitData,
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
