import 'package:flutter/cupertino.dart';

class TextValidator {
  TextValidator(this.context);

  final BuildContext context;

  String? call(String value) {

    if(value.isEmpty) {
      return "This field cannot be empty";
    }
    return null;
  }
}