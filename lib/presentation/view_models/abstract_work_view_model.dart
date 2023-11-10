import 'package:flutter/material.dart';
import 'package:form_demo_web/data/tools/tool_widget.dart';

abstract class AbstractWorkViewModel extends ChangeNotifier {
  Widget get leftWidget => _leftWidget ??= buildDefaultLeftWidget();

  Widget get rightWidget => _rightWidget ??= buildDefaultRightWidget();

  Widget get singleWidget => _singleWidget ??= buildDefaultSingleWidget();
  Widget? _leftWidget;
  Widget? _rightWidget;
  Widget? _singleWidget;
  bool isSingleWidgetScreen = false;

  String get name;

  Widget buildDefaultRightWidget() {
    return ToolWidget.noDataTextWidget;
  }

  Widget buildDefaultLeftWidget() {
    return ToolWidget.noDataTextWidget;
  }

  Widget buildDefaultSingleWidget() {
    return ToolWidget.noDataTextWidget;
  }

  void selfDispose();

  @override
  void dispose() {}
}

abstract class CopyableDataInterface {
  List<String>? getCopyableTitleList();

  List<List<String>>? getCopyableDataList();
}
