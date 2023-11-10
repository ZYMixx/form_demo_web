import 'package:flutter/material.dart';
import 'package:form_demo_web/data/repository/repository_constants_data.dart';
import 'package:form_demo_web/data/repository/repository_form_database.dart';
import 'package:form_demo_web/data/repository/repository_work_bd.dart';
import 'package:form_demo_web/data/tools/tool_navigator.dart';
import 'package:form_demo_web/data/tools/tool_show_toast.dart';
import 'package:form_demo_web/domain/db_form_entity/bracket_form.dart';
import 'package:form_demo_web/domain/db_form_entity/db_entity_form_abstr.dart';
import 'package:form_demo_web/domain/db_form_entity/products_form.dart';
import 'package:form_demo_web/domain/db_form_entity/products_work_form.dart';
import 'package:form_demo_web/domain/db_form_entity/trenoga_form.dart';
import 'package:form_demo_web/domain/form_table_type_enum.dart';
import 'package:form_demo_web/domain/table_show_enum.dart';
import 'package:form_demo_web/presentation/App.dart';
import 'package:form_demo_web/presentation/my_widgets/my_accept_action_screen.dart';
import 'package:form_demo_web/presentation/table_screen/settings_table_data_screen.dart';
import 'package:form_demo_web/presentation/table_screen/table_choose_title_left_screen.dart';
import 'package:form_demo_web/presentation/view_models/abstract_work_view_model.dart';

class TableViewModel extends AbstractWorkViewModel with CopyableDataInterface {
  static TableViewModel get instance => _instance ??= TableViewModel();
  static TableViewModel? _instance;

  @override
  String get name => 'Таблицы';

  RepositoryFormDataBase repositoryFormDB = RepositoryFormDataBase();
  RepositoryWorkBD repositoryWorkBD = RepositoryWorkBD();

  static List<String> tableTitleMaterial = ['Материалы'];
  static List<String> tableTitleWorkAndOther = ['Работа', 'Другое'];

  Set<String> get tableTitleConstrShields => ConstantsData.listConst
      .where((element) => element.subKey == 'тип')
      .map((e) => e.value ?? 'null value')
      .toSet();
  static List<String> tableTitleSpecWork = [
    'Работники',
    'Продукция',
    'Работы по продукции',
  ];
  static List<String> tableTitleShields = ['Клёпки', 'Типы'];

  static List<String> tableTitleBracket = [
    'Материалы.',
    'Работы.',
    'Другие затраты.',
    'Пропорции.',
  ]; //кастыль для одинаковых названий [.]
  static List<String> tableTitleTrenoga = [
    'Материалы*',
    'Работы*',
    'Другие затраты*',
    'Пропорции*',
  ]; //кастыль для одинаковых названий [*]
  String? titleSelected;

  final List<bool> expansionIsOpen = [];
  Map<String, List<String>> mapExpansionData = {};

  List<List<String>>? copyDataListOfList;
  List<String>? copyTitleList;

  List<BdFormEntityAbstr>? listSelectedDBItems;
  List<BdFormEntityAbstr>? firstTimeListSelectedDBItems;
  TableShowEnum? _tableShowEnum;
  FormTableTypeEnum? _formTableTypeEnum;
  String? tablePanelFilterMapKey;

  Map<String, TableSetting>? get mapTableShowEnum => _tableShowEnum?.getColumnName();

  bool? get isCanAddNew => _tableShowEnum?.getIsCanAddNew();
  String? selectedItemName;
  Map insertMap = {};
  Map<String, String> mapGroupFieldInputValue = {};
  Map<String, bool> mapIsGroupInFocus = {};

  Map<String, bool?> dataOrderKey = {'null': null};
  Map<String, bool> userInputErrorMap = {};
  Map<String, Function> mapUpdateCommand = {};
  Map<int, Function> mapRemoveCommand = {};

  TableViewModel() {
    print('MEEEEEEEEE WASSSSSSSSSSSSSSSS COOOOOLK');
    aggregateExpansionData();
    if (_instance != null) {
      throw ('pls dont create second TableViewModel, use instance');
    }
  }

  chaneSelectedDBTable(String title) async {
    tablePanelFilterMapKey = null;
    if (tableTitleMaterial.contains(title)) {
      _tableShowEnum = TableShowEnum.productsMaterialsConst;
      _formTableTypeEnum = FormTableTypeEnum.productsMaterialsForm;
      listSelectedDBItems =
          await ConstantsData.selectAllByFormType(FormTableTypeEnum.productsMaterialsForm);
    } else if (tableTitleWorkAndOther.contains(title)) {
      _tableShowEnum = TableShowEnum.otherConst;
      title == 'Другое' ? title = 'Остальное' : {};
      _formTableTypeEnum = FormTableTypeEnum.constantsForm;
      listSelectedDBItems = await ConstantsData.getConstListBySubKey(title);
    } else if (tableTitleConstrShields.contains(title)) {
      _tableShowEnum = TableShowEnum.shieldsType;
      _formTableTypeEnum = FormTableTypeEnum.konstrForm;
      listSelectedDBItems = await repositoryFormDB.getAllKonstByTip(title);
    } else if (tableTitleSpecWork.contains(title)) {
      if (title == 'Работники') {
        _tableShowEnum = TableShowEnum.rabotniki;
        _formTableTypeEnum = FormTableTypeEnum.rabotniki;
        listSelectedDBItems = await ConstantsData.selectAllByFormType(FormTableTypeEnum.rabotniki);
      }
      if (title == 'Продукция') {
        _tableShowEnum = TableShowEnum.products;
        _formTableTypeEnum = FormTableTypeEnum.products;
        listSelectedDBItems = await ConstantsData.selectAllByFormType(FormTableTypeEnum.products);
      }
      if (title == 'Работы по продукции') {
        _tableShowEnum = TableShowEnum.productsWork;
        tablePanelFilterMapKey = 'productName';
        _formTableTypeEnum = FormTableTypeEnum.productsWork;
        List<ProductsWork> productsWorkList =
            await ConstantsData.selectAllByFormType(FormTableTypeEnum.productsWork);
        List<ProductsForm> productsList =
            await ConstantsData.selectAllByFormType<ProductsForm>(FormTableTypeEnum.products);
        for (var item in productsWorkList) {
          item.productName = productsList
              .firstWhere((element) => element.id == int.parse(item.productId ?? '0'))
              .product;
        }
        listSelectedDBItems = productsWorkList;
      }
    } else if (tableTitleBracket.contains(title)) {
      if (title == 'Материалы.') {
        _formTableTypeEnum = FormTableTypeEnum.bracket;
        _tableShowEnum = TableShowEnum.bracketMaterials;
        listSelectedDBItems = await repositoryWorkBD.selectAllBracketByType(
          formTableType: FormTableTypeEnum.bracket,
          targetValue: BracketTypeEnum.material.name,
        );
      }
      if (title == 'Работы.') {
        _formTableTypeEnum = FormTableTypeEnum.bracket;
        _tableShowEnum = TableShowEnum.bracketSalary;
        listSelectedDBItems = await repositoryWorkBD.selectAllBracketByType(
          formTableType: FormTableTypeEnum.bracket,
          targetValue: BracketTypeEnum.salaryWork.name,
        );
      }
      if (title == 'Другие затраты.') {
        _formTableTypeEnum = FormTableTypeEnum.bracket;
        _tableShowEnum = TableShowEnum.bracketOtherCost;
        listSelectedDBItems = await repositoryWorkBD.selectAllBracketByType(
          formTableType: FormTableTypeEnum.bracket,
          targetValue: BracketTypeEnum.otherCost.name,
        );
      }
      if (title == 'Пропорции.') {
        _formTableTypeEnum = FormTableTypeEnum.bracketSpend;
        _tableShowEnum = TableShowEnum.bracketSpendForm;
        listSelectedDBItems =
            await ConstantsData.selectAllByFormType(FormTableTypeEnum.bracketSpend);
      }
    } else if (tableTitleTrenoga.contains(title)) {
      if (title == 'Материалы*') {
        _formTableTypeEnum = FormTableTypeEnum.trenoga;
        _tableShowEnum = TableShowEnum.trenogaMaterials;
        listSelectedDBItems = await repositoryWorkBD.selectAllBracketByType(
          formTableType: FormTableTypeEnum.trenoga,
          targetValue: TrenogaTypeEnum.material.name,
        );
      }
      if (title == 'Работы*') {
        _formTableTypeEnum = FormTableTypeEnum.trenoga;
        _tableShowEnum = TableShowEnum.trenogaSalary;
        listSelectedDBItems = await repositoryWorkBD.selectAllTrenogaByType(
          formTableType: FormTableTypeEnum.trenoga,
          targetValue: TrenogaTypeEnum.salaryWork.name,
        );
      }
      if (title == 'Другие затраты*') {
        _formTableTypeEnum = FormTableTypeEnum.trenoga;
        _tableShowEnum = TableShowEnum.trenogaOtherCost;
        listSelectedDBItems = await repositoryWorkBD.selectAllTrenogaByType(
          formTableType: FormTableTypeEnum.trenoga,
          targetValue: TrenogaTypeEnum.otherCost.name,
        );
      }
      if (title == 'Пропорции*') {
        _formTableTypeEnum = FormTableTypeEnum.trenogaSpend;
        _tableShowEnum = TableShowEnum.trenogaSpendForm;
        listSelectedDBItems =
            await ConstantsData.selectAllByFormType(FormTableTypeEnum.trenogaSpend);
      }
    } else if (tableTitleShields.contains(title)) {
      if (title == 'Клёпки') {
        _formTableTypeEnum = FormTableTypeEnum.clepkiForm;
        _tableShowEnum = TableShowEnum.clepki;
        tablePanelFilterMapKey = 'tip';
        listSelectedDBItems = await ConstantsData.getAllClepki();
      }
      if (title == 'Типы') {
        _formTableTypeEnum = FormTableTypeEnum.constantsForm;
        _tableShowEnum = TableShowEnum.shieldsWidthType;
        listSelectedDBItems = await ConstantsData.getConstListBySubKey('тип');
      }
    } else {}
    if (titleSelected != title) {
      firstTimeListSelectedDBItems = listSelectedDBItems;
    }
    titleSelected = title;

    notifyListeners();
  }

  aggregateExpansionData() {
    if (mapExpansionData.isEmpty) {
      mapExpansionData['Констатнты'] = []
        ..addAll(TableViewModel.tableTitleMaterial)
        ..addAll(TableViewModel.tableTitleWorkAndOther);
      mapExpansionData['Конструктив'] = tableTitleConstrShields.toList();
      mapExpansionData['Работы'] = TableViewModel.tableTitleSpecWork;
      mapExpansionData['Кронштейн'] = TableViewModel.tableTitleBracket;
      mapExpansionData['Тренога'] = TableViewModel.tableTitleTrenoga;
      mapExpansionData['Щиты'] = TableViewModel.tableTitleShields;
      for (var i = 0; i < mapExpansionData.length; i++) {
        expansionIsOpen.add(false);
      }
    }
  }

  buildRemoveCommand({required int itemID}) {
    if (_formTableTypeEnum != null) {
      mapRemoveCommand[itemID] = () => repositoryFormDB.removeItemFromDB(
            tableName: _formTableTypeEnum!.getDbTableName(),
            itemID: itemID,
          );
    }
    mapRemoveCommand[itemID]?.call();
  }

  removeRemoveCommand({required int itemID}) {
    if (_formTableTypeEnum != null) {
      mapRemoveCommand.remove(itemID);
    }
  }

  buildInputCommand({required dynamic value, required String columnKey, required int itemID}) {
    if (_formTableTypeEnum != null) {
      mapUpdateCommand['$itemID$columnKey'] = () => repositoryFormDB.updateDataBaseData(
            tableName: _formTableTypeEnum!.getDbTableName(),
            value: value,
            columnKey: columnKey,
            itemID: itemID,
          );
    }
  }

  resetInsertDbMap() {
    insertMap = {};
  }

  updateInsertDbMap({required String mapKey, required String mapData}) {
    insertMap[mapKey] = '\'$mapData\'';
  }

  onInsertButtonPressed() async {
    for (var key in insertMap.keys) {
      if (insertMap[key] == '\'\'' && getCanBeNullByDbKey(key)) {
        ToolShowToast.showError('заполните все обязательные поля');
        return false;
      }
    }
    for (var key in insertMap.keys) {
      if (insertMap[key] == '\'\'') {
        insertMap[key] = 'NULL';
      }
    }
    Future<bool> success = repositoryFormDB.insertItemInDBFromMap(
      map: insertMap,
      dbTableName: _formTableTypeEnum?.getDbTableName() ?? '',
    );
    ToolNavigator.pop();
    if (await success == true) {
      ConstantsData.reLoadAllDataBaseData();
      ToolShowToast.show('Новые данные успешно добавлены');
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (titleSelected != null) {
        onTitleItemPressed(titleSelected!);
      }
    });
  }

  Type getFieldTypeByDbKey(String dbKey) {
    try {
      return _tableShowEnum!.getColumnName()[dbKey]!.type;
    } catch (e) {
      ToolNavigator.pop();
      ToolShowToast.showError(e.toString());
    }
    return int;
  }

  bool getCanBeNullByDbKey(String dbKey) {
    try {
      return _tableShowEnum!.getColumnName()[dbKey]!.canBeNull;
    } catch (e) {
      ToolNavigator.pop();
      ToolShowToast.showError(e.toString());
    }
    return false;
  }

  addUserInputError({required String key, required bool isError}) {
    userInputErrorMap[key] = isError;
  }

  removeInputCommand({required int itemID}) {
    if (_formTableTypeEnum != null) {
      mapUpdateCommand.remove(itemID);
    }
  }

  putGroupFieldInputValue({required String groupKey, required String newText}) {
    mapGroupFieldInputValue[groupKey] = newText;
    notifyListeners();
  }

  putIsGroupInFocusValue({required String groupKey, required bool isInFocus}) {
    mapIsGroupInFocus[groupKey] = isInFocus;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      notifyListeners();
    });
  }

  onSaveAllButtonPressed() async {
    for (var inputError in userInputErrorMap.values) {
      if (inputError) {
        ToolShowToast.showError('ошибка ввода, невозможно сохранить данные');
        return;
      }
    }

    if (mapRemoveCommand.isNotEmpty) {
      if (listSelectedDBItems?.length == mapRemoveCommand.length) {
        ToolShowToast.showError('Нельзя удалять сразу ВСЕ элементы.');
        return;
      }

      var myAcceptWidget = MyAcceptActionScreen(
        text: 'Позиций которые будут удалены: ${mapRemoveCommand.length}',
      );
      await showDialog(
        context: App.navigatorKey.currentContext!,
        builder: (context) {
          return myAcceptWidget;
        },
      );
      if (!myAcceptWidget.isConfirmed) {
        return;
      }
    }
    for (var saveCommand in mapUpdateCommand.values) {
      saveCommand.call();
    }
    for (var removeCommand in mapRemoveCommand.values) {
      removeCommand.call();
    }
    if (mapUpdateCommand.isNotEmpty || mapRemoveCommand.isNotEmpty) {
      ConstantsData.reLoadAllDataBaseData();
    }
    if (titleSelected != null) {
      onTitleItemPressed(titleSelected!);
    }
  }

  onTitleItemPressed(String titleItemName) {
    copyDataListOfList = null;
    copyTitleList = null;
    chaneSelectedDBTable(titleItemName);
  }

  orderDataByKey({required String orderKey}) {
    dataOrderKey[orderKey];
    if (dataOrderKey[orderKey] != null) {
      dataOrderKey[orderKey] = !dataOrderKey[orderKey]!;
    } else {
      dataOrderKey = {};
      dataOrderKey[orderKey] = false;
    }
    copyDataListOfList = null;
    order(dataOrderKey[orderKey]!);
    notifyListeners();
  }

  order(bool revers) {
    if (listSelectedDBItems != null) {
      if (revers) {
        listSelectedDBItems!.sort(
          (a, b) => (a.toMap()[dataOrderKey.keys.first] != null &&
                  b.toMap()[dataOrderKey.keys.first] != null)
              ? ((a.toMap()[dataOrderKey.keys.first] as Comparable)
                  .compareTo((b.toMap()[dataOrderKey.keys.first] as Comparable)))
              : (a.toMap()[dataOrderKey.keys.first] == null &&
                      b.toMap()[dataOrderKey.keys.first] == null)
                  ? 0
                  : ((a.toMap()[dataOrderKey.keys.first] == null) ? -1 : 1),
        );
      } else {
        listSelectedDBItems!.sort(
          (b, a) => (a.toMap()[dataOrderKey.keys.first] != null &&
                  b.toMap()[dataOrderKey.keys.first] != null)
              ? ((a.toMap()[dataOrderKey.keys.first] as Comparable)
                  .compareTo((b.toMap()[dataOrderKey.keys.first] as Comparable)))
              : (a.toMap()[dataOrderKey.keys.first] == null &&
                      b.toMap()[dataOrderKey.keys.first] == null)
                  ? 0
                  : ((a.toMap()[dataOrderKey.keys.first] == null) ? -1 : 1),
        );
      }
    }
  }

  static String? getImmutableDataKey({required Map<String, TableSetting>? titleMap}) {
    if (titleMap == null) {
      return null;
    }
    for (var key in titleMap.keys) {
      if (titleMap[key]?.title != null && !titleMap[key]!.isEditable) {
        return key;
      }
    }
    return null;
  }

  static Set<String> getPanelTitle({
    required List<BdFormEntityAbstr>? selectItemList,
    required String? filterKey,
  }) {
    Set<String> setPanelTitle = {};
    if (selectItemList != null) {
      for (var item in selectItemList) {
        setPanelTitle.add(item.toMap()[filterKey]);
      }
    }
    return setPanelTitle;
  }

  static List<List<BdFormEntityAbstr>?> calculateFilteredItemList({
    required Map<String, TableSetting>? titleMap,
    required List<BdFormEntityAbstr>? selectItemList,
    required String? filterKey,
    required bool isCanAddNew,
    Set<String>? panelTitle,
  }) {
    Set<String> setPanelTitle =
        panelTitle ?? getPanelTitle(selectItemList: selectItemList, filterKey: filterKey);
    List<List<BdFormEntityAbstr>?> listFilteredItemList = [];
    if (filterKey != null && selectItemList != null) {
      for (var title in setPanelTitle) {
        var filterList =
            selectItemList.where((element) => element.toMap()[filterKey] == title).toList();
        listFilteredItemList.add(filterList);
      }
    }
    return listFilteredItemList;
  }

  List<String>? getListTitle() {
    if (copyTitleList == null) {
      List<String> titleList = [];
      if (mapTableShowEnum != null) {
        for (var keyTitle in mapTableShowEnum!.keys) {
          if (mapTableShowEnum![keyTitle]!.title != null) {
            titleList.add(mapTableShowEnum![keyTitle]!.title!);
          }
        }
      }
      if (titleList.isEmpty) {
        return null;
      }
      copyTitleList = titleList;
      return titleList;
    } else {
      return copyTitleList;
    }
  }

  List<List<String>>? getListData() {
    if (copyDataListOfList == null) {
      List<List<String>> dataListOfList = [];
      if (mapTableShowEnum != null && listSelectedDBItems != null) {
        for (var item in listSelectedDBItems!) {
          Map<String, dynamic> formItemMap = item.toMap();
          List<String> listData = [];
          for (var keyTitle in mapTableShowEnum!.keys) {
            if (mapTableShowEnum![keyTitle]!.title != null) {
              listData.add(formItemMap[keyTitle].toString());
            }
          }
          dataListOfList.add(listData);
        }
      }
      if (dataListOfList.isEmpty) {
        return null;
      }
      copyDataListOfList = dataListOfList;
      return dataListOfList;
    } else {
      return copyDataListOfList;
    }
  }

  @override
  List<List<String>>? getCopyableDataList() {
    return getListData();
  }

  @override
  List<String>? getCopyableTitleList() {
    return getListTitle();
  }

  @override
  Widget buildDefaultLeftWidget() {
    return const TableChooseTitleLeftScreen();
  }

  @override
  Widget buildDefaultRightWidget() {
    return const SettingsTableDataScreen();
  }

  clearCommandsMap() {
    mapUpdateCommand = {};
    mapRemoveCommand = {};
    userInputErrorMap = {};
    mapGroupFieldInputValue = {};
    mapIsGroupInFocus = {};
  }

  @override
  void selfDispose() {
    mapUpdateCommand = {};
    _instance = null;
    dispose();
  }
}
