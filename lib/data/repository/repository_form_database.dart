import 'package:form_demo_web/data/repository/repository_constants_data.dart';
import 'package:form_demo_web/data/tools/tool_show_toast.dart';
import 'package:form_demo_web/domain/db_form_entity/clepki_form.dart';
import 'package:form_demo_web/domain/form_table_type_enum.dart';

import '../../domain/db_form_entity/konstr_form.dart';
import '../database/form_dao_database.dart';

class RepositoryFormDataBase {
  FormDaoDatabase formDao = FormDaoDatabase();

  removeItemFromDB({required String tableName, required int itemID}) {
    formDao.removeFromDataBase(tableName: tableName, itemID: itemID);
  }

  updateDataBaseData(
      {required String tableName,
      required dynamic value,
      required String columnKey,
      required int itemID}) {
    formDao.updateDataBaseData(
        tableName: tableName, value: value, columnKey: columnKey, itemID: itemID);
  }

  Future<bool> insertItemInDBFromMap({required String dbTableName, required Map map}) async {
    ToolShowToast.show('Демо версия - изменения не внесены');
    return false;
  }

  Future<List<KonstrForm>> getAllKonstrForm() async {
    var list = await formDao.selectAllFromTable(
      tableName: "konstr",
      formTableType: FormTableTypeEnum.konstrForm,
    );
    return List.from(list.map((e) => e as KonstrForm));
  }

  Future<List<String>> getAllKonstTip() async {
    List<KonstrForm> listKonstForm =
        await ConstantsData.selectAllByFormType(FormTableTypeEnum.konstrForm);
    List<String> nameList = [];
    for (var konst in listKonstForm) {
      if (nameList.contains(konst.tip)) {
        continue;
      }
      nameList.add(konst.tip);
    }
    return nameList;
  }

  Future<List<KonstrForm>> getAllKonstByTip(String tip) async {
    var listKonstForm = await getAllKonstrForm();
    List<KonstrForm> konstList = [];
    for (var konst in listKonstForm) {
      if (konst.tip == tip) {
        konstList.add(konst);
      }
    }
    return konstList;
  }

  Future<KonstrForm> getKonstrById(int id) async {
    return (await formDao.selectAllByFormTypeWhere<KonstrForm>(
      formTableType: FormTableTypeEnum.konstrForm,
      column: 'id',
      targetValue: id,
    ))
        .first;
  }

  Future<List<ClepkiForm>> checkKonstExist({
    required int height,
    required int width,
    required String tip,
  }) async {
    var list = await formDao.selectClepkiByColumn(tip: tip, height: height, width: width);
    return List.from(list.map((e) => e as ClepkiForm));
  }

  Future<List<KonstrForm>> getKonstByUserParms({
    required int height,
    required int width,
    required int clepkiCount,
    required String tip,
  }) async {
    var list = await formDao.selectClepkiByColumn(tip: tip, height: height, width: width);
    return List.from(list.map((e) => e as ClepkiForm));
  }

  bool cheekDoubleWidthFromConst(String tip) {
    var value = ConstantsData.mapValueConst[tip];
    if (value?.value2 == "2") {
      return true;
    } else {
      return false;
    }
  }

  insertIntoClipki({
    required String tip,
    required int h,
    required int w,
    required int clepki,
  }) async {
    ToolShowToast.show('Демо версия - изменения не внесены');
  }
}
