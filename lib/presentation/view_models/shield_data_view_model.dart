import 'package:flutter/cupertino.dart';
import 'package:form_demo_web/data/services/service_calculate_shield_data.dart';
import 'package:form_demo_web/data/services/service_sort_calculate_data.dart';
import 'package:form_demo_web/data/tools/tool_widget.dart';
import 'package:form_demo_web/domain/db_form_entity/konstr_form.dart';
import 'package:form_demo_web/presentation/shield_screen/left_block_work_widgets/shield_data_builder.dart';
import 'package:form_demo_web/presentation/shield_screen/shield_calculate_data_expansion_panel.dart';
import 'package:form_demo_web/presentation/view_models/abstract_work_view_model.dart';

import '../../data/repository/repository_form_database.dart';

class ShieldDataViewModel extends AbstractWorkViewModel with CopyableDataInterface {
  static ShieldDataViewModel get instance => _instance ??= ShieldDataViewModel();
  static ShieldDataViewModel? _instance;

  @override
  String get name => 'Щит';

  Widget leftScreenWidget = ToolWidget.noDataTextWidget;
  Widget rightTopScreenWidget = ToolWidget.noDataTextWidget;
  Widget rightBottomScreenWidget = ToolWidget.noDataTextWidget;
  bool haveSecondWidth = false;

  KonstrForm? konstrForm;
  int? shieldHeight;
  int? width;
  int? widthSecond;
  int? clepkiCount;
  int? userClepkiCount;
  String? tip;

  bool? isOrdered;

  ServiceSortCalculateData? sortCalculateData;
  RepositoryFormDataBase repositoryShield = RepositoryFormDataBase();

  ShieldDataViewModel() {
    if (_instance != null) {
      print("pls dont create second ShieldDataViewModel, use instance");
      return;
    }
  }

  orderDataList() {
    if (sortCalculateData != null) {
      copyList = null;
      isOrdered != null ? isOrdered = !isOrdered! : isOrdered = true;
      for (var list in sortCalculateData!.listAllSortCalculateData) {
        if (isOrdered!) {
          list.sort((a, b) => b.cost.compareTo(a.cost));
        } else {
          list.sort((a, b) => a.cost.compareTo(b.cost));
        }
        var max = list.reduce((a, b) => a.cost > b.cost ? a : b);
        list.remove(max);
        list.insert(0, max);
      }
    }
    notifyListeners();
  }

  setKonstrForm(KonstrForm? userKonstrForm) {
    konstrForm = userKonstrForm;
    setShieldHeight(konstrForm?.height);
  }

  setShieldHeight(int? userHeight) {
    shieldHeight = userHeight;
    if (shieldHeight == null) {
      width = null;
      widthSecond = null;
      konstrForm = null;
      clepkiCount = null;
    }
    notifyListeners();
  }

  setShieldTip(String? userTip) {
    tip = userTip;
    if (tip == null) {
      shieldHeight = null;
      width = null;
      widthSecond = null;
      konstrForm = null;
      clepkiCount = null;
    } else {
      haveSecondWidth = repositoryShield.cheekDoubleWidthFromConst(tip!);
    }
    notifyListeners();
  }

  resetData() {
    tip = null;
    shieldHeight = null;
    width = null;
    widthSecond = null;
    clepkiCount = null;
    konstrForm = null;
    sortCalculateData = null;
    notifyListeners();
  }

  resetWidth() {
    width = null;
    clepkiCount = null;
    notifyListeners();
  }

  resetSecondWidth() {
    widthSecond = null;
    clepkiCount = null;
    notifyListeners();
  }

  resetUserClepkiCount() {
    userClepkiCount = null;
  }

  onWidthChangeListener(String userWidth) async {
    if (width == null) {
      width = int.parse(userWidth);
      notifyListeners();
    } else {
      width = int.parse(userWidth);
    }
    cheakClipkiOnExist();
  }

  onSecondWidthChangeListener(String userWidth) async {
    if (widthSecond == null) {
      widthSecond = int.parse(userWidth);
      notifyListeners();
    } else {
      widthSecond = int.parse(userWidth);
    }
    cheakClipkiOnExist();
  }

  onUserClepkiChangeListener(String userWidth) async {
    userClepkiCount = int.parse(userWidth);
  }

  bool isFullUserData() {
    if (!haveSecondWidth) {
      return (width != null && shieldHeight != null && tip != null);
    } else {
      return (width != null && shieldHeight != null && tip != null && widthSecond != null);
    }
  }

  cheakClipkiOnExist() async {
    //
    //// Изменён для WEB версии ...
    //
    sortCalculateData = null;
    if (isFullUserData()) {
      clepkiCount = 8;
    }
    if (konstrForm != null && width != null && clepkiCount != null) {
      startCalculate();
    }
    notifyListeners();
  }

  Future<List<String>> getAllKonstTip() async {
    List<String> list = await repositoryShield.getAllKonstTip();
    return list;
  }

  Future<List<KonstrForm>> getAllKonstByTip() async {
    if (tip != null) {
      List<KonstrForm> list = await repositoryShield.getAllKonstByTip(tip!);
      list.sort((a, b) => b.height.compareTo(a.height));
      return list;
    }
    return [];
  }

  insertNewClipki() async {
    await repositoryShield.insertIntoClipki(
        tip: tip!, h: shieldHeight!, w: width!, clepki: userClepkiCount!);
    cheakClipkiOnExist();
  }

  startCalculate() {
    print('START CALCULATE');

    var calculateShieldData = ServiceCalculateShieldData(
        konstrForm: konstrForm!,
        width: width!,
        secondWidth: widthSecond,
        clepkiCount: clepkiCount!);

    calculateShieldData.calculateAll();
    sortCalculateData = ServiceSortCalculateData(calculateShieldData);
  }

  @override
  Widget buildDefaultRightWidget() {
    return const ShieldCalculateDataExpansionPanel();
  }

  @override
  Widget buildDefaultLeftWidget() {
    return const ShieldDataBuilder();
  }

  @override
  void selfDispose() {
    _instance = null;
    super.dispose();
  }

  @override
  Widget buildDefaultSingleWidget() {
    return Text("Eror");
  }

  List<List<String>>? copyList;

  @override
  List<List<String>>? getCopyableDataList() {
    sortCalculateData!.listAllSortCalculateData;
    if (copyList == null) {
      copyList = [];
      for (var list in sortCalculateData!.listAllSortCalculateData) {
        for (var item in list) {
          copyList!.add(['${item.title}', '${item.cost}']);
        }
      }
      return copyList;
    } else {
      return copyList;
    }
  }

  @override
  List<String>? getCopyableTitleList() {
    return ['Позиция', 'Стоимость/руб'];
  }
}
