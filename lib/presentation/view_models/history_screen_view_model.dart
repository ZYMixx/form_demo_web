import 'package:flutter/cupertino.dart';
import 'package:form_demo_web/data/services/service_history.dart';
import 'package:form_demo_web/data/tools/tool_show_toast.dart';
import 'package:form_demo_web/presentation/launch_screen.dart';
import 'package:form_demo_web/presentation/view_models/specification_view_model.dart';

class HistoryScreenViewModel extends ChangeNotifier {
  static HistoryScreenViewModel get instance => _instance ??= HistoryScreenViewModel();
  static HistoryScreenViewModel? _instance;

  List<HistoryScreenItemData> listHistoryItemData = [];

  HistoryScreenViewModel() {
    if (_instance != null) {
      throw ("pls dont create second HistoryScreenViewModel, use instance");
    }
  }

  loadData() {
    listHistoryItemData = [];
    List<List<Map<String, dynamic>>>? data = ServiceHistory.getSpecificationHistory();
    if (data != null) {
      for (var listMap in data) {
        try {
          listHistoryItemData.add(HistoryScreenItemData(listMap: listMap));
        } catch (e) {
          ToolShowToast.showError(e.toString());
        }
      }
    }
  }

  pushHistoryScreen(List<Map<String, dynamic>> listMap) async {
    SpecificationViewModel.instance.resetSpecificationData();
    await SpecificationViewModel.instance.loadFromHistory(listMap);
    TableBlock.changeScreenButton(EnumSingleViewModel.specification);
  }

  removeAllHistoryData() {
    ServiceHistory.resetSpecificationHistory();
  }

  @override
  void dispose() {
    _instance = null;
    listHistoryItemData = [];
    super.dispose();
  }
}

class HistoryScreenItemData {
  List<String> listTitle;
  String dataTime;
  int shieldCount;
  List<Map<String, dynamic>> listMap;

  HistoryScreenItemData({required this.listMap})
      : listTitle = _parseListTitle(listMap),
        shieldCount = _parseShieldCount(listMap),
        dataTime = listMap.first['dateTime'];

  static List<String> _parseListTitle(List<Map<String, dynamic>> list) {
    List<String> titles = [];
    for (var map in list) {
      titles.add(map['fullName']);
    }
    return titles;
  }

  static int _parseShieldCount(List<Map<String, dynamic>> list) {
    int sum = 0;
    for (var map in list) {
      sum = map['count'] + sum;
    }
    return sum;
  }
}
