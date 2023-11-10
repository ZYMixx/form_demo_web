import 'package:mysql1/mysql1.dart';

import 'db_entity_form_abstr.dart';

class ClepkiForm extends BdFormEntityAbstr {
  int id;
  String? tip;
  int? h;
  int? w;
  int? count;

  static const String tableName = "clepki";

  ClepkiForm(ResultRow row)
      : id = row.fields["id"],
        tip = row.fields["tip"],
        h = row.fields["h"],
        w = row.fields["w"],
        count = row.fields["count"];

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'tip': this.tip,
      'h': this.h,
      'w': this.w,
      'count': this.count,
    };
  }
}

// +-------+--------------+------+-----+---------+----------------+
// | Field | Type         | Null | Key | Default | Extra          |
// +-------+--------------+------+-----+---------+----------------+
// | id    | int(11)      | NO   | PRI | NULL    | auto_increment |
// | tip   | varchar(255) | YES  |     | NULL    |                |
// | h     | int(11)      | YES  |     | NULL    |                |
// | w     | int(11)      | YES  |     | NULL    |                |
// | count | int(11)      | YES  |     | NULL    |                |
// +-------+--------------+------+-----+---------+----------------+
