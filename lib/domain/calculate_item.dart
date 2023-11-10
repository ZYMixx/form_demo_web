class CalculateShieldItem {
  final String name;
  String shieldFullName;

  String get title => replaceTitleValue();
  double cost;
  List<double> secondaryData = [];

  CalculateShieldItem({
    required this.cost,
    required this.name,
    List<double>? secondUsrData,
    required this.shieldFullName,
  }) {
    if (secondUsrData != null) {
      for (var item in secondUsrData) {
        secondaryData.add(item);
      }
    }
  }

  @override
  String toString() {
    return 'CalculateItem{name: $name, cost: $cost secondaryData: $secondaryData}';
  }

  String replaceTitleValue() {
    String title = '';
    String changeTitle = '';
    for (var i = 0; i < secondaryData.length; i++) {
      changeTitle = title.isEmpty ? name : title;
      var strNumber = secondaryData[i].toString().replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "");
      title = changeTitle.replaceAll("%value_$i", strNumber);
    }
    return title.isEmpty ? name : title;
  }
}
