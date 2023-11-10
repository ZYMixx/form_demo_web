import 'package:flutter/material.dart';
import 'package:form_demo_web/data/services/service_find_spinner_table_data.dart';
import 'package:form_demo_web/data/tools/tool_navigator.dart';
import 'package:form_demo_web/data/tools/tool_theme_data.dart';
import 'package:form_demo_web/data/tools/tool_user_input.dart';
import 'package:form_demo_web/domain/table_show_enum.dart';
import 'package:form_demo_web/presentation/my_widgets/my_immutable_text_field.dart';
import 'package:form_demo_web/presentation/my_widgets/my_text_from_field.dart';
import 'package:form_demo_web/presentation/my_widgets/my_widget_button.dart';
import 'package:form_demo_web/presentation/view_models/table_view_model.dart';

const double itemHeight = 60.0;

class AddNewTableItemWidget extends StatelessWidget {
  const AddNewTableItemWidget({Key? key, required this.tableEnum, required this.immutableData})
      : super(key: key);
  final Map<String, TableSetting> tableEnum;
  final Map<String, String> immutableData;

  Map<String, TableSetting> getConvertMap() {
    Map<String, TableSetting> convertMap = {};
    for (var key in tableEnum.keys) {
      if (tableEnum[key]!.isEditable) {
        convertMap[key] = tableEnum[key]!;
      }
    }
    return convertMap;
  }

  @override
  Widget build(BuildContext context) {
    TableViewModel.instance.resetInsertDbMap();
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final double screenWidth = mediaQueryData.size.width;
    final double screenHeight = mediaQueryData.size.height;
    Map<String, TableSetting> convertMap = getConvertMap();
    List<String> keysList = convertMap.keys.toList();
    List<String> immutableDataKeysList = immutableData.keys.toList();

    int listViewSize = immutableDataKeysList.length + keysList.length;
    return Scaffold(
      backgroundColor: ToolThemeDataHolder.mainShadowBgColor,
      body: Stack(
        children: [
          const InkWell(
            onTap: ToolNavigator.pop,
            child: Center(
              child: Text("ZYMixx"),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: (screenWidth / 2.5), top: screenHeight / 3.5),
            child: Container(
              constraints: BoxConstraints(
                maxHeight: screenHeight / 2.1,
                maxWidth: screenWidth / 2.3,
              ),
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(),
                    boxShadow: [ToolThemeDataHolder.alertShadowBox],
                    color: Colors.white,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(6.0),
                          child: Text(
                            "Добавление нового элемента",
                            style: ToolThemeDataHolder.defConstTextStyle,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: [ToolThemeDataHolder.lowLowShadowBox],
                              color: Colors.white,
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            height: (itemHeight * listViewSize) > screenHeight / 3
                                ? screenHeight / 3
                                : (itemHeight * listViewSize),
                            child: ScrollbarTheme(
                              data: ScrollbarThemeData(
                                thumbColor: MaterialStateProperty.all<Color>(
                                    ToolThemeDataHolder.mainCardColor),
                                thumbVisibility: MaterialStateProperty.all<bool>(true),
                              ),
                              child: ListView.builder(
                                itemCount: listViewSize,
                                itemBuilder: (context, itemID) {
                                  if (itemID < immutableDataKeysList.length) {
                                    return buildTitleBlock(
                                        dbKey: immutableDataKeysList[itemID],
                                        title: immutableData[immutableDataKeysList[itemID]]!);
                                  }
                                  return buildUserInputBlock(
                                    bdKey: keysList[itemID - immutableDataKeysList.length],
                                    title:
                                        tableEnum[keysList[itemID - immutableDataKeysList.length]]!
                                            .title!,
                                    spinnerKey:
                                        tableEnum[keysList[itemID - immutableDataKeysList.length]]!
                                            .spinnerKey,
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 2.0, right: 2.0, bottom: 8.0, top: 4),
                          child: MyWidgetButton(
                              onPressed: TableViewModel.instance.onInsertButtonPressed,
                              name: 'Добавить',
                              color: ToolThemeDataHolder.colorMonoPlastGreen),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildTitleBlock({required String dbKey, required String title}) {
    TableViewModel.instance.updateInsertDbMap(mapKey: dbKey, mapData: title);
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        color: ToolThemeDataHolder.mainLightCardColor,
        height: itemHeight - 10,
        child: Center(
          child: MyImmutableTextField(
            text: title,
            style: ToolThemeDataHolder.defConstTextStyle,
          ),
        ),
      ),
    );
  }

  buildUserInputBlock({required String title, required String bdKey, required String? spinnerKey}) {
    return Container(
      padding: const EdgeInsets.all(4.0),
      height: itemHeight,
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Row(children: [
          Flexible(
            flex: 2,
            child: ColoredBox(
              color: ToolThemeDataHolder.mainLightCardColor,
              child: Center(
                  child: Text(
                title,
                style: ToolThemeDataHolder.defConstTextStyle,
              )),
            ),
          ),
          Flexible(
            flex: 3,
            child: Center(
              child: spinnerKey != null
                  ? SpinnerItemField(
                      dbKey: bdKey,
                      spinnerKey: spinnerKey,
                      canBeNull: TableViewModel.instance.getCanBeNullByDbKey(bdKey), //
                    )
                  : ItemField(
                      dbKey: bdKey,
                      type: TableViewModel.instance.getFieldTypeByDbKey(bdKey), //
                      canBeNull: TableViewModel.instance.getCanBeNullByDbKey(bdKey), //
                    ),
            ),
          )
        ]),
      ),
    );
  }
}

class SpinnerItemField extends StatefulWidget {
  final String dbKey;
  final String spinnerKey;
  bool canBeNull;
  dynamic crntValue;

  SpinnerItemField({
    Key? key,
    required this.dbKey,
    required this.spinnerKey,
    required this.canBeNull,
  }) : super(key: key);

  @override
  State<SpinnerItemField> createState() => _SpinnerItemFieldState();
}

class _SpinnerItemFieldState extends State<SpinnerItemField> {
  setSaveCommand(String userData) {
    if (userData == '-') {
      userData = '';
    }
    TableViewModel.instance.updateInsertDbMap(mapKey: widget.dbKey, mapData: userData);
  }

  late String selectedOption;
  late List<String> listSpinnerValue;

  @override
  void setState(VoidCallback fn) {
    super.setState(() {});
  }

  @override
  void initState() {
    listSpinnerValue = ServiceFindSpinnerTableData.find(tableKey: widget.spinnerKey)!;
    selectedOption = listSpinnerValue.first;
    setSaveCommand(listSpinnerValue.first);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (focus) {
        if (!focus) {
          setState(() {});
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(1.5),
        child: DecoratedBox(
          position: DecorationPosition.background,
          decoration: BoxDecoration(
            border: Border.all(width: 0.6),
            borderRadius: BorderRadius.circular(3.0),
          ),
          child: DropdownButton<String>(
            isExpanded: true,
            value: selectedOption,
            onChanged: (newValue) {
              if (newValue != null) {
                selectedOption = newValue;
                setState(() {});
              }
            },
            items: [
              for (String spinnerValue in listSpinnerValue)
                buildDropdownSpinnerItem(value: spinnerValue, saveCallback: setSaveCommand),
            ],
          ),
        ),
      ),
    );
  }
}

DropdownMenuItem<String> buildDropdownSpinnerItem(
    {required String value, required Function(String value) saveCallback}) {
  return DropdownMenuItem(
    value: value,
    onTap: () => saveCallback.call(value),
    child: Center(
      child: Text(value),
    ),
  );
}

class ItemField extends StatefulWidget {
  final String dbKey;
  final Type type;
  bool isWasChanged = false;
  bool canBeNull;
  bool inputError = false;

  dynamic crntValue;
  final TextEditingController controller = TextEditingController();

  ItemField({
    Key? key,
    required this.dbKey,
    required this.type,
    required this.canBeNull,
  }) : super(key: key);

  @override
  State<ItemField> createState() => _ItemFieldState();
}

class _ItemFieldState extends State<ItemField> {
  setSaveCommand(String userData) {
    TableViewModel.instance.updateInsertDbMap(mapKey: widget.dbKey, mapData: userData);
  }

  @override
  void setState(VoidCallback fn) {
    widget.crntValue = widget.controller.text.trim();
    setSaveCommand(widget.crntValue);
    super.setState(() {});
  }

  @override
  void initState() {
    setSaveCommand('');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool intOnly = false;
    bool allowDouble = false;
    widget.controller.addListener(() {
      if (widget.crntValue != widget.controller.text.toString()) {
        widget.inputError = ToolUserInput.haveInputError(
          controller: widget.controller,
          runtimeType: widget.type,
          canBeNull: widget.canBeNull,
        );
      }
    });
    if (widget.type == int) {
      intOnly = true;
    }
    if (widget.type == double) {
      intOnly = true;
      allowDouble = true;
    }
    return Focus(
      onFocusChange: (focus) {
        if (!focus) {
          setState(() {});
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(1.5),
        child: TestInkWell()
          ..outsideChild = Container(
            constraints: const BoxConstraints(
              minHeight: itemHeight,
            ),
            alignment: AlignmentDirectional.center,
            child: SizedBox(
              height: itemHeight,
              child: MyTextFormField(
                controller: widget.controller,
                numbOnly: intOnly,
                allowDouble: allowDouble,
              ),
            ),
          )
          ..inputError = widget.inputError
          ..isWasChanged = widget.isWasChanged,
      ),
    );
  }

  Widget getInkWellWithMaterial(Widget outsideChild) {
    return Material(
      child: InkWell(
        focusColor:
            widget.inputError ? null : ToolThemeDataHolder.colorMonoPlastGreen.withAlpha(100),
        highlightColor: null,
        onTap: () {},
        child: outsideChild,
      ),
    );
  }
}

class TestInkWell extends StatelessWidget {
  late Widget outsideChild;
  late bool inputError;
  late bool isWasChanged;

  TestInkWell({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (inputError || isWasChanged) {
      return Material(
        color: inputError ? Colors.red[300] : Colors.green[300],
        child: InkWell(
          focusColor: inputError ? Colors.red[200] : Colors.green[200],
          highlightColor: null,
          onTap: () {},
          child: DecoratedBox(
            position: DecorationPosition.background,
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(3.0),
            ),
            child: outsideChild,
          ),
        ),
      );
    } else {
      return DecoratedBox(
        position: DecorationPosition.background,
        decoration: BoxDecoration(
          border: Border.all(width: 0.6),
          borderRadius: BorderRadius.circular(3.0),
        ),
        child: outsideChild,
      );
    }
  }
}
