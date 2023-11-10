import 'package:mysql1/mysql1.dart';
import 'package:mysql1/src/buffer.dart';

class FakeResultRow extends ResultRow {
  FakeResultRow({
    required Map<String, dynamic> dataMap,
  }) {
    values = List<dynamic>.filled(dataMap.length, null);
    int i = 0;
    for (var key in dataMap.keys) {
      var value = dataMap[key];
      values![i++] = value;
      fields[key] = value;
    }
  }

  FakeResultRow.convert({required ResultRow resultsRow}) : this(dataMap: resultsRow.fields);

  @override
  Object? readField(Field field, Buffer buffer) {
    throw UnimplementedError();
  }
}
