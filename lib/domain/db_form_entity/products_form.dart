import 'package:form_demo_web/domain/db_form_entity/db_entity_form_abstr.dart';
import 'package:mysql1/mysql1.dart';

class ProductsForm extends BdFormEntityAbstr {
  static const String tableName = "products";

  final int id;
  final String product;

  ProductsForm(ResultRow row)
      : product = row.fields["product"],
        id = row.fields["id"];

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'product': this.product,
    };
  }
}

// +---------+--------------+------+-----+---------+----------------+
// | Field   | Type         | Null | Key | Default | Extra          |
// +---------+--------------+------+-----+---------+----------------+
// | id      | int(11)      | NO   | PRI | NULL    | auto_increment |
// | product | varchar(255) | YES  |     | NULL    |                |
// +---------+--------------+------+-----+---------+----------------+
