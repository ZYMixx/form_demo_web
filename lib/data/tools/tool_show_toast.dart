import 'package:flutter/material.dart';
import 'package:form_demo_web/data/tools/tool_theme_data.dart';
import 'package:form_demo_web/presentation/App.dart';

class ToolShowToast {
  static void show(String message) {
    ScaffoldMessenger.of(App.navigatorKey.currentContext!).removeCurrentSnackBar();
    ScaffoldMessenger.of(App.navigatorKey.currentContext!).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: ToolThemeDataHolder.defTextDataStyle,
        ),
        backgroundColor: ToolThemeDataHolder.colorMonoPlastGreen.withOpacity(0.95),
        duration: const Duration(seconds: 2),
        elevation: 0,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static void showError(String message) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ScaffoldMessenger.of(App.navigatorKey.currentContext!).removeCurrentSnackBar();

      ScaffoldMessenger.of(App.navigatorKey.currentContext!).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: ToolThemeDataHolder.defTextDataStyle,
          ),
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.redAccent.withOpacity(0.8),
          elevation: 0,
          behavior: SnackBarBehavior.floating,
        ),
      );
    });
  }
}
