import 'package:flutter/cupertino.dart';

class EmailValidator {
  EmailValidator(this.context);

  final BuildContext context;

  String? call(String value) {
    bool isValid = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,}$',).hasMatch(value);

    if(value.isEmpty) {
      return "This field cannot be empty";
    } else if(!isValid) {
      return "Invalid Email";
    }
    return null;
  }
}