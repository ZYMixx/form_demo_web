import 'dart:convert';

import 'package:form_demo_web/data/services/service_shared_preferences.dart';

class ServiceHistory {
  static const specificationSharedKey = "specification_history";
  static List<List<Map<String, dynamic>>> listSpecifHistory = [];

  static addInSpecificationHistory(List<Map<String, dynamic>> dataMap) {
    if (listSpecifHistory.isEmpty) {
      listSpecifHistory.addAll(getSpecificationHistory() ?? []);
    }
    listSpecifHistory.add(dataMap);
    if (listSpecifHistory.length > 20) {
      listSpecifHistory = listSpecifHistory.getRange(1, 20).toList();
    }
    ServiceSharedPreferences.putString(
        key: specificationSharedKey, stringData: jsonEncode(listSpecifHistory));
  }

  static resetSpecificationHistory() {
    listSpecifHistory = [];
    ServiceSharedPreferences.resetKey(key: specificationSharedKey);
  }

  static List<List<Map<String, dynamic>>> getSpecificationHistory() {
    /// для наглядности Демо-версии предустановлена история
    String fakeHistory =
        '[[{"id":5,"width":250,"second_width":0,"clipki":20,"fullName":"Щит линейный 0.25 x 3.5 ","dateTime":"23-11-07 13:21","count":12},{"id":307,"width":250,"second_width":350,"clipki":21,"fullName":"Щит шарнирный 0.25 x 0.35 x 3.5 ","dateTime":"23-11-07 13:21","count":7}],[{"id":5,"width":250,"second_width":0,"clipki":20,"fullName":"Щит линейный 0.25 x 3.5 ","dateTime":"23-11-07 13:22","count":9}]]';
    List<dynamic> listResults = List<dynamic>.from(jsonDecode(fakeHistory));
    List<List<Map<String, dynamic>>> testList = [];
    for (var results in listResults) {
      List<Map<String, dynamic>> listMap =
          (results as List<dynamic>).map((element) => Map<String, dynamic>.from(element)).toList();
      testList.add(listMap);
    }
    return testList;
  }
}
