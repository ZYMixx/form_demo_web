import 'package:form_demo_web/domain/db_form_entity/db_entity_form_abstr.dart';
import 'package:mysql1/mysql1.dart';

class BracketForm extends BdFormEntityAbstr {
  int id;
  String name;
  String combName;
  String type;
  String? ed;
  String? bracketSpendType;
  double? norma;
  double? total;

  BracketForm(ResultRow row)
      : id = row.fields["id"],
        name = row.fields["name"],
        combName = (row.fields["bracketSpendType"] ?? '') + row.fields["name"],
        type = row.fields["type"],
        ed = row.fields["ed"],
        bracketSpendType = row.fields["bracketSpendType"],
        total = row.fields["total"],
        norma = row.fields["norma"];

  static const String tableName = "bracket";

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'name': this.name,
      'combName': this.combName,
      'type': this.type,
      'ed': this.ed,
      'bracketSpendType': this.bracketSpendType,
      'norma': this.norma,
      'total': this.total,
    };
  }

  @override
  String toString() {
    return 'BracketForm{id: $id, name: $name, combName: $combName, type: $type, ed: $ed, bracketSpendType: $bracketSpendType, norma: $norma, total: $total}';
  }
}

enum BracketTypeEnum {
  material,
  salaryWork,
  otherCost;

  get name => getRussianName();

  String getRussianName() {
    switch (this) {
      case BracketTypeEnum.material:
        return 'Материалы';
      case BracketTypeEnum.salaryWork:
        return 'Работы';
      case BracketTypeEnum.otherCost:
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
// | bracketSpendType | varchar(255)     | YES  |     | NULL    |                |
// | norma            | double           | YES  |     | NULL    |                |
// | total            | double           | YES  |     | NULL    |                |
// +------------------+------------------+------+-----+---------+----------------+
