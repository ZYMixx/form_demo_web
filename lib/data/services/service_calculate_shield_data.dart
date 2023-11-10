import 'dart:math';

import 'package:form_demo_web/data/services/service_konstr_data_builder.dart';
import 'package:form_demo_web/data/services/service_sort_calculate_data.dart';
import 'package:form_demo_web/domain/constant_entity.dart';
import 'package:form_demo_web/domain/db_form_entity/konstr_form.dart';

class ServiceCalculateShieldData {
  /// Вычесления удалены
  /// большенство значений заменены на рандомные

  ServiceKonstrData konstrData;
  KonstrForm konstrForm;

  double costPriceWithVAT = getRandomDouble(100), costPriceWithoutVAT = getRandomDouble(100);

  double square50x50Length = getRandomDouble(100),
      square50x50Weight = getRandomDouble(100),
      square50x50Cost = getRandomDouble(100),
      square20x20Length = getRandomDouble(100),
      square20x20Weight = getRandomDouble(100),
      square20x20Cost = getRandomDouble(100),
      square20x30Length = getRandomDouble(100),
      square20x30Weight = getRandomDouble(100),
      square20x30Cost = getRandomDouble(100),
      pipe28x3 = getRandomDouble(100),
      pipe28x3Cost = getRandomDouble(100),
      squareCutting = getRandomDouble(100);

  //binding - обвязка
  double bindingLength = getRandomDouble(100),
      bindingWeight = getRandomDouble(100),
      costBinding = getRandomDouble(100),
      boxLength = getRandomDouble(100),
      boxWeight = getRandomDouble(100),
      boxCost = getRandomDouble(100),
      pipe28Length = getRandomDouble(100),
      pipe28Weight = getRandomDouble(100),
      pipe28Cost = getRandomDouble(100),
      pipe25Length = getRandomDouble(100),
      pipe25Weight = getRandomDouble(100),
      pipe25Cost = getRandomDouble(100),
      tire5x40Length = getRandomDouble(100),
      tire5x40Weight = getRandomDouble(100),
      tire5x40Cost = getRandomDouble(100),
      metalWeight = getRandomDouble(100),
      metalCost = getRandomDouble(100),
      materialsCost = getRandomDouble(100);
  double circleCT20Length = getRandomDouble(100),
      circleCT20Weight = getRandomDouble(100),
      circleCT20Cost = getRandomDouble(100);

  // plywood = фанеровка
  double plywoodArea = getRandomDouble(100),
      plywoodCost = getRandomDouble(100),
      sealantTube = getRandomDouble(100),
      sealantCost = getRandomDouble(100),
      clipkiCost = getRandomDouble(100),
      paintWeight = getRandomDouble(100),
      paintCost = getRandomDouble(100),
      wireWeight = getRandomDouble(100),
      wireCost = getRandomDouble(100),
      argonMcub = getRandomDouble(100),
      argonCost = getRandomDouble(100),
      bondUniversalLength = getRandomDouble(100),
      bondUniversalWeight = getRandomDouble(100),
      bondUniversalCost = getRandomDouble(100);

  //Metalworking
  double profileCutting = getRandomDouble(100),
      pipeCutting = getRandomDouble(100),
      drilling = getRandomDouble(100),
      rolling = getRandomDouble(100),
      metalworkingCost = getRandomDouble(100);

  //Metal preparation
  double strippingWrappings = getRandomDouble(100),
      strippingTies = getRandomDouble(100),
      flipping = getRandomDouble(100),
      metalPreparationCost = getRandomDouble(100);

  //Welding - сварка
  late double seams = getRandomDouble(100),
      weldingCost = getRandomDouble(100),
      weldingMarking = getRandomDouble(100);

  // Veneer - Шпон
  late double seamRemoval = getRandomDouble(100),
      unboxing = getRandomDouble(100),
      priming = getRandomDouble(100),
      marking = getRandomDouble(100),
      drillingUnderClepki = getRandomDouble(100),
      clepkingWork = getRandomDouble(100),
      applyingsealant = getRandomDouble(100),
      additionalOperation = getRandomDouble(100),
      plywoodingCoast = getRandomDouble(100);

  //Overheads - накладные расходы
  late double transport = getRandomDouble(100),
      wasteReturn = getRandomDouble(100),
      unifiedSocialTax = getRandomDouble(100),
      holidays = getRandomDouble(100),
      electricity = getRandomDouble(100),
      overheadCosts = getRandomDouble(100),
      generalProduction = getRandomDouble(100);

  int balci = getRandomInt(4);

  int get LO => konstrData.konstr.getLO();

  int get TO => konstrData.konstr.getTO();

  late double normaTruAl;

  ServiceCalculateShieldData(
      {required this.konstrForm, required int width, int? secondWidth, required int clepkiCount})
      : konstrData = ServiceKonstrData(
          ConstantEntity(
            konstrForm: konstrForm,
            width: width,
            clepki: clepkiCount,
            widthSecond: secondWidth ?? 0,
          ),
        );

  calculateAll() {
    calculateBalci();
    calculateSeams();
    materials();
    metalworking();
    welding();
    plywooding();
    lastCalculate();
    print('END CCCALCULATE');
    ServiceSortCalculateData(this);
  }

  calculateBalci() {
    if (balci == 0) {
      balci = 2;
    }
    if (konstrData.haveSecondWidth) {
      balci = 4;
    }
  }

  materials() {
    // удалено ...
  }

  calculateSeams() {
    double seamsOne = getRandomDouble(10),
        seamsTwo = getRandomDouble(10),
        seamsThird = getRandomDouble(10),
        seamsFore = getRandomDouble(10);

    // удалено ...

    seamsThird = (konstrData.konstr.getLO() + konstrData.konstr.getTO()) * 2;
    seams = seamsOne + seamsTwo + seamsThird + seamsFore;
  }

  metalworking() {
    // удалено ...
    metalworkingCost = profileCutting + pipeCutting + drilling + rolling;
  }

  welding() {
    // удалено ...
  }

  plywooding() {
    // удалено ...
    plywoodingCoast = seamRemoval +
        unboxing +
        priming +
        marking +
        drillingUnderClepki +
        clepkingWork +
        applyingsealant +
        additionalOperation;
  }

  lastCalculate() {
    metalWeight = bindingWeight +
        boxWeight +
        pipe25Weight +
        pipe28Weight +
        square20x20Weight +
        square20x30Weight +
        square50x50Weight +
        bondUniversalWeight +
        tire5x40Weight +
        circleCT20Weight +
        paintWeight;
    metalCost = boxCost +
        costBinding +
        pipe25Cost +
        pipe28Cost +
        bondUniversalCost +
        square50x50Cost +
        square20x20Cost +
        square20x30Cost +
        tire5x40Cost +
        circleCT20Cost;
    materialsCost =
        sealantCost + argonCost + plywoodCost + paintCost + wireCost + clipkiCost + metalCost;
  }

  static double getRandomDouble(int max) {
    return Random().nextDouble() * max;
  }

  static int getRandomInt(int max) {
    return Random().nextInt(max);
  }
}
