import 'package:flutter/cupertino.dart';

class PasswordValidator {
  PasswordValidator(this.context, this.confirm);

  final BuildContext context;
  final bool confirm;

  String? call(String value, String? confirmValue) {
    const emptyField = "This field cannot be empty";
    const minPassword = "Password must be 6 or more characters";

    if (confirm) {
      if(value.isEmpty) {
        return emptyField;
      } else if(value.length < 6) {
        return minPassword;
      } else if(value != confirmValue) {
        return "Passwords must match";
      }
    } else if(value.isEmpty) {
      return emptyField;
    } else if(value.length < 6) {
      return minPassword;
    }
    return null;
  }
}