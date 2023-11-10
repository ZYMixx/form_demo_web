import 'package:form_demo_web/domain/db_form_entity/db_entity_form_abstr.dart';
import 'package:mysql1/mysql1.dart';

class ProductsWork extends BdFormEntityAbstr {
  static const String tableName = "`products work`";

  final int id;
  final String? productId;
  String? productName;
  final String? work;
  final double? tarif;

  ProductsWork(ResultRow row)
      : productId = row.fields["product"],
        work = row.fields["work"],
        tarif = row.fields["tarif"],
        id = row.fields["id"];

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'productId': this.productId,
      'productName': this.productName,
      'work': this.work,
      'tarif': this.tarif,
    };
  }
}

// +---------+--------------+------+-----+---------+----------------+
// | Field   | Type         | Null | Key | Default | Extra          |
// +---------+--------------+------+-----+---------+----------------+
// | id      | int(11)      | NO   | PRI | NULL    | auto_increment |
// | product | varchar(255) | YES  |     | NULL    |                |
// | work    | varchar(255) | YES  |     | NULL    |                |
// | tarif   | double       | YES  |     | NULL    |                |
// +---------+--------------+------+-----+---------+----------------+
