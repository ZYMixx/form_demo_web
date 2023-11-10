import 'package:flutter/material.dart';
import 'package:form_demo_web/data/services/service_bracket_calculate.dart';
import 'package:form_demo_web/data/services/service_shared_preferences.dart';
import 'package:form_demo_web/domain/db_form_entity/bracket_spend_form.dart';
import 'package:form_demo_web/presentation/bracket_screen/bracket_left_input_block.dart';
import 'package:form_demo_web/presentation/bracket_screen/bracket_right_panel_block.dart';
import 'package:form_demo_web/presentation/view_models/abstract_work_view_model.dart';

enum BracketTabEnum { rentability, produced }

class BracketDataViewModel extends AbstractWorkViewModel {
  static BracketDataViewModel get instance => _instance ??= BracketDataViewModel();
  static BracketDataViewModel? _instance;

  BracketCalculateItem get bracketCalculateItem => ServiceBracketCalculate.calculateBracketItem();
  int targetRentability = 10;
  int producedBracket = 1;
  BracketTabEnum selectedTab = BracketTabEnum.rentability;

  int additionCalculateNumber =
      int.tryParse(ServiceSharedPreferences.getString(key: 'additionCalculateNumber') ?? '0') ?? 0;

  static const String _historySupplyDBKey = 'bracket_supply_key_';

  BracketDataViewModel() {
    if (_instance != null) {
      throw ("pls dont create second BracketDataViewModel, use instance");
    }
  }

  changeBracketTab({required BracketTabEnum tab}) {
    if (selectedTab != tab) {
      selectedTab = tab;
      notifyListeners();
    }
  }

  setRentabilityCount(int count) {
    if (targetRentability == count) {
      return;
    }
    targetRentability = count;
    notifyListeners();
  }

  setProducedCount(int count) {
    if (producedBracket == count) {
      return;
    }
    producedBracket = count;
    notifyListeners();
  }

  addOnePressed() {
    switch (selectedTab) {
      case BracketTabEnum.rentability:
        targetRentability += 1;
        break;
      case BracketTabEnum.produced:
        producedBracket += 1;
        break;
    }
    notifyListeners();
  }

  removeOnePressed() {
    switch (selectedTab) {
      case BracketTabEnum.rentability:
        targetRentability -= 1;
        break;
      case BracketTabEnum.produced:
        producedBracket -= 1;
        break;
    }
    notifyListeners();
  }

  Map<String, SpendMaterial> getMaterialProduceMap() {
    Map<String, SpendMaterial> mapSpendMaterial = {};
    for (var material in ServiceBracketCalculate.bracketMaterialList) {
      for (BracketSpendForm spendForm in ServiceBracketCalculate.bracketSpendFormList) {
        if (material.bracketSpendType == spendForm.name) {
          String? historySupply =
              ServiceSharedPreferences.getString(key: '$_historySupplyDBKey${spendForm.name}');
          double mpSpend = spendForm.lPerEd * producedBracket;
          double kgSpend = spendForm.kgPerMp * mpSpend;
          SpendMaterial spendMaterial =
              SpendMaterial(kgSpend: kgSpend, mpSpend: mpSpend, historySupply: historySupply);
          if (mapSpendMaterial[spendForm.name] != null) {
            SpendMaterial oldSpendMaterial = mapSpendMaterial[spendForm.name]!;
            SpendMaterial newSpendMaterial = SpendMaterial(
                kgSpend: oldSpendMaterial.kgSpend + spendMaterial.kgSpend,
                mpSpend: oldSpendMaterial.mpSpend! + spendMaterial.mpSpend!,
                historySupply: historySupply);
            mapSpendMaterial[spendForm.name] = newSpendMaterial;
            continue;
          } else {
            mapSpendMaterial[spendForm.name] = spendMaterial;
            continue;
          }
        }
        if (material.bracketSpendType == null && material.norma != null) {
          String? historySupply =
              ServiceSharedPreferences.getString(key: '$_historySupplyDBKey${material.name}');
          double kgSpend = material.norma! * producedBracket;
          SpendMaterial spendMaterial =
              SpendMaterial(kgSpend: kgSpend, mpSpend: null, historySupply: historySupply);
          mapSpendMaterial[material.name] = spendMaterial;
        }
      }
    }
    return mapSpendMaterial;
  }

  saveHistoryBracketSupply({required String name, required String data}) {
    if (int.tryParse(data) != null) {
      ServiceSharedPreferences.putString(key: '$_historySupplyDBKey$name', stringData: data);
    }
  }

  setAdditionCalculateNumber(int? data) {
    if (data != null) {
      ServiceSharedPreferences.putString(
          key: 'additionCalculateNumber', stringData: data.toString());
      additionCalculateNumber = data;
      notifyListeners();
    }
  }

  Map<String, int> getAdditionCalculateMap() {
    if (additionCalculateNumber == 0.0) {
      return {};
    }
    Map<String, int> additionSpendMap = {};
    int summ = 0;
    additionSpendMap['общие'] = summ;
    for (var material in ServiceBracketCalculate.bracketMaterialList) {
      for (BracketSpendForm spendForm in ServiceBracketCalculate.bracketSpendFormList) {
        if (material.bracketSpendType == spendForm.name) {
          if (additionSpendMap[spendForm.name] != null) {
            var old = additionSpendMap[spendForm.name];
            additionSpendMap[spendForm.name] =
                ((spendForm.lPerEd * producedBracket) / additionCalculateNumber).ceil() +
                    (old ?? 0);
            summ += ((spendForm.lPerEd * producedBracket) / additionCalculateNumber).ceil();
            continue;
          } else {
            additionSpendMap[spendForm.name] =
                ((spendForm.lPerEd * producedBracket) / additionCalculateNumber).ceil();
            summ += additionSpendMap[spendForm.name]!;
            continue;
          }
        }
      }
    }
    additionSpendMap['общие'] = summ;
    return additionSpendMap;
  }

  @override
  Widget buildDefaultLeftWidget() {
    return BracketLeftInputBlock();
  }

  @override
  Widget buildDefaultRightWidget() {
    return BracketRightDataPanel();
  }

  @override
  void selfDispose() {
    super.dispose();
  }

  @override
  String get name => 'Кронштейн';
}

class SpendMaterial {
  double kgSpend;
  double? mpSpend;
  String? historySupply;

  SpendMaterial({
    required this.kgSpend,
    required this.mpSpend,
    this.historySupply,
  });
}
