import 'package:form_demo_web/domain/db_form_entity/db_entity_form_abstr.dart';
import 'package:mysql1/mysql1.dart';

class TrenogaSpendForm extends BdFormEntityAbstr {
  int id;
  String name;
  double kgPerMp;
  double lPerEd;

  static const String tableName = "trenoga_spend";

  TrenogaSpendForm(ResultRow row)
      : id = row.fields["id"],
        name = row.fields["name"],
        kgPerMp = row.fields["kg_per_mp"],
        lPerEd = row.fields["l_per_ed"];

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'name': this.name,
      'kg_per_mp': this.kgPerMp,
      'l_per_ed': this.lPerEd,
    };
  }
}

// +-----------+------------------+------+-----+---------+----------------+
// | Field     | Type             | Null | Key | Default | Extra          |
// +-----------+------------------+------+-----+---------+----------------+
// | id        | int(11) unsigned | NO   | PRI | NULL    | auto_increment |
// | name      | varchar(255)     | NO   |     | NULL    |                |
// | kg_per_mp | double           | NO   |     | NULL    |                |
// | l_per_ed  | double           | NO   |     | NULL    |                |
// +-----------+------------------+------+-----+---------+----------------+
