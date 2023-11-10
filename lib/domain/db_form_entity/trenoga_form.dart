import 'package:form_demo_web/domain/db_form_entity/db_entity_form_abstr.dart';
import 'package:mysql1/mysql1.dart';

class TrenogaForm extends BdFormEntityAbstr {
  int id;
  String name;
  String combName;
  String type;
  String? ed;
  String? trenogaSpendType;
  double? norma;
  double? total;

  TrenogaForm(ResultRow row)
      : id = row.fields["id"],
        name = row.fields["name"],
        combName = (row.fields["trenogaSpendType"] ?? '') + row.fields["name"],
        type = row.fields["type"],
        ed = row.fields["ed"],
        trenogaSpendType = row.fields["trenogaSpendType"],
        total = row.fields["total"],
        norma = row.fields["norma"];

  static const String tableName = "trenoga";

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'name': this.name,
      'combName': this.combName,
      'type': this.type,
      'ed': this.ed,
      'trenogaSpendType': this.trenogaSpendType,
      'norma': this.norma,
      'total': this.total,
    };
  }

  @override
  String toString() {
    return 'TrenogaForm{id: $id, name: $name, combName: $combName, type: $type, ed: $ed, trenogaSpendType: $trenogaSpendType, norma: $norma, total: $total}';
  }
}

enum TrenogaTypeEnum {
  material,
  salaryWork,
  otherCost;

  get name => getRussianName();

  String getRussianName() {
    switch (this) {
      case TrenogaTypeEnum.material:
        return 'Материалы';
      case TrenogaTypeEnum.salaryWork:
        return 'Работы';
      case TrenogaTypeEnum.otherCost:
        return 'Другие затраты';
    }
  }
}

// +------------------+------------------+------+-----+---------+----------------+
// | Field            | Type             | Null | Key | Default | Extra          |
// +------------------+------------------+------+-----+---------+----------------+
// | id               | int(11) unsigned | NO   | PRI | NULL    | auto_increment |
// | name             | varchar(255)     | NO   |     | NULL    |                |
// | type             | varchar(255)     | NO   |     | NULL    |                |
// | ed               | varchar(255)     | YES  |     | NULL    |                |
// | trenogaSpendType | varchar(255)     | YES  |     | NULL    |                |
// | norma            | double           | YES  |     | NULL    |                |
// | total            | double           | YES  |     | NULL    |                |
// +------------------+------------------+------+-----+---------+----------------+
