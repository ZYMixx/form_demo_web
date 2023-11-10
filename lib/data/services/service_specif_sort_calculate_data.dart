import 'package:form_demo_web/data/services/service_sort_calculate_data.dart';

class ServiceSpecifSortCalculateData extends ServiceSortCalculateData {
  ServiceSpecifSortCalculateData(super.shieldData, this.itemCount);

  int itemCount;

  @override
  double round(nomber) {
    double roundSumma = super.round(nomber) * itemCount;
    return super.round(roundSumma);
  }

  static List<double> createUnitedTitle(List<List<double>> listOfList) {
    int length = listOfList[0].length;
    List<double> unitedList = [];
    double sum = 0;
    for (int j = 0; j < length; j++) {
      for (int k = 0; k < listOfList.length; k++) {
        sum += listOfList[k][j];
      }
      unitedList.add(double.parse(sum.toStringAsFixed(2)));
      sum = 0;
    }
    return unitedList;
  }

  static String replaceTitleValue(String name, List<double> list) {
    String title = '';
    String changeTitle = '';
    for (var i = 0; i < list.length; i++) {
      changeTitle = title.isEmpty ? name : title;
      var strNumber = list[i].toString().replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "");
      title = changeTitle.replaceAll("%value_$i", strNumber);
    }
    return title.isEmpty ? name : title;
  }
}
