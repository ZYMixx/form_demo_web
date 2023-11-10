import 'package:form_demo_web/data/repository/repository_constants_data.dart';
import 'package:form_demo_web/data/tools/tool_show_toast.dart';
import 'package:form_demo_web/domain/db_form_entity/bracket_form.dart';
import 'package:form_demo_web/domain/db_form_entity/bracket_spend_form.dart';
import 'package:form_demo_web/domain/form_table_type_enum.dart';

class BracketCalculateItem {
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

class ServiceBracketCalculate {
  static BracketCalculateItem calculateBracketItem() {
    BracketCalculateItem item = calculateAll();
    return item;
  }

  static List<BracketForm> bracketMaterialList = [];
  static List<BracketForm> bracketSalaryWorkList = [];
  static List<BracketForm> bracketOtherCostList = [];

  static List<BracketSpendForm> bracketSpendFormList = [];

  static initBracketFormData() async {
    List<BracketForm> bracketDataFormList =
        await ConstantsData.selectAllByFormType(FormTableTypeEnum.bracket);
    bracketMaterialList = [];
    bracketSalaryWorkList = [];
    bracketOtherCostList = [];
    bracketSpendFormList = [];
    for (var item in bracketDataFormList) {
      if (item.type == BracketTypeEnum.material.name) {
        bracketMaterialList.add(item);
      } else if (item.type == BracketTypeEnum.salaryWork.name) {
        bracketSalaryWorkList.add(item);
      } else if (item.type == BracketTypeEnum.otherCost.name) {
        bracketOtherCostList.add(item);
      }
    }
    bracketSpendFormList = await ConstantsData.selectAllByFormType(FormTableTypeEnum.bracketSpend);
  }

  static BracketCalculateItem calculateAll() {
    BracketCalculateItem bracketCalculateItem = BracketCalculateItem();
    Map<String, Map<String, double>> spendFormMap = {};
    for (var item in bracketSpendFormList) {
      spendFormMap[item.name] = {'кг': item.kgPerMp * item.lPerEd, 'м.п': item.lPerEd};
    }
    bracketCalculateItem.materialCostMap = calculateMaterial();
    bracketCalculateItem.salaryWorkCostMap = calculateSalaryWork();
    bracketCalculateItem.otherCostCostMap = calculateOtherCoast(bracketCalculateItem);
    bracketCalculateItem.spendFormMap = spendFormMap;
    return bracketCalculateItem;
  }

  static Map<String, double> calculateMaterial() {
    Map<String, double> mapCalculateMaterial = {};
    double cost = 0;
    for (var bracketForm in bracketMaterialList) {
      String mapNameKey = '${bracketForm.bracketSpendType ?? ''}${bracketForm.name}';
      if (mapCalculateMaterial[mapNameKey] != null) {
        ToolShowToast.showError(
          'Ошибка вычисления кронштейна. Имена (${mapNameKey}) материалов повторяются. Вычесления неверны',
        );
      }
      // вычесления
      cost = 0;
      mapCalculateMaterial[mapNameKey] = cost;
      if (bracketForm.total != null && bracketForm.bracketSpendType == null) {
        cost = bracketForm.total! * bracketForm.norma!;
        mapCalculateMaterial[mapNameKey] = cost;
      }

      if (bracketForm.bracketSpendType != null && bracketForm.total != null) {
        cost = (bracketForm.norma! * (bracketForm.norma! * bracketForm.total! / 1.2));
        cost = checkHaveSpendNorm(bracketForm.bracketSpendType!, cost); // умножаем на трубу кг/м
        mapCalculateMaterial[mapNameKey] = cost;
      }
    }
    return mapCalculateMaterial;
  }

  static Map<String, double> calculateSalaryWork() {
    Map<String, double> mapCalculateSalary = {};
    double cost = 0;
    for (var bracketForm in bracketSalaryWorkList) {
      String mapNameKey = '${bracketForm.bracketSpendType ?? ''}${bracketForm.name}';
      if (mapCalculateSalary[mapNameKey] != null) {
        ToolShowToast.showError(
          'Ошибка вычисления кронштейна. Имена (${mapNameKey}) Зарплаты повторяются. Вычесления неверны',
        );
      }
      cost = 0;
      if (bracketForm.total != null && bracketForm.norma != null) {
        cost = bracketForm.norma! * bracketForm.total!;
      }
      mapCalculateSalary[mapNameKey] = cost;
    }
    return mapCalculateSalary;
  }

  static Map<String, double> calculateOtherCoast(BracketCalculateItem bracketCalculateItem) {
    Map<String, double> mapCalculateOtherCoast = {};
    double cost = 0;
    for (var bracketForm in bracketOtherCostList) {
      String mapNameKey =
          '${bracketForm.name}${bracketForm.norma != null ? '(${(bracketForm.norma! * 100).toInt()}%)' : ''}';
      if (mapCalculateOtherCoast[mapNameKey] != null) {
        ToolShowToast.showError(
          'Ошибка вычисления кронштейна. Имена (${mapNameKey}) Других Затрат повторяются. Вычесления неверны',
        );
      }
      cost = 0;
      if (bracketForm.ed == BracketTypeEnum.material.name && bracketForm.norma != null) {
        cost = bracketCalculateItem.sumMaterial * bracketForm.norma!;
      }
      if (bracketForm.ed == BracketTypeEnum.salaryWork.name && bracketForm.norma != null) {
        cost = bracketCalculateItem.sumSalaryWork * bracketForm.norma!;
      }
      if (bracketForm.total != null) {
        cost += bracketForm.total!;
      }

      mapCalculateOtherCoast[mapNameKey] = cost;
    }
    return mapCalculateOtherCoast;
  }

  static double checkHaveSpendNorm(String name, double cost) {
    for (var spendForm in bracketSpendFormList) {
      if (name.contains(spendForm.name)) {
        return (cost * spendForm.kgPerMp);
      }
    }
    return cost;
  }
}
