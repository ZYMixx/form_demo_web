import 'package:form_demo_web/domain/db_form_entity/db_entity_form_abstr.dart';
import 'package:mysql1/mysql1.dart';

class ProductsMaterialsForm extends BdFormEntityAbstr {
  static const String tableName = "`products materials`";
  final int id;
  final String? key;
  final String? name;
  final String? ed;
  final double? norma;
  final double? coast;
  final String? subGroup;

  ProductsMaterialsForm(ResultRow row)
      : id = row.fields["id"],
        key = row.fields["key"],
        name = row.fields["name"],
        ed = row.fields["ed"],
        norma = row.fields["norma"],
        coast = row.fields["coast"],
        subGroup = row.fields["subGroup"];

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'key': this.key,
      'name': this.name,
      'ed': this.ed,
      'norma': this.norma,
      'coast': this.coast,
      'subGroup': this.subGroup,
    };
  }
}
//  `products materials`
// +----------+--------------+------+-----+---------+----------------+
// | Field    | Type         | Null | Key | Default | Extra          |
// +----------+--------------+------+-----+---------+----------------+
// | id       | int(11)      | NO   | PRI | NULL    | auto_increment |
// | key      | varchar(255) | YES  |     | NULL    |                |
// | name     | varchar(255) | YES  |     | NULL    |                |
// | ed       | varchar(255) | YES  |     | NULL    |                |
// | norma    | double       | YES  |     | NULL    |                |
// | coast    | double       | YES  |     | NULL    |                |
// | subGroup | varchar(255) | YES  |     | NULL    |                |
// +----------+--------------+------+-----+---------+----------------+
