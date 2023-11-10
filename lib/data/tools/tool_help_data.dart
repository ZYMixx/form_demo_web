import 'dart:core';

import 'package:flutter/material.dart';

class ToolHelpData {
  static final RegExp regExpNumOnly = RegExp(r'[0-9]');
  static final RegExp regExpDouble = RegExp(r'[0-9.]');

  static ValueKey buildComboValueKey(List<dynamic> listData) {
    String valueKeyText = '';
    for (var item in listData) {
      valueKeyText = '$valueKeyText$item-';
    }
    return ValueKey(valueKeyText);
  }

  static String separateThousandString(double value) {
    String formattedValue = value.toStringAsFixed(2); // Округляем до двух десятичных знаков
    final parts = formattedValue.split('.'); // Разделяем целую и десятичную части
    // Форматируем целую часть, добавляя пробелы каждые три символа
    final regex = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    parts[0] = parts[0].replaceAllMapped(regex, (Match match) => '${match[1]} ');
    // Объединяем целую и десятичную части с разделителем '.'
    formattedValue = parts.join('.');
    if (formattedValue[formattedValue.length - 1] == '.') {
      formattedValue = formattedValue.replaceAll('.', '');
      return formattedValue;
    }
    while (formattedValue[formattedValue.length - 1] == '0') {
      formattedValue =
          formattedValue.replaceRange(formattedValue.length - 1, formattedValue.length, '');
      if (formattedValue[formattedValue.length - 1] == '.') {
        formattedValue = formattedValue.replaceAll('.', '');
        return formattedValue;
      }
    }
    return formattedValue;
  }
}
