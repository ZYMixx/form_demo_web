import 'package:form_demo_web/data/services/service_calculate_shield_data.dart';
import 'package:form_demo_web/data/services/service_history.dart';
import 'package:form_demo_web/data/services/service_specif_sort_calculate_data.dart';
import 'package:form_demo_web/data/tools/tool_show_toast.dart';
import 'package:form_demo_web/domain/db_form_entity/konstr_form.dart';
import 'package:form_demo_web/presentation/global_single_widgets/bookmark_widget.dart';
import 'package:form_demo_web/presentation/specification_screen/right_choose_shield_input_screen.dart';
import 'package:form_demo_web/presentation/specification_screen/shield_specification_data_builder.dart';
import 'package:form_demo_web/presentation/view_models/result_specif_calclulate_view_model.dart';
import 'package:form_demo_web/presentation/view_models/shield_data_view_model.dart';
import 'package:form_demo_web/presentation/view_models/work_space_view_model.dart';

class SpecificationViewModel extends ShieldDataViewModel {
  static SpecificationViewModel get instance => _instance ??= SpecificationViewModel();
  static SpecificationViewModel? _instance;

  @override
  String get name => 'Спецификация';

  bool readyAddShield = false;
  bool calculateButtonPressed = false;
  bool needUpdate = false;

  List<ServiceCalculateShieldData> listUserAddedShieldData = [];
  Map<String, String?> mapUserShieldInputData = {};

  int get listAddedShieldSize => listUserAddedShieldData.length;

  SpecificationViewModel() {
    if (_instance != null) {
      throw ("pls dont create second SpecificationViewModel, use instance");
    }
  }

  @override
  buildDefaultLeftWidget() {
    return const ShieldSpecificationDataBuilder();
  }

  @override
  buildDefaultRightWidget() {
    return const RightChooseShieldInputScreen();
  }

  @override
  startCalculate() {
    var calculateShieldData = ServiceCalculateShieldData(
      konstrForm: konstrForm!,
      width: width!,
      secondWidth: widthSecond,
      clepkiCount: clepkiCount!,
    );
    calculateShieldData.calculateAll();
    readyAddShield = !isShieldDuplicate(calculateShieldData);
    notifyListeners();
  }

  bool isShieldDuplicate(ServiceCalculateShieldData calculateShieldData) {
    for (var item in listUserAddedShieldData) {
      if (item.konstrData.konstr.fullName == calculateShieldData.konstrData.konstr.fullName) {
        return true;
      }
    }
    return false;
  }

  saveShieldUserInput(String fullName, String count) {
    mapUserShieldInputData[fullName] = count;
  }

  removeAddedShield(ServiceCalculateShieldData shield) {
    listUserAddedShieldData.remove(shield);
    mapUserShieldInputData.remove(shield.konstrData.konstr.fullName);
    notifyListeners();
  }

  onCalculationPressed() {
    if (mapUserShieldInputData.isEmpty) {
      ToolShowToast.showError('Ничего не выбрано');
      return;
    }
    for (var item in mapUserShieldInputData.values) {
      if (haveInputError(item)) {
        calculateButtonPressed = true;
        needUpdate = !needUpdate;
        notifyListeners();
        return;
      }
    }
    createCalculateData();
  }

  bool haveInputError(String? userInput) {
    if (userInput == "" || userInput == null || userInput[0] == "0") {
      return true;
    }
    return false;
  }

  createCalculateData() {
    List<ServiceSpecifSortCalculateData> list = [];
    for (var shield in listUserAddedShieldData) {
      int count = int.parse(mapUserShieldInputData[shield.konstrData.konstr.fullName]!);
      var sortSpecifCalculateData = ServiceSpecifSortCalculateData(shield, count);
      list.add(sortSpecifCalculateData);
    }
    var resultSpecifVM = ResultSpecifCalculateViewModel(listCalculateData: list);
    WorkSpaceViewModel.instance.addBookMark(BookmarkWidget(viewModel: resultSpecifVM));
    saveHistory();
  }

  saveHistory() async {
    if (listUserAddedShieldData.isEmpty || mapUserShieldInputData.isEmpty) {
      print('попытка сохранить пустые масивы');
      return;
    }
    List<Map<String, dynamic>> listMap = [];
    for (var item in listUserAddedShieldData) {
      Map<String, dynamic> map = createHistoryData(
        item,
        int.parse(mapUserShieldInputData[item.konstrData.konstr.fullName]!),
      );
      listMap.add(map);
      map = {};
    }
    ServiceHistory.addInSpecificationHistory(listMap);
  }

  Map<String, dynamic> createHistoryData(ServiceCalculateShieldData dataItem, int count) {
    Map<String, dynamic> map = {};
    map['id'] = dataItem.konstrForm.id;
    map['width'] = dataItem.konstrData.konstr.width;
    map['second_width'] = dataItem.konstrData.konstr.widthSecond;
    map['clipki'] = dataItem.konstrData.konstr.clepki;
    map['fullName'] = dataItem.konstrData.konstr.fullName;
    map['dateTime'] = DateTime.now().toString().substring(2, 16);
    map['count'] = count;
    return map;
  }

  loadFromHistory(List<Map<String, dynamic>> listMap) async {
    listUserAddedShieldData = [];
    mapUserShieldInputData = {};
    for (var shieldMap in listMap) {
      KonstrForm konstrForm = await repositoryShield.getKonstrById(shieldMap['id'] as int);
      int width = shieldMap['width'];
      int? secondWidth = shieldMap['second_width'] == '' ? null : shieldMap['second_width'];
      int clepkiCount = shieldMap['clipki'];
      String fullName = shieldMap['fullName'];
      int count = shieldMap['count'];

      ServiceCalculateShieldData historyCalculateData = ServiceCalculateShieldData(
        konstrForm: konstrForm,
        width: width,
        secondWidth: secondWidth,
        clepkiCount: clepkiCount,
      );
      historyCalculateData.calculateAll();

      listUserAddedShieldData.add(historyCalculateData);
      mapUserShieldInputData['$fullName'] = '$count';
    }
  }

  onAddShieldPressed() {
    calculateButtonPressed = false;
    readyAddShield = false;
    var calculateShieldData = ServiceCalculateShieldData(
      konstrForm: konstrForm!,
      width: width!,
      secondWidth: widthSecond,
      clepkiCount: clepkiCount!,
    );
    calculateShieldData.calculateAll();
    listUserAddedShieldData.add(calculateShieldData);
    mapUserShieldInputData[calculateShieldData.konstrData.konstr.fullName] = null;
    notifyListeners();
  }

  resetSpecificationData() {
    readyAddShield = false;
    calculateButtonPressed = false;
    needUpdate = false;
    listUserAddedShieldData = [];
    mapUserShieldInputData = {};
  }

  @override
  void selfDispose() {
    _instance = null;
    super.dispose();
  }
}

class SpecifCalcItem {
  String title;
  ServiceCalculateShieldData calculateData;
  int count;

  SpecifCalcItem({
    required this.title,
    required this.calculateData,
    required this.count,
  });
}
