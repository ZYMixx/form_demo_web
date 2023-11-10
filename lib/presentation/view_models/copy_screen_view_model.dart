import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_demo_web/data/repository/selected_mouse_repository.dart';
import 'package:form_demo_web/data/services/service_copy_data.dart';
import 'package:form_demo_web/data/tools/tool_help_data.dart';
import 'package:form_demo_web/data/tools/tool_navigator.dart';
import 'package:form_demo_web/data/tools/tool_show_toast.dart';
import 'package:form_demo_web/presentation/copy_screen/copy_excel_screen.dart';
import 'package:form_demo_web/presentation/my_widgets/my_flow_excel_button.dart';
import 'package:form_demo_web/presentation/view_models/copyable_data_repository.dart';

class CopyScreenViewModel extends ChangeNotifier
    with SelectableScreenInterface, ExcelButtonListener {
  static CopyScreenViewModel get instance => _instance ??= CopyScreenViewModel();
  static CopyScreenViewModel? _instance;

  SelectedMouseRepository mouseSelectRep = SelectedMouseRepository.instance;
  CopyableDataRepository? copyableRepos = CopyableDataRepository.instance;

  Map<ValueKey, SelectableItem> mapSelectableItem = {};
  Map<int, List<String>> mapListCopyData = {};

  CopyScreenViewModel() {
    if (_instance != null) {
      throw ("pls dont create second CopyScreenViewModel, use instance");
    }
    subscribe();
  }

  static int x = 0;

  addSelectableItem({
    required GlobalKey globalKey,
    required String dataText,
    required int rowPos,
    required int columnPos,
  }) {
    var valueKey = ToolHelpData.buildComboValueKey([dataText, rowPos, columnPos]);
    if (mapSelectableItem.containsKey(valueKey)) {
      mapSelectableItem[valueKey]!.key = globalKey;
    } else {
      mapSelectableItem.putIfAbsent(
        valueKey,
        () => SelectableItem(
          key: globalKey,
          dataText: dataText,
          rowPos: rowPos,
          columnPos: columnPos,
        ),
      );
    }
  }

  checkSelected() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      for (var item in mapSelectableItem.values) {
        if (mouseSelectRep.isOffsetInRange(item.getPosition())) {
          item.turnSelectedOn();
        } else {
          item.turnSelectedOff();
        }
      }
    });
  }

  onCopyAllExcelTableButtonPressed() {
    var list = copyableRepos?.getListData();
    if (list != null) {
      String result = ServiceCopyData.fillCopyExcelData(list);
      Clipboard.setData(ClipboardData(text: result));
      ToolShowToast.show('Taблица скопирована');
    } else {
      ToolShowToast.showError('НЕТ ДАННЫХ ДЛЯ КОПИРОВАНИЯ');
    }
  }

  onCopyAllTextTableButtonPressed() {
    var list = copyableRepos?.getListData();
    if (list != null) {
      String result = ServiceCopyData.fillCopyTextData(list);
      Clipboard.setData(ClipboardData(text: result));
      ToolShowToast.show('Taблица скопирована');
    } else {
      ToolShowToast.showError('НЕТ ДАННЫХ ДЛЯ КОПИРОВАНИЯ');
    }
  }

  String getAllCopyText() {
    CopyableDataRepository.instance.getListData();
    var list = CopyableDataRepository.instance.getListData();
    if (list != null) {
      return ServiceCopyData.fillCopyTextData(list);
    } else {
      return 'null data';
    }
  }

  onCopyDataButtonPressed() {
    if (createCopyMap()) {
      Clipboard.setData(
        ClipboardData(text: ServiceCopyData.fillCopyExcelData(mapListCopyData.values.toList())),
      );
    } else {}
  }

  bool createCopyMap() {
    mapListCopyData = {};
    List<SelectableItem> sortList = sortSelectedItems();
    if (sortList.isEmpty) {
      return false;
    } else {
      for (var item in sortList) {
        createMap(columnKey: item.columnPos, data: item.dataText);
      }
      return true;
    }
  }

  List<SelectableItem> sortSelectedItems() {
    List<SelectableItem> listSelectedItems = getSelectedItems();
    listSelectedItems.sort((first, second) {
      int result = first.columnPos.compareTo(second.columnPos);
      if (result == 0) {
        result = first.rowPos.compareTo(second.rowPos);
      }
      return result;
    });
    return listSelectedItems;
  }

  createMap({required int columnKey, required String data}) {
    if (mapListCopyData.containsKey(columnKey)) {
      mapListCopyData[columnKey]?.add(data);
    } else {
      mapListCopyData[columnKey] = [data];
    }
  }

  List<SelectableItem> getSelectedItems() {
    List<SelectableItem> list = [];
    for (var item in mapSelectableItem.values) {
      if (item.isSelected) {
        list.add(item);
      }
    }
    return list;
  }

  @override
  dropSelectedItem() {
    for (var item in mapSelectableItem.values) {
      item.turnSelectedOff(force: true);
      item.dropSavedPosition();
    }
  }

  @override
  void dispose() {
    mapSelectableItem = {};
    _instance = null;
    unSubscribe();
    super.dispose();
  }

  @override
  callBack() {
    checkSelected();
  }

  @override
  subscribe() {
    mouseSelectRep.addListeners(this);
  }

  @override
  unSubscribe() {
    mouseSelectRep.removeListener(this);
  }

  @override
  tableButtonPressed() {
    ToolNavigator.push(const CopyExcelScreen(exelFormat: true));
  }

  @override
  tableCopyButtonPressed() {
    onCopyAllExcelTableButtonPressed();
  }

  @override
  textButtonPressed() {
    ToolNavigator.push(const CopyExcelScreen(exelFormat: false));
  }

  @override
  textCopyButtonPressed() {
    onCopyAllTextTableButtonPressed();
  }
}

class SelectableItem {
  bool _isSelected = false;

  bool get isSelected => _isSelected;
  GlobalKey key;
  RenderBox? buttonBox;
  String dataText;
  Offset? localGlobalOffSet;

  int rowPos;
  int columnPos;

  SelectedMouseRepository mouseSelectRep = SelectedMouseRepository.instance;

  SelectableItem({
    required this.key,
    required this.dataText,
    required this.rowPos,
    required this.columnPos,
  });

  Offset? getPosition() {
    buttonBox = key.currentContext?.findRenderObject() as RenderBox?;
    var itemSize = buttonBox?.size;
    var dx = mouseSelectRep.borderStartPosition.dx + ((itemSize?.width ?? 0) / 2);
    var dy = mouseSelectRep.borderStartPosition.dy +
        ((itemSize?.height ?? 0) / 2) +
        mouseSelectRep.absolutScrollPos;
    localGlobalOffSet = buttonBox?.localToGlobal(Offset(dx, dy)) ?? localGlobalOffSet;
    // если выходит за экран возвращает последние известные кординаты
    return localGlobalOffSet;
  }

  rebuildWidget() {
    key.currentState?.setState(() {});
  }

  dropSavedPosition() {
    localGlobalOffSet = null;
  }

  turnSelectedOff({bool force = false}) {
    if (isSelected || force) {
      _isSelected = false;
      if (key.currentContext?.mounted ?? false) {
        rebuildWidget();
      }
    }
  }

  turnSelectedOn() {
    if (!isSelected) {
      _isSelected = true;
      rebuildWidget();
    }
  }

  @override
  String toString() {
    return 'SelectableItem{dataText: $dataText, rowPos: $rowPos, columnPos: $columnPos}';
  }
}
