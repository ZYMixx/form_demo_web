import 'package:form_demo_web/data/repository/repository_constants_data.dart';
import 'package:form_demo_web/data/tools/tool_show_toast.dart';
import 'package:form_demo_web/domain/db_form_entity/trenoga_form.dart';
import 'package:form_demo_web/domain/db_form_entity/trenoga_spend_form.dart';
import 'package:form_demo_web/domain/form_table_type_enum.dart';

class TrenogaCalculateItem {
  late Map<String, double> materialCostMap;
  late Map<String, double> salaryWorkCostMap;
  late Map<String, double> otherCostCostMap;
  late Map<String, Map<String, double>> spendFormMap;

  double get sumMaterial => sumOfMapData(materialCostMap);

  double get sumSalaryWork => sumOfMapData(salaryWorkCostMap);

  double get sumOtherCost => sumOfMapData(otherCostCostMap);

  double getSumCostWithVat() {
    return (sumMaterial + sumSalaryWork + sumOtherCost) * 1.2;
  }

  double getSumCostWithOutVat() {
    return sumMaterial + sumSalaryWork + sumOtherCost;
  }

  double sumOfMapData(Map<String, double> map) {
    double sum = 0;
    for (var cost in map.values) {
      sum += cost;
    }
    return sum;
  }
}

class ServiceTrenogaCalculate {
  static TrenogaCalculateItem calculateTrenogaItem() {
    TrenogaCalculateItem item = calculateAll();
    return item;
  }

  static List<TrenogaForm> trenogaMaterialList = [];
  static List<TrenogaForm> trenogaSalaryWorkList = [];
  static List<TrenogaForm> trenogaOtherCostList = [];

  static List<TrenogaSpendForm> trenogaSpendFormList = [];

  static iniTrenogaFormData() async {
    List<TrenogaForm> trenogaDataFormList =
        await ConstantsData.selectAllByFormType(FormTableTypeEnum.trenoga);

    trenogaMaterialList = [];
    trenogaSalaryWorkList = [];
    trenogaOtherCostList = [];
    trenogaSpendFormList = [];
    for (var item in trenogaDataFormList) {
      if (item.type == TrenogaTypeEnum.material.name) {
        trenogaMaterialList.add(item);
      } else if (item.type == TrenogaTypeEnum.salaryWork.name) {
        trenogaSalaryWorkList.add(item);
      } else if (item.type == TrenogaTypeEnum.otherCost.name) {
        trenogaOtherCostList.add(item);
      }
    }
    trenogaSpendFormList = await ConstantsData.selectAllByFormType(FormTableTypeEnum.trenogaSpend);
  }

  static TrenogaCalculateItem calculateAll() {
    TrenogaCalculateItem trenogaCalculateItem = TrenogaCalculateItem();
    Map<String, Map<String, double>> spendFormMap = {};
    for (var item in trenogaSpendFormList) {
      spendFormMap[item.name] = {'кг': item.kgPerMp * item.lPerEd, 'м.п': item.lPerEd};
    }
    trenogaCalculateItem.materialCostMap = calculateMaterial();
    trenogaCalculateItem.salaryWorkCostMap = calculateSalaryWork();
    trenogaCalculateItem.otherCostCostMap = calculateOtherCoast(trenogaCalculateItem);
    trenogaCalculateItem.spendFormMap = spendFormMap;
    return trenogaCalculateItem;
  }

  static Map<String, double> calculateMaterial() {
    Map<String, double> mapCalculateMaterial = {};
    double cost = 0;
    for (var trenogaForm in trenogaMaterialList) {
      String mapNameKey = '${trenogaForm.trenogaSpendType ?? ''}${trenogaForm.name}';
      if (mapCalculateMaterial[mapNameKey] != null) {
        ToolShowToast.showError(
          'Ошибка вычисления кронштейна. Имена (${mapNameKey}) материалов повторяются. Вычесления неверны',
        );
      }
      cost = 0;
      mapCalculateMaterial[mapNameKey] = cost;
      if (trenogaForm.total != null && trenogaForm.trenogaSpendType == null) {
        cost = trenogaForm.total! * trenogaForm.norma!;
        mapCalculateMaterial[mapNameKey] = cost;
      }

      if (trenogaForm.trenogaSpendType != null && trenogaForm.total != null) {
        cost = (trenogaForm.norma! * (trenogaForm.norma! * trenogaForm.total! / 1.2));
        cost = checkHaveSpendNorm(trenogaForm.trenogaSpendType!, cost); // умножаем на трубу кг/м
        mapCalculateMaterial[mapNameKey] = cost;
      }
    }
    return mapCalculateMaterial;
  }

  static Map<String, double> calculateSalaryWork() {
    Map<String, double> mapCalculateSalary = {};
    double cost = 0;
    for (var trenogaForm in trenogaSalaryWorkList) {
      String mapNameKey = '${trenogaForm.trenogaSpendType ?? ''}${trenogaForm.name}';
      if (mapCalculateSalary[mapNameKey] != null) {
        ToolShowToast.showError(
          'Ошибка вычисления кронштейна. Имена (${mapNameKey}) Зарплаты повторяются. Вычесления неверны',
        );
      }
      cost = 0;
      if (trenogaForm.total != null && trenogaForm.norma != null) {
        cost = trenogaForm.norma! * trenogaForm.total!;
      }
      mapCalculateSalary[mapNameKey] = cost;
    }
    return mapCalculateSalary;
  }

  static Map<String, double> calculateOtherCoast(TrenogaCalculateItem trenogaCalculateItem) {
    Map<String, double> mapCalculateOtherCoast = {};
    double cost = 0;
    for (var trenogaForm in trenogaOtherCostList) {
      String mapNameKey =
          '${trenogaForm.name}${trenogaForm.norma != null ? '(${(trenogaForm.norma! * 100).toInt()}%)' : ''}';
      if (mapCalculateOtherCoast[mapNameKey] != null) {
        ToolShowToast.showError(
          'Ошибка вычисления кронштейна. Имена (${mapNameKey}) Других Затрат повторяются. Вычесления неверны',
        );
      }
      cost = 0;
      if (trenogaForm.ed == TrenogaTypeEnum.material.name && trenogaForm.norma != null) {
        cost = trenogaCalculateItem.sumMaterial * trenogaForm.norma!;
      }
      if (trenogaForm.ed == TrenogaTypeEnum.salaryWork.name && trenogaForm.norma != null) {
        cost = trenogaCalculateItem.sumSalaryWork * trenogaForm.norma!;
      }
      if (trenogaForm.total != null) {
        cost += trenogaForm.total!;
      }

      mapCalculateOtherCoast[mapNameKey] = cost;
    }
    return mapCalculateOtherCoast;
  }

  static double checkHaveSpendNorm(String name, double cost) {
    for (var spendForm in trenogaSpendFormList) {
      if (name.contains(spendForm.name)) {
        return (cost * spendForm.kgPerMp);
      }
    }
    return cost;
  }
}
