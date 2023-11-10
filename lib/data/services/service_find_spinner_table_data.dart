import 'package:form_demo_web/data/repository/repository_constants_data.dart';
import 'package:form_demo_web/domain/db_form_entity/bracket_form.dart';
import 'package:form_demo_web/domain/db_form_entity/bracket_spend_form.dart';
import 'package:form_demo_web/domain/db_form_entity/trenoga_spend_form.dart';
import 'package:form_demo_web/domain/form_table_type_enum.dart';

class ServiceFindSpinnerTableData {
  static List<String> listOtherCostGroup = [];
  static List<String> listPipeGroup = [];
  static List<String> listTrenogaPipeGroup = [];

  static initSpinnerList() async {
    listPipeGroup = ['-'];
    listTrenogaPipeGroup = ['-'];
    listOtherCostGroup = [
      '-',
      BracketTypeEnum.material.getRussianName(),
      BracketTypeEnum.otherCost.getRussianName(),
    ];
    List<BracketSpendForm> listBracket =
        await ConstantsData.selectAllByFormType(FormTableTypeEnum.bracketSpend);
    List<TrenogaSpendForm> listTrenoga =
        await ConstantsData.selectAllByFormType(FormTableTypeEnum.trenogaSpend);
    listPipeGroup.addAll(listBracket.map((e) => e.name));
    listTrenogaPipeGroup.addAll(listTrenoga.map((e) => e.name));
  }

  static List<String>? find({required String tableKey}) {
    if (tableKey == 'otherCostGroup') {
      return listOtherCostGroup;
    }
    if (tableKey == 'pipeGroup') {
      return listPipeGroup;
    }
    if (tableKey == 'trenogaPipeGroup') {
      return listTrenogaPipeGroup;
    }
    return null;
  }
}
