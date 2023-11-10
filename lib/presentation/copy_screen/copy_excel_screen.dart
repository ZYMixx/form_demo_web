import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_demo_web/data/tools/tool_help_data.dart';
import 'package:form_demo_web/data/tools/tool_navigator.dart';
import 'package:form_demo_web/data/tools/tool_show_toast.dart';
import 'package:form_demo_web/data/tools/tool_theme_data.dart';
import 'package:form_demo_web/presentation/my_widgets/my_immutable_text_field.dart';
import 'package:form_demo_web/presentation/my_widgets/selected_mouse_screen.dart';
import 'package:form_demo_web/presentation/view_models/copy_screen_view_model.dart';
import 'package:form_demo_web/presentation/view_models/copyable_data_repository.dart';
import 'package:provider/provider.dart';

final GlobalKey _centerBoxKey = GlobalKey();

class CopyExcelScreen extends StatefulWidget {
  const CopyExcelScreen({Key? key, required this.exelFormat}) : super(key: key);
  final bool exelFormat;

  @override
  State<CopyExcelScreen> createState() => _CopyExcelScreenState();
}

bool onCopyHotKeyPressed(RawKeyEvent event, bool readyToCopy) {
  final isControlPressed = event.isControlPressed;
  final isAPressed = event.logicalKey == LogicalKeyboardKey.keyC;
  if (isControlPressed && isAPressed && readyToCopy) {
    CopyScreenViewModel.instance.onCopyDataButtonPressed();
    ToolShowToast.show('Taблица скопирована');
    return false;
  } else if (isControlPressed && isAPressed) {
    return false;
  } else {
    return true;
  }
}

class _CopyExcelScreenState extends State<CopyExcelScreen> {
  bool readyToCopy = true;

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();
    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: (event) {
        readyToCopy = onCopyHotKeyPressed(event, readyToCopy);
      },
      child: Scaffold(
        backgroundColor: ToolThemeDataHolder.mainShadowBgColor,
        body: ChangeNotifierProvider(
          create: (_) => CopyScreenViewModel.instance,
          child: Stack(
            children: [
              const InkWell(
                onTap: ToolNavigator.pop,
                splashFactory: NoSplash.splashFactory,
              ),
              Center(
                child: FractionallySizedBox(
                  widthFactor: 0.6,
                  heightFactor: 0.7,
                  key: _centerBoxKey,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(2.0),
                      color: Colors.grey[300],
                    ),
                    child: CopyableDataRepository.instance.getListData() != null
                        ? widget.exelFormat
                            ? SelectedMouseScreen(
                                scrollController: scrollController,
                                borderWidgetKey: _centerBoxKey,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    top: 20.0,
                                    left: 35,
                                    right: 23,
                                    bottom: 5,
                                  ),
                                  child: ScrollbarTheme(
                                    data: ScrollbarThemeData(
                                      thumbColor: MaterialStateProperty.all<Color>(
                                        ToolThemeDataHolder.mainCardColor,
                                      ),
                                      thumbVisibility: MaterialStateProperty.all<bool>(true),
                                    ),
                                    child: ListView.builder(
                                      padding: const EdgeInsets.only(right: 12),
                                      controller: scrollController,
                                      itemCount:
                                          CopyableDataRepository.instance.getListData()!.length + 1,
                                      itemBuilder: (context, itemID) {
                                        if (itemID == 0) {
                                          return buildRowTitle(
                                            CopyableDataRepository.instance.getListTitle(),
                                          );
                                        } else {
                                          return buildRowData(
                                            listOfData: CopyableDataRepository.instance
                                                .getListData()![itemID - 1],
                                            columnPos: itemID,
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              )
                            : getSingleTextWidget()
                        : const Center(
                            child: Text('Ничего не выбрано'),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getSingleTextWidget() {
    return ScrollbarTheme(
      data: ScrollbarThemeData(
        thumbColor: MaterialStateProperty.all<Color>(ToolThemeDataHolder.mainCardColor),
        thumbVisibility: MaterialStateProperty.all<bool>(true),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 18.0),
          child: Center(
            child: SelectableText(
              CopyScreenViewModel.instance.getAllCopyText(),
              style: ToolThemeDataHolder.defTextDataStyle,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    CopyScreenViewModel.instance.dispose();
    super.dispose();
  }
}

Widget buildRowTitle(List<String>? listTitle) {
  List<Widget> list = [];
  if (listTitle == null) {
    return const MyImmutableTextField(text: "no data");
  }
  int rowPos = 0;

  for (var title in listTitle) {
    GlobalKey globalKey = GlobalKey();

    list.add(
      TitleCell(
        key: globalKey,
        title: title,
        rowPos: rowPos++,
        columnPos: 0,
      ),
    );
  }
  return Row(children: list);
}

Widget buildRowData({required List<String> listOfData, required int columnPos}) {
  List<Widget> list = [];
  int rowPos = 0;
  for (var text in listOfData) {
    GlobalKey globalKey = GlobalKey();
    list.add(
      DataCell(
        text: text,
        key: globalKey,
        rowPos: rowPos++,
        columnPos: columnPos,
      ),
    );
  }
  return Row(children: list);
}

class DataCell extends StatefulWidget {
  const DataCell({Key? key, required this.text, required this.rowPos, required this.columnPos})
      : super(key: key);
  final String text;
  final int rowPos;
  final int columnPos;

  ValueKey get valueKey => ToolHelpData.buildComboValueKey([text, rowPos, columnPos]);

  @override
  State<DataCell> createState() => _DataCellState();
}

class _DataCellState extends State<DataCell> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    CopyScreenViewModel.instance.addSelectableItem(
      globalKey: widget.key as GlobalKey,
      dataText: widget.text,
      rowPos: widget.rowPos,
      columnPos: widget.columnPos,
    );
    return Flexible(
      fit: FlexFit.tight,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(width: 0.2),
              borderRadius: BorderRadius.circular(4.0),
              color: CopyScreenViewModel.instance.mapSelectableItem[widget.valueKey]!.isSelected
                  ? ToolThemeDataHolder.mainLightCardColor
                  : Colors.white,
            ),
            height: 30,
            child: Center(
              child: MyImmutableTextField(text: widget.text),
            ),
          ),
        ),
      ),
    );
  }
}

class TitleCell extends StatefulWidget {
  const TitleCell({Key? key, required this.title, required this.rowPos, required this.columnPos})
      : super(key: key);
  final String title;
  final int rowPos;
  final int columnPos;

  ValueKey get valueKey => ToolHelpData.buildComboValueKey([title, rowPos, columnPos]);

  @override
  State<TitleCell> createState() => _TitleCellState();
}

class _TitleCellState extends State<TitleCell> {
  @override
  Widget build(BuildContext context) {
    CopyScreenViewModel.instance.addSelectableItem(
      globalKey: widget.key as GlobalKey,
      dataText: widget.title,
      rowPos: widget.rowPos,
      columnPos: widget.columnPos,
    );
    return Flexible(
      fit: FlexFit.tight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1.0),
        child: Container(
          color: ToolThemeDataHolder.mainCardColor,
          child: Center(
            child: MyImmutableTextField(
              text: widget.title,
              textColor: CopyScreenViewModel.instance.mapSelectableItem[widget.valueKey]!.isSelected
                  ? Colors.blue[300]
                  : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
