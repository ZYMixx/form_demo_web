import 'package:flutter/material.dart';

class ToolUserInput {
  static bool haveInputError({
    required TextEditingController controller,
    required Type runtimeType,
    bool canBeNull = false,
  }) {
    try {
      if (controller.text.trim() == '' && canBeNull) {
        return false;
      }
      switch (runtimeType) {
        case int:
          if (int.tryParse(controller.text) == null) {
            return true;
          }
          return false;
        case double:
          if (double.tryParse(controller.text) == null) {
            return true;
          }
          return false;
        case String:
          if (controller.text.trim() == '' || controller.text.trim() == 'null') {
            return true;
          }
          return false;
        default:
          print('unnown type ${runtimeType}');
          return true;
      }
    } catch (e) {
      print('Controler Text Has Imput Error - $e');
      return true;
    }
  }
}
