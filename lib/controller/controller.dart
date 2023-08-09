import 'dart:convert' as convert;

import 'package:http/http.dart' as http;

import '../model/form.dart';


class FormController {
  // Callback function to give response of status of current request.
  final void Function(String) callback;
  // Google App Script Web URL
  static const String URL = "https://script.google.com/macros/s/AKfycbwTT_K8ZQuSVVZooasrHqd0mBj3sP41ZGNto6LTePUTiL4O-b87kb4qRjGCVoFcEpI/exec";

  static const STATUS_SUCCESS = "SUCCESS";

  FormController(this.callback);

  void submitForm(UserForm userForm) async{
    try{
      await http.get(Uri.parse(URL + userForm.toParams()) ).then(
          (response){
            callback(convert.jsonDecode(response.body)['status']);
          });
    } catch(e){
      print(e);
    }
  }
}