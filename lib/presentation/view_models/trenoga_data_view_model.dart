import 'package:flutter/material.dart';
import 'package:form_demo_web/data/services/service_shared_preferences.dart';
import 'package:form_demo_web/data/services/service_trenoga_calculate.dart';
import 'package:form_demo_web/domain/db_form_entity/trenoga_spend_form.dart';
import 'package:form_demo_web/presentation/trenoga_screen/trenoga_left_input_block.dart';
import 'package:form_demo_web/presentation/trenoga_screen/trenoga_right_data_panel.dart';
import 'package:form_demo_web/presentation/view_models/abstract_work_view_model.dart';

enum TrenogaTabEnum { rentability, produced }

class TrenogaDataViewModel extends AbstractWorkViewModel {
  static TrenogaDataViewModel get instance => _instance ??= TrenogaDataViewModel();
  static TrenogaDataViewModel? _instance;

  TrenogaCalculateItem get trenogaCalculateItem => ServiceTrenogaCalculate.calculateTrenogaItem();
  int targetRentability = 10;
  int producedTrenoga = 1;
  TrenogaTabEnum selectedTab = TrenogaTabEnum.rentability;

  int additionTrenogaCalculateNumber = int.tryParse(
          ServiceSharedPreferences.getString(key: 'additionTrenogaCalculateNumber') ?? '0') ??
      0;

  TrenogaDataViewModel() {
    if (_instance != null) {
      throw ("pls dont create second TrenogaDataViewModel, use instance");
    }
  }

  changeTrenogaTab({required TrenogaTabEnum tab}) {
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
    if (producedTrenoga == count) {
      return;
    }
    producedTrenoga = count;
    notifyListeners();
  }

  addOnePressed() {
    switch (selectedTab) {
      case TrenogaTabEnum.rentability:
        targetRentability += 1;
        break;
      case TrenogaTabEnum.produced:
        producedTrenoga += 1;
        break;
    }
    notifyListeners();
  }

  removeOnePressed() {
    switch (selectedTab) {
      case TrenogaTabEnum.rentability:
        targetRentability -= 1;
        break;
      case TrenogaTabEnum.produced:
        producedTrenoga -= 1;
        break;
    }
    notifyListeners();
  }

  //
  //// Produce Screen
  //

  static const String _historySupplyDBKey = 'trenoga_supply_key_';

  Map<String, SpendMaterial> getMaterialProduceMap() {
    Map<String, SpendMaterial> mapSpendMaterial = {};
    for (var material in ServiceTrenogaCalculate.trenogaMaterialList) {
      for (TrenogaSpendForm spendForm in ServiceTrenogaCalculate.trenogaSpendFormList) {
        if (material.trenogaSpendType == spendForm.name) {
          double mpSpend = spendForm.lPerEd * producedTrenoga;
          double kgSpend = spendForm.kgPerMp * mpSpend;
          String? historySupply =
              ServiceSharedPreferences.getString(key: '$_historySupplyDBKey${spendForm.name}');
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
        if (material.trenogaSpendType == null && material.norma != null) {
          String? historySupply =
              ServiceSharedPreferences.getString(key: '$_historySupplyDBKey${material.name}');
          double kgSpend = material.norma! * producedTrenoga;
          SpendMaterial spendMaterial =
              SpendMaterial(kgSpend: kgSpend, mpSpend: null, historySupply: historySupply);
          mapSpendMaterial[material.name] = spendMaterial;
        }
      }
    }
    return mapSpendMaterial;
  }

  saveHistoryTrenogaSupply({required String name, required String data}) {
    if (int.tryParse(data) != null) {
      print('put historySupply  $_historySupplyDBKey$name ${data}');

      ServiceSharedPreferences.putString(key: '$_historySupplyDBKey$name', stringData: data);
    }
  }

  setAdditionCalculateNumber(int? data) {
    if (data != null) {
      ServiceSharedPreferences.putString(
          key: 'additionTrenogaCalculateNumber', stringData: data.toString());
      additionTrenogaCalculateNumber = data;
      notifyListeners();
    }
  }

  Map<String, int> getAdditionCalculateMap() {
    if (additionTrenogaCalculateNumber == 0.0) {
      return {};
    }
    Map<String, int> additionSpendMap = {};
    int summ = 0;
    additionSpendMap['общие'] = summ;
    var Bracetlist = ServiceTrenogaCalculate.trenogaMaterialList;

    for (var material in ServiceTrenogaCalculate.trenogaMaterialList) {
      for (TrenogaSpendForm spendForm in ServiceTrenogaCalculate.trenogaSpendFormList) {
        if (material.trenogaSpendType == spendForm.name) {
          if (additionSpendMap[spendForm.name] != null) {
            var old = additionSpendMap[spendForm.name];
            additionSpendMap[spendForm.name] =
                ((spendForm.lPerEd * producedTrenoga) / additionTrenogaCalculateNumber).ceil() +
                    (old ?? 0);
            summ += ((spendForm.lPerEd * producedTrenoga) / additionTrenogaCalculateNumber).ceil();
            continue;
          } else {
            additionSpendMap[spendForm.name] =
                ((spendForm.lPerEd * producedTrenoga) / additionTrenogaCalculateNumber).ceil();
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
    return TrenogaLeftInputBlock();
  }

  @override
  Widget buildDefaultRightWidget() {
    return TrenogaRightDataPanel();
  }

  @override
  void selfDispose() {
    super.dispose();
  }

  @override
  String get name => 'Тринога';
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
