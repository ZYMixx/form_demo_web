import 'package:form_demo_web/data/repository/repository_constants_data.dart';
import 'package:form_demo_web/domain/db_form_entity/db_entity_form_abstr.dart';
import 'package:form_demo_web/domain/form_table_type_enum.dart';

import '../database/form_dao_database.dart';

class RepositoryWorkBD {
  FormDaoDatabase formDao = FormDaoDatabase();

  Future<List<T>> selectAllBracket<T extends BdFormEntityAbstr>() async {
    return await ConstantsData.selectAllByFormType(FormTableTypeEnum.bracket);
  }

  Future<List<T>> selectAllBracketByType<T extends BdFormEntityAbstr>(
      {required FormTableTypeEnum formTableType, required String targetValue}) async {
    return await formDao.selectAllByFormTypeWhere(
        formTableType: formTableType, column: 'type', targetValue: targetValue);
  }

  Future<List<T>> selectAllTrenogaByType<T extends BdFormEntityAbstr>(
      {required FormTableTypeEnum formTableType, required String targetValue}) async {
    return await formDao.selectAllByFormTypeWhere(
        formTableType: formTableType, column: 'type', targetValue: targetValue);
  }
}
