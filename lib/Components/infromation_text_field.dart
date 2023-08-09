import 'package:flutter/material.dart';


class CustomTxtFieldProfile extends StatelessWidget {
  String hintTxt;

  final String? Function(String?)? validator;
  TextInputType txtInputType;
  TextEditingController controller;

  CustomTxtFieldProfile({
    Key? key,
    required this.hintTxt,


    required this.controller,
    this.validator,
    required this.txtInputType ,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height:55,
      child: TextFormField(

        cursorColor: const Color(0xff73090f47),
        style: const TextStyle(fontSize: 15, color: Color(0xff090F47)),
        controller: controller,

        decoration: InputDecoration(
          label:Text(hintTxt) ,
          // hintText: hintTxt,
          hintTextDirection: TextDirection.ltr,

          hintStyle: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Color(0xff090F47)),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xff73090f47)),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xff090F47)),
          ),
        ),
        validator: validator,
        keyboardType: txtInputType,
      ),
    );
  }
}
