import 'package:form_demo_web/data/firebase/fake_result_row.dart';
import 'package:form_demo_web/domain/form_table_type_enum.dart';

import '../../domain/db_form_entity/db_entity_form_abstr.dart';

class FormMapper {
  static List<BdFormEntityAbstr> fakeParsToFormEntity({
    required List<FakeResultRow> results,
    required FormTableTypeEnum formTableType,
  }) {
    List<BdFormEntityAbstr> list = [];

    for (var row in results) {
      list.add(formTableType.inflateFormObject(row));
    }
    return list;
  }
}
