import 'package:form_demo_web/data/services/service_bracket_calculate.dart';
import 'package:form_demo_web/data/services/service_find_spinner_table_data.dart';
import 'package:form_demo_web/data/services/service_trenoga_calculate.dart';
import 'package:form_demo_web/domain/db_form_entity/clepki_form.dart';
import 'package:form_demo_web/domain/db_form_entity/db_entity_form_abstr.dart';
import 'package:form_demo_web/domain/db_form_entity/products_materials_form.dart';
import 'package:form_demo_web/domain/form_table_type_enum.dart';

import '../../domain/db_form_entity/constants_form.dart';
import '../database/form_dao_database.dart';

class ConstantsData {
  static List<ConstantsForm> listConst = [];
  static Map<String, ConstantsForm> mapValueConst = {}; //name
  static Map<int, ConstantsForm> mapIDConst = {};

  static List<ProductsMaterialsForm> listProductMaterials = [];
  static Map<int, ProductsMaterialsForm> mapIDProductMaterials = {};

  static _resetAndRefreshConstants() async {
    mapValueConst = {};
    mapIDConst = {};
    listProductMaterials = [];
    mapIDProductMaterials = {};
    await initConstForm();
    await initProductMaterialsForm();
  }

  static reLoadAllDataBaseData() async {
    await _resetAndRefreshConstants();
    ServiceBracketCalculate.initBracketFormData();
    ServiceTrenogaCalculate.iniTrenogaFormData();
    ServiceFindSpinnerTableData.initSpinnerList();
  }

  static getConstListBySubKey(String subKey) async {
    return (await ConstantsData.selectAllByFormType<ConstantsForm>(FormTableTypeEnum.constantsForm))
        .where((e) => e.subKey == subKey)
        .toList();
  }

  static Future<List<T>> selectAllByFormType<T extends BdFormEntityAbstr>(
    FormTableTypeEnum formTableType,
  ) async {
    var listFromDb = await FormDaoDatabase().selectAllFromTable(
      tableName: formTableType.getDbTableName(),
      formTableType: formTableType,
    );
    return List.from(listFromDb.map((e) => e as T));
  }

  static Future<List<ClepkiForm>> getAllClepki() async {
    var clepkiListFromDb = await FormDaoDatabase().selectAllFromTable(
        tableName: ClepkiForm.tableName, formTableType: FormTableTypeEnum.clepkiForm);
    return List.from(clepkiListFromDb.map((e) => e as ClepkiForm));
  }

  static initConstForm() async {
    List<ConstantsForm> constListFromDb =
        await selectAllByFormType(FormTableTypeEnum.constantsForm);
    listConst.addAll(constListFromDb);
    for (var item in listConst) {
      mapValueConst.putIfAbsent(item.value!, () => item);
    }
    for (var item in listConst) {
      mapIDConst.putIfAbsent(item.id, () => item);
    }
  }

  static initProductMaterialsForm() async {
    List<ProductsMaterialsForm> listProductMaterialsFromDb =
        await selectAllByFormType(FormTableTypeEnum.productsMaterialsForm);
    listProductMaterials.addAll(listProductMaterialsFromDb);
    for (var item in listProductMaterials) {
      mapIDProductMaterials.putIfAbsent(item.id, () => item);
    }
  }

  static ProductsMaterialsForm getProductMaterials(int id) {
    return mapIDProductMaterials[id]!;
  }

  static ConstantsForm getConstById(int id) {
    return mapIDConst[id]!;
  }
}

class ConstName {
  static const int id_othod = 51;
  static const int id_job_welding = 53;
  static const int id_job_cut_low_profile = 54;
  static const int id_job_cut_high_profile = 55;
  static const int id_job_cut_uni = 56;
  static const int id_job_cut_pipe = 57;
  static const int id_job_drilling_line = 58;
  static const int id_job_Drilling_face = 59;
  static const int id_job_drilling_rolling = 60;
  static const int id_job_drilling_Univ = 61;
  static const int id_job_rolling = 62;
  static const int id_job_exterior = 63;
  static const int id_job_cleanup_int = 64;
  static const int id_job_sweep_uni = 65;
  static const int id_job_flip = 66;
  static const int id_job_weld_bead = 67;
  static const int id_job_sawing = 68;
  static const int id_job_painting = 69;
  static const int id_job_markup = 70;
  static const int id_job_drill_rivet = 71;
  static const int id_job_riveting = 72;
  static const int id_job_sealant_apply = 73;
  static const int id_job_master = 74;
  static const int id_job_vacation = 75;
  static const int id_transport = 76;
  static const int id_electricity = 77;
  static const int id_output_plywood = 78;
  static const int id_ESN = 79;
  static const int id_exit_metal = 81;

  //tip
  static const String tip_linear = "линейный";
  static const String tip_tortsevoy = "торцевой";
  static const String tip_linear_end = "линейно-торцевой";
  static const String tip_generic = "универсальный";
  static const String tip_angular_inner = "угловой внутренний";
  static const String tip_angular_outer = "угловой наружный";
  static const String tip_sharnir = "шарнирный";
  static const String tip_Wy_shaped = "Wу-образный";
  static const String tip_W_shaped = "W-образный";

  //id metals
  static const int id_argon = 28;
  static const int id_argon_E = 49;
  static const int id_germetik = 29;
  static const int id_grynt = 30;
  static const int id_zaklep = 31;
  static const int id_provoloka = 32;
  static const int id_paint = 33;
  static const int id_3271 = 34;
  static const int id_3919 = 35;
  static const int id_3272 = 36;
  static const int id_2933 = 37;
  static const int id_28 = 38;
  static const int id_25 = 39;
  static const int id_03_0006 = 40;
  static const int id_03_0001 = 41;
  static const int id_05_0001 = 42;
  static const int id_2861 = 43;
  static const int id_2860 = 44;
  static const int id_3205 = 45;
  static const int id_shina_5_40 = 46;
  static const int id_crugST20 = 47;
  static const int id_fanera = 50;

  static Map<String, List<int>> mapSupGroup = {}..['aluminiy'] = [
      id_3271,
      id_3919,
      id_3272,
      id_2933,
      id_28,
      id_25,
      id_03_0006,
      id_03_0001,
      id_05_0001,
      id_2861,
      id_2860,
      id_3205,
    ];
}
