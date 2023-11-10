import 'package:form_demo_web/domain/db_form_entity/bracket_form.dart';
import 'package:form_demo_web/domain/db_form_entity/bracket_spend_form.dart';
import 'package:form_demo_web/domain/db_form_entity/clepki_form.dart';
import 'package:form_demo_web/domain/db_form_entity/constants_form.dart';
import 'package:form_demo_web/domain/db_form_entity/db_entity_form_abstr.dart';
import 'package:form_demo_web/domain/db_form_entity/konstr_form.dart';
import 'package:form_demo_web/domain/db_form_entity/products_form.dart';
import 'package:form_demo_web/domain/db_form_entity/products_materials_form.dart';
import 'package:form_demo_web/domain/db_form_entity/products_work_form.dart';
import 'package:form_demo_web/domain/db_form_entity/trenoga_form.dart';
import 'package:form_demo_web/domain/db_form_entity/trenoga_spend_form.dart';
import 'package:form_demo_web/domain/db_form_entity/worker_form.dart';
import 'package:mysql1/mysql1.dart';

enum FormTableTypeEnum {
  konstrForm,
  clepkiForm,
  constantsForm,
  rabotniki,
  products,
  productsWork,
  productsMaterialsForm,
  bracket,
  bracketSpend,
  trenoga,
  trenogaSpend;

  Type get formRunType => _getRuntimeType();

  BdFormEntityAbstr inflateFormObject(ResultRow row) {
    switch (this) {
      case konstrForm:
        return KonstrForm(row);
      case clepkiForm:
        return ClepkiForm(row);
      case constantsForm:
        return ConstantsForm(row);
      case productsMaterialsForm:
        return ProductsMaterialsForm(row);
      case rabotniki:
        return WorkerForm(row);
      case products:
        return ProductsForm(row);
      case productsWork:
        return ProductsWork(row);
      case bracket:
        return BracketForm(row);
      case bracketSpend:
        return BracketSpendForm(row);
      case trenoga:
        return TrenogaForm(row);
      case trenogaSpend:
        return TrenogaSpendForm(row);
    }
  }

  Type _getRuntimeType() {
    switch (this) {
      case konstrForm:
        return KonstrForm;
      case clepkiForm:
        return ClepkiForm;
      case constantsForm:
        return ConstantsForm;
      case productsMaterialsForm:
        return ProductsMaterialsForm;
      case rabotniki:
        return WorkerForm;
      case products:
        return ProductsForm;
      case productsWork:
        return ProductsWork;
      case bracket:
        return BracketForm;
      case bracketSpend:
        return BracketSpendForm;
      case trenoga:
        return TrenogaForm;
      case trenogaSpend:
        return TrenogaSpendForm;
    }
  }

  String getDbTableName() {
    switch (this) {
      case konstrForm:
        return KonstrForm.tableName;
      case clepkiForm:
        return ClepkiForm.tableName;
      case constantsForm:
        return ConstantsForm.tableName;
      case productsMaterialsForm:
        return ProductsMaterialsForm.tableName;
      case rabotniki:
        return WorkerForm.tableName;
      case products:
        return ProductsForm.tableName;
      case productsWork:
        return ProductsWork.tableName;
      case bracket:
        return BracketForm.tableName;
      case bracketSpend:
        return BracketSpendForm.tableName;
      case trenoga:
        return TrenogaForm.tableName;
      case trenogaSpend:
        return TrenogaSpendForm.tableName;
    }
  }
}
