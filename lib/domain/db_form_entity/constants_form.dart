import 'package:mysql1/mysql1.dart';

import 'db_entity_form_abstr.dart';

class ConstantsForm extends BdFormEntityAbstr {
  static const String tableName = "constants";

  int id;
  String? key;
  String? subKey;
  String? value; // имя (линейный)
  String? value2; //количество широт (влияет на балки 2/4)
  double? value3;
  String? value4;
  double? value5;

  ConstantsForm(ResultRow row)
      : id = row.fields["id"],
        key = row.fields["key"],
        subKey = row.fields["subKey"],
        value = row.fields["value"],
        value2 = row.fields["value2"],
        value3 = (row.fields["value3"] != null) ? double.parse(row.fields["value3"]) : null,
        value4 = row.fields["value4"],
        value5 = (row.fields["value5"] != null) ? double.parse(row.fields["value5"]) : null;

  @override
  String toString() {
    return 'ConstantsForm{key: $key, subKey: $subKey, value: $value, value2: $value2} \n';
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'key': this.key,
      'subKey': this.subKey,
      'name': this.value,
      'value': this.value,
      'value2': this.value2,
      'value3': this.value3,
      'value4': this.value4,
      'value5': this.value5,
    };
  }
}

// constants
// +--------+--------------+------+-----+---------+----------------+
// | Field  | Type         | Null | Key | Default | Extra          |
// +--------+--------------+------+-----+---------+----------------+
// | id     | int(11)      | NO   | PRI | NULL    | auto_increment |
// | key    | varchar(255) | YES  |     | NULL    |                |
// | subKey | varchar(255) | YES  |     | NULL    |                |
// | value  | varchar(255) | YES  |     | NULL    |                |
// | value2 | varchar(255) | YES  |     | NULL    |                |
// | value3 | varchar(255) | YES  |     | NULL    |                |
// | value4 | varchar(255) | YES  |     | NULL    |                |
// | value5 | varchar(255) | YES  |     | NULL    |                |
// +--------+--------------+------+-----+---------+----------------+
