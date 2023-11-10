class ToolKeyValueEntry {
  String key;
  double value;

  ToolKeyValueEntry({required this.key, required this.value});

  static List<List<ToolKeyValueEntry>> getListFromListMap(List<Map<String, double>> listMap) {
    List<List<ToolKeyValueEntry>> listOfList = [];
    for (var map in listMap) {
      List<ToolKeyValueEntry> toolList = [];
      for (var key in map.keys) {
        toolList.add(ToolKeyValueEntry(key: key, value: map[key]!));
      }
      listOfList.add(toolList);
    }
    return listOfList;
  }

  @override
  String toString() {
    return '{$key - $value}\n';
  }

  ToolKeyValueEntry copyWith({
    String? key,
    double? value,
  }) {
    return ToolKeyValueEntry(
      key: key ?? this.key,
      value: value ?? this.value,
    );
  }
}
