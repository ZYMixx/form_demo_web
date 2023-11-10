import 'package:flutter/material.dart';
import 'package:form_demo_web/data/services/service_specif_sort_calculate_data.dart';
import 'package:form_demo_web/data/tools/tool_key_value_entry.dart';
import 'package:form_demo_web/presentation/specification_screen/calculate_specification_screen.dart';
import 'package:form_demo_web/presentation/view_models/abstract_work_view_model.dart';

class ResultSpecifCalculateViewModel extends AbstractWorkViewModel with CopyableDataInterface {
  final List<ServiceSpecifSortCalculateData> listCalculateData;

  ResultSpecifCalculateViewModel({required this.listCalculateData}) {}

  static int calculateTry = 0;
  List<Map<String, double>> copyResultListMap = [];
  Set<String> titleSet = {};
  bool? isOrdered;

  List<List<String>>? copyList;

  List<ShowDataItem> orderWidgetList({required List<ShowDataItem> widgetList}) {
    if (isOrdered == null) {
      return widgetList;
    } else if (isOrdered!) {
      widgetList.sort((a, b) => a.cost.compareTo(b.cost));
      return widgetList;
    } else {
      widgetList.sort((a, b) => b.cost.compareTo(a.cost));
      return widgetList;
    }
  }

  orderDataList() {
    copyList = null;
    isOrdered != null ? isOrdered = !isOrdered! : isOrdered = false;
    notifyListeners();
  }

  setCopyResultMap({required Map<String, double> copyResultMap}) {
    copyResultListMap.add(copyResultMap);
    titleSet.add(copyResultMap.keys.first);
  }

  clearCopyDataMap() {
    copyResultListMap = [];
  }

  @override
  String get name => 'Результат';

  @override
  bool get isSingleWidgetScreen => true;

  @override
  Widget buildDefaultLeftWidget() {
    return const Text("TEST 1 ");
  }

  @override
  Widget buildDefaultRightWidget() {
    return const Text("TEST 2");
  }

  @override
  void selfDispose() {
    dispose();
  }

  @override
  Widget buildDefaultSingleWidget() {
    return CalculateSpecificationScreen(resultViewModel: this, key: UniqueKey());
  }

  @override
  List<List<String>>? getCopyableDataList() {
    if (copyList == null) {
      copyList = [];
      var listOfListToolKey = ToolKeyValueEntry.getListFromListMap(copyResultListMap);
      if (isOrdered != null) {
        for (var toolList in listOfListToolKey) {
          if (isOrdered!) {
            toolList.sort((a, b) => a.value.compareTo(b.value));
          } else {
            toolList.sort((a, b) => b.value.compareTo(a.value));
          }
          for (var title in titleSet) {
            var elements = toolList.where((element) => element.key == title);
            if (elements.isNotEmpty) {
              var element = toolList.where((element) => element.key == title).first.copyWith();
              toolList.removeWhere((tool) => tool.key == element.key);
              toolList.insert(0, element);
              continue;
            }
          }
        }
      }
      for (var list in listOfListToolKey) {
        for (var item in list) {
          copyList?.add(['${item.key}', '${item.value}']);
        }
      }
      return copyList;
    }
    return copyList;
  }

  @override
  List<String>? getCopyableTitleList() {
    return ['Калькуляция', 'Стоимость/руб'];
  }
}
