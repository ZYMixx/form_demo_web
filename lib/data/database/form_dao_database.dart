import 'package:form_demo_web/data/firebase/fake_result_row.dart';
import 'package:form_demo_web/data/firebase/fire_database.dart';
import 'package:form_demo_web/data/tools/tool_show_toast.dart';
import 'package:form_demo_web/domain/form_table_type_enum.dart';
import 'package:mysql1/mysql1.dart';

import '../../domain/db_form_entity/clepki_form.dart';
import '../../domain/db_form_entity/db_entity_form_abstr.dart';
import 'form_mapper.dart';

class FormDaoDatabase {
  /// Методы использовались дял паката [mysql1]
  /// переписаны под [ResultRow] заменён на [FakeResultRow]
  /// база данных: Firebase Realtime

  Future<List<BdFormEntityAbstr>> selectAllFromTable({
    required String tableName,
    required FormTableTypeEnum formTableType,
  }) async {
    List<FakeResultRow> fakeResults = await FireDatabase.selectAllFromTable(tableName);
    List<BdFormEntityAbstr> fakeTablesList =
        FormMapper.fakeParsToFormEntity(results: fakeResults, formTableType: formTableType);
    return fakeTablesList;
  }

  Future<List<T>> selectAllByFormTypeWhere<T extends BdFormEntityAbstr>({
    required FormTableTypeEnum formTableType,
    required String column,
    required dynamic targetValue,
  }) async {
    List<FakeResultRow> fakeResults = await FireDatabase.selectAllWhereColumn(
        tableName: formTableType.getDbTableName(), columnKey: column, columnValue: targetValue);
    List<BdFormEntityAbstr> fakeTablesList =
        FormMapper.fakeParsToFormEntity(results: fakeResults, formTableType: formTableType);
    return List.from(fakeTablesList.map((e) => e as T));
  }

  Future<List<BdFormEntityAbstr>> selectClepkiByColumn({
    required String tip,
    required int height,
    required int width,
  }) async {
    List<FakeResultRow> fakeResults =
        await FireDatabase.selectAllWhereMultiColumn(tableName: ClepkiForm.tableName, columnMap: {
      'tip': tip,
      'h': height,
      'w': width,
    });
    List<BdFormEntityAbstr> fakeTablesList = FormMapper.fakeParsToFormEntity(
        results: fakeResults, formTableType: FormTableTypeEnum.clepkiForm);
    return fakeTablesList;
  }

  removeFromDataBase({
    required String tableName,
    required int itemID,
  }) {}

  updateDataBaseData({
    required String tableName,
    required dynamic value,
    required String columnKey,
    required int itemID,
  }) async {
    ToolShowToast.show('Демо версия - изменения не внесены');
  }
}
