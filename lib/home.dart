import 'dart:convert';

import 'package:blinkid_flutter/microblink_scanner.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';

import 'Components/costumAlert.dart';

import 'ReadID/UAEIDProvider/uaeIDProvider.dart';
import 'controller.dart';
import 'form.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:googleapis/drive/v3.dart' as drive;

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

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp();
  }

  var email = "taskflutter@taskflutter-392707.iam.gserviceaccount.com";
  var clientId = "AIzaSyApFxW-Q7Nao3fc_r2r2bCp7cajnlkyE6s";
  var privateKey = "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDPeE7CaVIMFwGx\nyjpLjIVjPUdS/MweBDFqF0M54bDkQPZKyZH/ej+lmKzVYaqj9OKtBJ6LQ7Zw3Fwj\nChGpdGw0HnmgDFk3yEOut8547J4MAgAxJU7zB0cl9N9ZuYmCmVGnocmOBIG5M+jc\nLF77JD19x3acKmpH6Wxb/k5PlM5LkOiliPTtj7swXxW+xQjUTqee9ZW29RrrGFe+\n+zSi5f4IMBkIS/IpiQ96bzSrQ4yYABrRBZugEZgalVJOXTRnwgZvyBMQWaXd/dmG\n0dk1CB9xstvtTHasuPym7CZ9m0TJ/fWmVL1ZQSqoa/nc12DzeMLPGRJZD0QBESlc\nmI6rb9GXAgMBAAECggEAFeYPfiLKx77n7WG4nH/VFoAB1scbLnHn21hgPqxNVRJs\nTMGQ+QPo0uxWFeHMtqijAnsx1uZLTAdebE5kRdwljazHzrZu9l3bkwYQs5/aIM9X\nQNi8yBc1EdMSfjCAzLmtLkH7+dMM9ET/57mBPwX4vZ1/rgUmGbgQOXeSwYCl88DD\nqYqg3iGYtIUlGhobd+jKhzh07B/wHAsOcQ/0k2tl3hI6hxZ2ENtFWAxX/ncsDUzY\nEx32Aq42yiIhHwefBbQw4K7p6uHMiW+1gJS8cgPuM3/n9znGM1g/Ywv2wzZSebnK\nPpbBvTdfxLlZOHzKGL2qz7HyX9XRifw8XMVzEYm8sQKBgQD0Wyx5XyANaTkvBaQ/\nsu66b6sZQQ3WmBkHtElPfzhIgPpFob5BVaHJdlprq0VOkbilqUSHjpcGDpPwj6f+\nsdE5B9Iawhzbb7T62OvthUAWaimWJjxxC5tex25h2eKAQoywSThMgwj81rk/i1CW\nGMCjjtlBo/ocwTBwlpugQZ6wsQKBgQDZWyuiz9R5nIVW3ZKjDIejUTDCt2l4LCuT\nBWgYycBGuoSJik2f+j/TQxkhycoUViU2NPIzhP1bPorRjrfyShL50eJe5fErMmpw\nIHu59SgeEiKKcLcKO36pGAtdwH30p9nt9M4e3bDXwR1LD6vQvMnwdcCxDjCUofmK\nfsFfnrn4xwKBgQCvzbTmscDOxUimAwoT5jmJmvPfnIVHQnCnsVcZQe+NgnYNiPvn\n56MZ3fPaCQQ5LfBKB8lNOhKAAhb/+WslfGuJ+413QPcgDXOJEm5Tmg3s0n6PD31m\n27Hx88v/zJIAM2EjJ9rAeXoK5rWq+SGGi9J1Gj5G0qIM9BVUu5bGKs/wUQKBgQDW\nN/vev/SKUxA7l68hEYVRGgDzt660KNxdT1PUMmtVihh8MhnlVM+42IWZfnay6mBM\nd4xJ6IWHezF37bAvlH/1Rb1UiE3TpCGxFuK6WPvL/1WZmhNce1yPLUpugPvit9ea\npc7MLvRPAF5tjyloVdi1LGjYV8LbinQV4m2VXyutGwKBgGqOk59ZnRr4fI+O4UjJ\n65nNKtn5iPoDjrLfqo933/282eWCgNNWfEQGRPp5lk+sxUVBFYLNyqNIM3z1RUKF\nXJMs68nthqMUWGMPvcNI+lCZin05BVbTKYJx9tdkFhC34gOfkScHtyWYMnW+og4H\nEE9c9pNC2h44FIMy9hogO9mm\n-----END PRIVATE KEY-----\n";

  Future<String?> uploadBase64ImageToDrive(String base64Image) async {
    try {
      var credentials = await auth.clientViaServiceAccount(
        auth.ServiceAccountCredentials(
          email,
          auth.ClientId(clientId, null),
          privateKey,
        ),


        [
          'https://www.googleapis.com/auth/drive',
        ],
      );
      var client = drive.DriveApi(credentials);

      // Create a new file
      var newFile = drive.File()
        ..name = 'image.png'
        ..parents = ['19WT54oYrXjXyraZ74Zk1pi866btM9P09'];

      // Convert the base64 image to bytes
      var bytes = base64.decode(base64Image);

      // Upload the file to Google Drive
      var media = drive.Media(Stream.fromIterable([bytes]), bytes.length);
      var file = await client.files.create(newFile, uploadMedia: media);

      // Get the link to the file
      var link = 'https://drive.google.com/file/d/${file.id}/view';
      print(link);
      return link;
    } catch (e) {
      print('Error uploading image to Google Drive: $e');
      return null;
    }
  }


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
    //uploadBase64ImageToDrive(UAEIdProvider.fullDocumentFrontImageBase64);
    if (_formKey.currentState!.validate()) {
      UserForm userForm = UserForm(
        firstNameController.text,
        lastNameController.text,
        addressController.text,
        areaController.text,
        landlineController.text,
        mobileController.text,
        nationalIdController.text,
        "https://drive.google.com/file/d/1rGOsfME7Yr2zpjeNf71eIRBQhcBBgG8T/view",
        uploadBase64ImageToDrive(UAEIdProvider.fullDocumentBackImageBase64) as String,
      );

      FormController formController = FormController((String response) {
        print("Response: $response");
        if (response == FormController.STATUS_SUCCESS) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
              "Feedback Submitted",
              textAlign: TextAlign.center,
            ),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(50),
              ),
            ),
            padding: EdgeInsets.symmetric(
              vertical: 10,
            ),
            width: 200,
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
              "Feedback Submitteddd",
              textAlign: TextAlign.center,
            ),
            // backgroundColor: Colors.teal,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(50),
              ),
            ),
            padding: EdgeInsets.symmetric(
              vertical: 10,
            ),

            width: 200,
          ));
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Submitting Feedback",
          textAlign: TextAlign.center,
        ),
        // backgroundColor: Colors.teal,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(50),
          ),
        ),
        padding: EdgeInsets.symmetric(
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
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('ID Scanner'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Basic Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextField(
                  keyboardType: TextInputType.name,
                  controller: firstNameController,
                  decoration: const InputDecoration(labelText: 'First Name'),
                ),
                TextField(
                  keyboardType: TextInputType.name,
                  controller: lastNameController,
                  decoration: const InputDecoration(labelText: 'Last Name'),
                ),
                TextField(
                  keyboardType: TextInputType.streetAddress,
                  controller: addressController,
                  decoration: const InputDecoration(labelText: 'Address'),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 18.0),
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
                        style: const TextStyle(fontSize: 18),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                      newValue != ""
                          ? areaController.text = newValue
                          : areaController.text = dropdownValue;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.phone,
                  controller: landlineController,
                  decoration: const InputDecoration(labelText: 'Landline'),
                ),
                TextField(
                  keyboardType: TextInputType.phone,
                  controller: mobileController,
                  decoration: const InputDecoration(labelText: 'Mobile'),
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  maxLength: 13,
                  controller: nationalIdController,
                  decoration: const InputDecoration(labelText: 'National ID'),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Scan ID Card',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async => {
                    await scan(),
                    if (!isScan)
                      {
                        showDialog(
                          barrierColor: Colors.black26,
                          context: context,
                          builder: (context) {
                            return const CustomAlertDialog(
                              title: "Scan Error",
                              description:
                                  "The identity has not been properly identified",
                            );
                          },
                        )
                      }
                  },
                  // scanFrontID,
                  child: const Text('Scan ID'),
                ),
                const SizedBox(height: 16),
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
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: submitData,
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
