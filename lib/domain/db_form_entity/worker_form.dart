import 'package:mysql1/mysql1.dart';

import 'db_entity_form_abstr.dart';

class WorkerForm extends BdFormEntityAbstr {
  static const String tableName = "rabotniki";

  final int id;
  final String familia;

  WorkerForm(ResultRow row)
      : familia = row.fields["Familia"],
        id = row.fields["id"];

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'familia': this.familia,
    };
  }
}

// +---------+-------------+------+-----+---------+----------------+
// | Field   | Type        | Null | Key | Default | Extra          |
// +---------+-------------+------+-----+---------+----------------+
// | Familia | varchar(20) | NO   |     | NULL    |                |
// | id      | int(11)     | NO   | PRI | NULL    | auto_increment |
// +---------+-------------+------+-----+---------+----------------+
