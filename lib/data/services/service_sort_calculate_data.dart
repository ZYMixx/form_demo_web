import 'package:form_demo_web/data/repository/repository_constants_data.dart';
import 'package:form_demo_web/data/services/service_calculate_shield_data.dart';
import 'package:form_demo_web/domain/calculate_item.dart';

enum ShieldDataMark {
  materials,
  metalWork,
  metalPrepare,
  welding,
  plywood,
  overheadCosts,
  costPrice;

  String get name => getName();

  String getName() {
    switch (this) {
      case materials:
        return "Материалы";
      case metalWork:
        return "Металлообработка";
      case metalPrepare:
        return "Металлоподготовка";
      case welding:
        return "Сварка";
      case plywood:
        return "Фанеровка";
      case overheadCosts:
        return "Накладные расходы";
      case costPrice:
        return "Себестоимость";
    }
  }
}

class ServiceSortCalculateData {
  ServiceCalculateShieldData shieldData;

  List<CalculateShieldItem> listMaterials = [];
  List<CalculateShieldItem> listMetalWork = [];
  List<CalculateShieldItem> listMetalPrepare = [];
  List<CalculateShieldItem> listWelding = [];
  List<CalculateShieldItem> listPlywood = [];
  List<CalculateShieldItem> listOverheadCost = [];
  List<CalculateShieldItem> listCostPrice = [];
  List<List<CalculateShieldItem>> listAllSortCalculateData = [];

  ServiceSortCalculateData(this.shieldData) {
    sortData();
    listAllSortCalculateData.add(listMaterials);
    listAllSortCalculateData.add(listMetalWork);
    listAllSortCalculateData.add(listMetalPrepare);
    listAllSortCalculateData.add(listWelding);
    listAllSortCalculateData.add(listPlywood);
    listAllSortCalculateData.add(listOverheadCost);
    listAllSortCalculateData.add(listCostPrice);
  }

  sortData() {
    sortMaterials();
    sortMetalWork();
    sortMetalPrepare();
    sortWelding();
    sortPlywood();
    sortOverheadCost();
    sortCostPrice();
  }

  double round(dynamic nomber) {
    return double.parse(nomber.toStringAsFixed(3));
  }

  sortMaterials() {
    String name;
    double cost;
    List<double> secondUsrData = [];
    if (shieldData.materialsCost != 0) {
      secondUsrData = [round(shieldData.metalWeight)];
      name = "Материалы: Вес: %value_0 кг";
      secondUsrData = [round(shieldData.metalWeight)];
      cost = round(shieldData.materialsCost);
      listMaterials.add(
        CalculateShieldItem(
          shieldFullName: shieldData.konstrData.konstr.fullName,
          cost: cost,
          name: name,
          secondUsrData: secondUsrData,
        ),
      );
    }
    if (shieldData.costBinding != 0) {
      name = "Профиль обвязочный (3271): %value_0 м.п. %value_1 кг.";
      secondUsrData = [round(shieldData.bindingLength), round(shieldData.bindingWeight)];
      cost = round(shieldData.costBinding);
      listMaterials.add(
        CalculateShieldItem(
          shieldFullName: shieldData.konstrData.konstr.fullName,
          cost: cost,
          name: name,
          secondUsrData: secondUsrData,
        ),
      );
    }
    if (shieldData.boxCost != 0) {
      name = "Профиль коробочка (3919): %value_0 м.п. %value_1 кг.";
      secondUsrData = [round(shieldData.boxLength), round(shieldData.boxWeight)];
      cost = round(shieldData.boxCost);
      listMaterials.add(
        CalculateShieldItem(
          shieldFullName: shieldData.konstrData.konstr.fullName,
          cost: cost,
          name: name,
          secondUsrData: secondUsrData,
        ),
      );
    }
    if (shieldData.pipe28Cost != 0) {
      name = "Труба28/3: %value_0 шт. %value_1 м.п. %value_2 кг.";
      secondUsrData = [
        round(shieldData.LO + shieldData.TO),
        round(shieldData.pipe28Length),
        round(shieldData.pipe28Weight),
      ];
      cost = round(shieldData.pipe28Cost);
      listMaterials.add(
        CalculateShieldItem(
          shieldFullName: shieldData.konstrData.konstr.fullName,
          cost: cost,
          name: name,
          secondUsrData: secondUsrData,
        ),
      );
    }
    if (shieldData.pipe25Cost != 0) {
      name = "Труба25/1: %value_0 шт %value_1 м.п. %value_2 кг.";
      secondUsrData = [
        round(shieldData.konstrData.konstr.getV()),
        round(shieldData.pipe25Length),
        round(shieldData.pipe25Weight),
      ];
      cost = round(shieldData.pipe25Cost);
      listMaterials.add(
        CalculateShieldItem(
          shieldFullName: shieldData.konstrData.konstr.fullName,
          cost: cost,
          name: name,
          secondUsrData: secondUsrData,
        ),
      );
    }
    if (shieldData.tire5x40Cost != 0) {
      name = "Шина 5х40: %value_0 м.п. %value_1 кг.";
      secondUsrData = [round(shieldData.tire5x40Length), round(shieldData.tire5x40Weight)];
      cost = round(shieldData.tire5x40Cost);
      listMaterials.add(
        CalculateShieldItem(
          shieldFullName: shieldData.konstrData.konstr.fullName,
          cost: cost,
          name: name,
          secondUsrData: secondUsrData,
        ),
      );
    }
    if (shieldData.circleCT20Cost != 0) {
      name = "КругСТ20: %value_0 м.п. %value_1 кг.";
      secondUsrData = [round(shieldData.circleCT20Length), round(shieldData.circleCT20Weight)];
      cost = round(shieldData.circleCT20Cost);
      listMaterials.add(
        CalculateShieldItem(
          shieldFullName: shieldData.konstrData.konstr.fullName,
          cost: cost,
          name: name,
          secondUsrData: secondUsrData,
        ),
      );
    }
    if (shieldData.plywoodCost != 0) {
      name = "Фанера: %value_0 м.кв %value_1 / 55.55)} м.куб";
      secondUsrData = [round(shieldData.plywoodArea), round(shieldData.plywoodArea)];
      cost = round(shieldData.plywoodCost);
      listMaterials.add(
        CalculateShieldItem(
          shieldFullName: shieldData.konstrData.konstr.fullName,
          cost: cost,
          name: name,
          secondUsrData: secondUsrData,
        ),
      );
    }
    if (shieldData.sealantCost != 0) {
      name = "Герметик: %value_0 тубы";
      secondUsrData = [round(shieldData.sealantTube)];
      cost = round(shieldData.sealantCost);
      listMaterials.add(
        CalculateShieldItem(
          shieldFullName: shieldData.konstrData.konstr.fullName,
          cost: cost,
          name: name,
          secondUsrData: secondUsrData,
        ),
      );
    }
    if (shieldData.clepkingWork != 0) {
      name = "Клепки: %value_0 шт";
      secondUsrData = [round(shieldData.konstrData.konstr.clepki)];
      cost = round(shieldData.clepkingWork);
      listMaterials.add(
        CalculateShieldItem(
          shieldFullName: shieldData.konstrData.konstr.fullName,
          cost: cost,
          name: name,
          secondUsrData: secondUsrData,
        ),
      );
    }
    if (shieldData.paintCost != 0) {
      name = "Грунтовка: %value_0 кг";
      secondUsrData = [round(shieldData.paintWeight)];
      cost = round(shieldData.paintCost);
      listMaterials.add(
        CalculateShieldItem(
          shieldFullName: shieldData.konstrData.konstr.fullName,
          cost: cost,
          name: name,
          secondUsrData: secondUsrData,
        ),
      );
    }
    if (shieldData.wireCost != 0) {
      name = "Проволока СвАК5: %value_0 кг";
      secondUsrData = [round(shieldData.wireWeight)];
      cost = round(shieldData.wireCost);
      listMaterials.add(
        CalculateShieldItem(
          shieldFullName: shieldData.konstrData.konstr.fullName,
          cost: cost,
          name: name,
          secondUsrData: secondUsrData,
        ),
      );
    }
    if (shieldData.argonCost != 0) {
      name = "Аргон: %value_0м.куб";
      secondUsrData = [round(shieldData.argonMcub)];
      cost = round(shieldData.argonCost);
      listMaterials.add(
        CalculateShieldItem(
          shieldFullName: shieldData.konstrData.konstr.fullName,
          cost: cost,
          name: name,
          secondUsrData: secondUsrData,
        ),
      );
    }
    if (shieldData.square50x50Cost != 0) {
      name = "Квадрат50х50(03/0006): %value_0 м %value_1 кг";
      secondUsrData = [round(shieldData.square50x50Length), round(shieldData.square50x50Weight)];
      cost = round(shieldData.square50x50Cost);
      listMaterials.add(
        CalculateShieldItem(
          shieldFullName: shieldData.konstrData.konstr.fullName,
          cost: cost,
          name: name,
          secondUsrData: secondUsrData,
        ),
      );
    }
    if (shieldData.square20x20Cost != 0) {
      name = "Квадрат20х20(03/0001): %value_0 м %value_1 кг";
      secondUsrData = [round(shieldData.square20x20Length), round(shieldData.square20x20Weight)];
      cost = round(shieldData.square20x20Cost);
      listMaterials.add(
        CalculateShieldItem(
          shieldFullName: shieldData.konstrData.konstr.fullName,
          cost: cost,
          name: name,
          secondUsrData: secondUsrData,
        ),
      );
    }
    if (shieldData.square20x30Cost != 0) {
      name = "Квадрат20х30(05/0001): %value_0 м %value_1 кг";
      secondUsrData = [round(shieldData.square20x30Length), round(shieldData.square20x30Weight)];
      cost = round(shieldData.square20x30Cost);
      listMaterials.add(
        CalculateShieldItem(
          shieldFullName: shieldData.konstrData.konstr.fullName,
          cost: cost,
          name: name,
          secondUsrData: secondUsrData,
        ),
      );
    }
    if (shieldData.bondUniversalCost != 0) {
      name = "Связь универсальная(3272): %value_0 м %value_1 кг";
      secondUsrData = [
        round(shieldData.bondUniversalLength),
        round(shieldData.bondUniversalWeight),
      ];
      cost = round(shieldData.bondUniversalCost);
      listMaterials.add(
        CalculateShieldItem(
          shieldFullName: shieldData.konstrData.konstr.fullName,
          cost: cost,
          name: name,
          secondUsrData: secondUsrData,
        ),
      );
    }
  }

  sortMetalWork() {
    String name;
    double cost;
    if (shieldData.metalworkingCost != 0) {
      name = "Металлообработка";
      cost = round(shieldData.metalworkingCost);
      listMetalWork.add(
        CalculateShieldItem(
          shieldFullName: shieldData.konstrData.konstr.fullName,
          cost: cost,
          name: name,
        ),
      );
    }
    if (shieldData.profileCutting != 0) {
      name = "Резка профиля";
      cost = round(shieldData.profileCutting);
      listMetalWork.add(
        CalculateShieldItem(
          shieldFullName: shieldData.konstrData.konstr.fullName,
          cost: cost,
          name: name,
        ),
      );
    }
    if (shieldData.pipeCutting != 0) {
      name = "Резка трубы";
      cost = round(shieldData.pipeCutting);
      listMetalWork.add(
        CalculateShieldItem(
          shieldFullName: shieldData.konstrData.konstr.fullName,
          cost: cost,
          name: name,
        ),
      );
    }
    if (shieldData.drilling != 0) {
      name = "Сверление";
      cost = round(shieldData.drilling);
      listMetalWork.add(
        CalculateShieldItem(
          shieldFullName: shieldData.konstrData.konstr.fullName,
          cost: cost,
          name: name,
        ),
      );
    }
    if (shieldData.rolling != 0) {
      name = "Вальцовка";
      cost = round(shieldData.rolling);
      listMetalWork.add(
        CalculateShieldItem(
          shieldFullName: shieldData.konstrData.konstr.fullName,
          cost: cost,
          name: name,
        ),
      );
    }
  }

  sortMetalPrepare() {
    String name;
    double cost;
    if (shieldData.metalPreparationCost != 0) {
      name = "Металлоподготовка";
      cost = round(shieldData.metalPreparationCost);
      listMetalPrepare.add(
        CalculateShieldItem(
          shieldFullName: shieldData.konstrData.konstr.fullName,
          cost: cost,
          name: name,
        ),
      );
    }
    if (shieldData.strippingWrappings != 0) {
      name = "Зачистка обвязки";
      cost = round(shieldData.strippingWrappings);
      listMetalPrepare.add(
        CalculateShieldItem(
          shieldFullName: shieldData.konstrData.konstr.fullName,
          cost: cost,
          name: name,
        ),
      );
    }
    if (shieldData.strippingTies != 0) {
      name = "Зачистка связей";
      cost = round(shieldData.strippingTies);
      listMetalPrepare.add(
        CalculateShieldItem(
          shieldFullName: shieldData.konstrData.konstr.fullName,
          cost: cost,
          name: name,
        ),
      );
    }
    if (shieldData.flipping != 0) {
      name = "Вспомогательные";
      cost = round(shieldData.flipping);
      listMetalPrepare.add(
        CalculateShieldItem(
          shieldFullName: shieldData.konstrData.konstr.fullName,
          cost: cost,
          name: name,
        ),
      );
    }
  }

  sortWelding() {
    String name;
    double cost;
    List<double> secondUsrData = [];
    if (shieldData.weldingCost != 0) {
      name = "Сварка";
      cost = round(shieldData.weldingCost);
      listWelding.add(
        CalculateShieldItem(
          shieldFullName: shieldData.konstrData.konstr.fullName,
          cost: cost,
          name: name,
        ),
      );
    }
    if (shieldData.seams != 0) {
      name = "Швы: %value_0 шт";
      secondUsrData = [round(shieldData.seams)];
      cost =
          round(shieldData.seams * (ConstantsData.getConstById(ConstName.id_job_welding).value5!));
      listWelding.add(
        CalculateShieldItem(
          shieldFullName: shieldData.konstrData.konstr.fullName,
          cost: cost,
          name: name,
          secondUsrData: secondUsrData,
        ),
      );
    }
    if (shieldData.weldingMarking != 0) {
      name = "Разметка";
      cost = round(shieldData.weldingMarking);
      listWelding.add(
        CalculateShieldItem(
          shieldFullName: shieldData.konstrData.konstr.fullName,
          cost: cost,
          name: name,
        ),
      );
    }
  }

  sortPlywood() {
    String name;
    double cost;

    if (shieldData.plywoodingCoast != 0) {
      name = "Фанеровка";
      cost = round(shieldData.plywoodingCoast);
      listPlywood.add(
        CalculateShieldItem(
          shieldFullName: shieldData.konstrData.konstr.fullName,
          cost: cost,
          name: name,
        ),
      );
    }
    if (shieldData.seamRemoval != 0) {
      name = "Снятие швов";
      cost = round(shieldData.seamRemoval);
      listPlywood.add(
        CalculateShieldItem(
          shieldFullName: shieldData.konstrData.konstr.fullName,
          cost: cost,
          name: name,
        ),
      );
    }
    if (shieldData.unboxing != 0) {
      name = "Распиловка";
      cost = round(shieldData.unboxing);
      listPlywood.add(
        CalculateShieldItem(
          shieldFullName: shieldData.konstrData.konstr.fullName,
          cost: cost,
          name: name,
        ),
      );
    }
    if (shieldData.priming != 0) {
      name = "Грунтовка";
      cost = round(shieldData.priming);
      listPlywood.add(
        CalculateShieldItem(
          shieldFullName: shieldData.konstrData.konstr.fullName,
          cost: cost,
          name: name,
        ),
      );
    }
    if (shieldData.marking != 0) {
      name = "Разметка";
      cost = round(shieldData.marking);
      listPlywood.add(
        CalculateShieldItem(
          shieldFullName: shieldData.konstrData.konstr.fullName,
          cost: cost,
          name: name,
        ),
      );
    }
    if (shieldData.drillingUnderClepki != 0) {
      name = "Сверление под клепку";
      cost = round(shieldData.drillingUnderClepki);
      listPlywood.add(
        CalculateShieldItem(
          shieldFullName: shieldData.konstrData.konstr.fullName,
          cost: cost,
          name: name,
        ),
      );
    }
    if (shieldData.clepkingWork != 0) {
      name = "Клепание";
      cost = round(shieldData.clepkingWork);
      listPlywood.add(
        CalculateShieldItem(
          shieldFullName: shieldData.konstrData.konstr.fullName,
          cost: cost,
          name: name,
        ),
      );
    }
    if (shieldData.applyingsealant != 0) {
      name = "Нанесение герметика";
      cost = round(shieldData.applyingsealant);
      listPlywood.add(
        CalculateShieldItem(
          shieldFullName: shieldData.konstrData.konstr.fullName,
          cost: cost,
          name: name,
        ),
      );
    }
    if (shieldData.additionalOperation != 0) {
      name = "Доп. операции";
      cost = round(shieldData.additionalOperation);
      listPlywood.add(
        CalculateShieldItem(
          shieldFullName: shieldData.konstrData.konstr.fullName,
          cost: cost,
          name: name,
        ),
      );
    }
  }

  sortOverheadCost() {
    String name;
    double cost;

    if (shieldData.overheadCosts != 0) {
      name = "Накладные расходы";
      cost = round(shieldData.overheadCosts);
      listOverheadCost.add(
        CalculateShieldItem(
          shieldFullName: shieldData.konstrData.konstr.fullName,
          cost: cost,
          name: name,
        ),
      );
    }
    if (shieldData.transport != 0) {
      name = "Транспорт";
      cost = round(shieldData.transport);
      listOverheadCost.add(
        CalculateShieldItem(
          shieldFullName: shieldData.konstrData.konstr.fullName,
          cost: cost,
          name: name,
        ),
      );
    }
    if (shieldData.wasteReturn != 0) {
      name = "Возврат отходов";
      cost = round(shieldData.wasteReturn);
      listOverheadCost.add(
        CalculateShieldItem(
          shieldFullName: shieldData.konstrData.konstr.fullName,
          cost: cost,
          name: name,
        ),
      );
    }
    if (shieldData.unifiedSocialTax != 0) {
      name = "ЕСН";
      cost = round(shieldData.unifiedSocialTax);
      listOverheadCost.add(
        CalculateShieldItem(
          shieldFullName: shieldData.konstrData.konstr.fullName,
          cost: cost,
          name: name,
        ),
      );
    }
    if (shieldData.holidays != 0) {
      name = "Отпускные";
      cost = round(shieldData.holidays);
      listOverheadCost.add(
        CalculateShieldItem(
          shieldFullName: shieldData.konstrData.konstr.fullName,
          cost: cost,
          name: name,
        ),
      );
    }
    if (shieldData.electricity != 0) {
      name = "Энергия";
      cost = round(shieldData.electricity);
      listOverheadCost.add(
        CalculateShieldItem(
          shieldFullName: shieldData.konstrData.konstr.fullName,
          cost: cost,
          name: name,
        ),
      );
    }
    if (shieldData.generalProduction != 0) {
      name = "Общепроизводственные";
      cost = round(shieldData.generalProduction);
      listOverheadCost.add(
        CalculateShieldItem(
          shieldFullName: shieldData.konstrData.konstr.fullName,
          cost: cost,
          name: name,
        ),
      );
    }
  }

  sortCostPrice() {
    String name;
    double cost;
    if (shieldData.costPriceWithVAT != 0) {
      name = "Себестоимость с НДС";
      cost = round(shieldData.costPriceWithVAT);
      listCostPrice.add(
        CalculateShieldItem(
          shieldFullName: shieldData.konstrData.konstr.fullName,
          cost: cost,
          name: name,
        ),
      );
    }
    if (shieldData.costPriceWithoutVAT != 0) {
      name = "Себестоимость без НДС";
      cost = round(shieldData.costPriceWithoutVAT);
      listCostPrice.add(
        CalculateShieldItem(
          shieldFullName: shieldData.konstrData.konstr.fullName,
          cost: cost,
          name: name,
        ),
      );
    }
  }
}
