import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:form_demo_web/data/repository/repository_constants_data.dart';
import 'package:form_demo_web/data/tools/tool_navigator.dart';
import 'package:form_demo_web/data/tools/tool_theme_data.dart';
import 'package:form_demo_web/data/tools/tool_user_input.dart';
import 'package:form_demo_web/domain/db_form_entity/db_entity_form_abstr.dart';
import 'package:form_demo_web/domain/table_show_enum.dart';
import 'package:form_demo_web/presentation/my_widgets/my_delete_icon_button.dart';
import 'package:form_demo_web/presentation/my_widgets/my_expansion_panel.dart';
import 'package:form_demo_web/presentation/my_widgets/my_flow_excel_button.dart';
import 'package:form_demo_web/presentation/my_widgets/my_immutable_text_field.dart';
import 'package:form_demo_web/presentation/my_widgets/my_text_from_field.dart';
import 'package:form_demo_web/presentation/my_widgets/my_widget_button.dart';
import 'package:form_demo_web/presentation/shield_screen/left_block_work_widgets/shield_data_builder.dart';
import 'package:form_demo_web/presentation/table_screen/add_new_table_item_widget.dart';
import 'package:form_demo_web/presentation/view_models/table_view_model.dart';
import 'package:provider/provider.dart';

class SettingsTableDataScreen extends StatelessWidget {
  const SettingsTableDataScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TableViewModel.instance,
      child: const _TableDataWidget(),
    );
  }
}

class _TableDataWidget extends StatelessWidget {
  const _TableDataWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<BdFormEntityAbstr>? selectItemList =
        context.select((TableViewModel vm) => vm.listSelectedDBItems);
    context.select((TableViewModel vm) => vm.dataOrderKey.values.first);
    context.select((TableViewModel vm) => vm.dataOrderKey.keys.first);
    Map<String, dynamic> map = {};
    map['list'] = selectItemList;
    map['filter'] = TableViewModel.instance.tablePanelFilterMapKey;
    map['titleMap'] = TableViewModel.instance.mapTableShowEnum;
    map['isCanAddNew'] = TableViewModel.instance.isCanAddNew;
    map['dataOrderKey'] = TableViewModel.instance.dataOrderKey;
    TableViewModel.instance.clearCommandsMap();
    return Stack(
      children: [
        FutureBuilder(
          future: compute(computeBuildWidget, map),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Text('Загрузка таблицы..'),
              );
            }
            if (snapshot.hasData) {
              return snapshot.data!;
            } else {
              return const Text("Erorr");
            }
          },
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Row(
                children: [
                  const MyFlowExcelInnerButton(),
                  const SizedBox(width: 4),
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 3,
                    child: MyWidgetButton(
                      onPressed: TableViewModel.instance.onSaveAllButtonPressed,
                      name: 'Сохранить изменения',
                      color: ToolThemeDataHolder.mainCardColor.withAlpha(180),
                      height: 40,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<Widget> computeBuildWidget(Map map) async {
    Map<String, TableSetting>? titleMap = map['titleMap'];
    List<BdFormEntityAbstr>? selectItemList = map['list'];
    String? filterKey = map['filter'];
    bool isCanAddNew = map['isCanAddNew'] ?? false;
    Map<String, bool?> dataOrderMap = map['dataOrderKey'] ?? {'null', null};
    List<_TableDataRow> list = [];
    String? immutableDataKey = TableViewModel.getImmutableDataKey(titleMap: titleMap);
    List<List<BdFormEntityAbstr>?> filteredItemList = [];
    Map<String, List<Widget>> filteredItemMap = {};
    Set<String> setPanelTitle = {};

    if (filterKey != null) {
      setPanelTitle =
          TableViewModel.getPanelTitle(selectItemList: selectItemList, filterKey: filterKey);
      filteredItemList = TableViewModel.calculateFilteredItemList(
        titleMap: titleMap,
        selectItemList: selectItemList,
        filterKey: filterKey,
        panelTitle: setPanelTitle,
        isCanAddNew: isCanAddNew,
      );
    }

    for (var listItem in filteredItemList) {
      list = [];
      if (listItem != null) {
        for (var item in listItem) {
          list.add(
            _TableDataRow(
              listTitleMap: titleMap!,
              formEntityMap: item.toMap(),
              isCanAddNew: isCanAddNew,
              elementCount: listItem.length,
            ),
          );
        }
        filteredItemMap[listItem[0].toMap()[filterKey]] = list;
      }
    }

    int? listViewSize =
        filterKey == null ? selectItemList?.length : filteredItemMap.entries.toList().length;
    listViewSize = (listViewSize ?? 0) + 1 + (isCanAddNew && filterKey == null ? 1 : 0);
    if ((selectItemList != null)) {
      return Stack(
        children: [
          Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              Flexible(
                child: ScrollbarTheme(
                  data: ScrollbarThemeData(
                    thumbColor: MaterialStateProperty.all<Color>(ToolThemeDataHolder.mainCardColor),
                    thumbVisibility: MaterialStateProperty.all<bool>(true),
                  ),
                  child: ListView.builder(
                    padding: const EdgeInsets.only(right: 12),
                    itemCount: listViewSize,
                    itemBuilder: (context, itemId) {
                      if (itemId == listViewSize! - 1) {
                        return const SizedBox(
                          height: 100,
                        );
                      }
                      if (itemId == (listViewSize - 2) && isCanAddNew && filterKey == null) {
                        return buildAddNewItemButtonWidget(
                          titleMap: titleMap!,
                          immutableDataMap: immutableDataKey != null
                              ? {
                                  immutableDataKey:
                                      selectItemList[0].toMap()[immutableDataKey] ?? "null",
                                }
                              : {},
                        );
                      }
                      return filterKey == null
                          ? _TableDataRow(
                              listTitleMap: titleMap!,
                              formEntityMap: selectItemList[itemId].toMap(),
                              isCanAddNew: isCanAddNew,
                              elementCount: selectItemList.length,
                            )
                          : MyExpansionPanel(
                              listWidget: filteredItemMap.entries.toList()[itemId].value,
                              panelTitle: filteredItemMap.entries.toList()[itemId].key,
                              buttonWidget: isCanAddNew
                                  ? buildAddNewItemButtonWidget(
                                      titleMap: titleMap!,
                                      immutableDataMap: {
                                        immutableDataKey!: setPanelTitle.toList()[itemId],
                                      },
                                    )
                                  : null,
                            );
                    },
                  ),
                ),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.transparent),
              borderRadius: BorderRadius.circular(14.0),
              color: Colors.grey[200],
            ),
            height: 30,
            child: buildTitleBlock(
              listTitle: titleMap!,
              dataOrderMap: dataOrderMap,
              isCanAddNew: isCanAddNew,
            ),
          ),
        ],
      );
    } else {
      return const Center(
        child: Text("(Выберите категорию)"),
      );
    }
  }

  buildAddNewItemButtonWidget({
    required Map<String, TableSetting> titleMap,
    required Map<String, String> immutableDataMap,
  }) {
    return MyWidgetButton(
      onPressed: () => ToolNavigator.push(
        AddNewTableItemWidget(
          tableEnum: titleMap,
          immutableData: immutableDataMap,
        ),
      ),
      name: '+',
      color: ToolThemeDataHolder.colorMonoPlastGreen.withOpacity(0.8),
      height: 30,
      icon: Icons.add,
    );
  }

  Widget buildTitleBlock({
    required Map<String, TableSetting> listTitle,
    required Map<String, bool?> dataOrderMap,
    required bool isCanAddNew,
  }) {
    return Row(
      children: [
        if (listTitle['name'] != null)
          Flexible(
            flex: 2,
            child: itemTitleBlock(
              title: listTitle['name']!.title!,
              titleKey: 'name',
              dataOrderMap: dataOrderMap,
            ),
          ),
        for (var titleKey in listTitle.keys)
          if (listTitle[titleKey]?.title != null &&
              titleKey != 'name' &&
              listTitle[titleKey]?.hideConstValue == false)
            Flexible(
              flex: 1,
              child: itemTitleBlock(
                title: listTitle[titleKey]!.title!,
                titleKey: titleKey,
                dataOrderMap: dataOrderMap,
              ),
            ),
        SizedBox.square(
          dimension: isCanAddNew ? minFieldHeight / 1.5 + 12 : 12,
        ), //отступ для иконки удаления а (12) для скролл бара
      ],
    );
  }

  itemTitleBlock({
    required String title,
    required String titleKey,
    required Map<String, bool?> dataOrderMap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1.5, vertical: 3.0),
      child: InkWell(
        onTap: () {
          TableViewModel.instance.orderDataByKey(orderKey: titleKey);
        },
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.grey[300],
            border: Border.all(color: Colors.transparent),
            borderRadius: BorderRadius.circular(6.0),
          ),
          child: Row(
            children: [
              Flexible(
                child: Container(
                  constraints: BoxConstraints(
                    minWidth: 400,
                    minHeight: minFieldHeight / 1.5,
                  ),
                  alignment: AlignmentDirectional.centerStart,
                  child: Center(
                    child: Text(
                      title,
                      style: ToolThemeDataHolder.defFillConstTextStyle,
                    ),
                  ),
                ),
              ),
              dataOrderMap[titleKey] == null
                  ? const Icon(Icons.horizontal_rule)
                  : dataOrderMap[titleKey]! == true
                      ? const Icon(Icons.keyboard_arrow_down)
                      : const Icon(Icons.keyboard_arrow_up),
            ],
          ),
        ),
      ),
    );
  }
}

class _TableDataRow extends StatefulWidget {
  const _TableDataRow({
    Key? key,
    required this.listTitleMap,
    required this.formEntityMap,
    this.elementCount,
    required this.isCanAddNew,
  }) : super(key: key);
  final Map<String, TableSetting> listTitleMap; // настройки
  final Map<String, dynamic> formEntityMap; // данные
  final bool isCanAddNew; // данные
  final int? elementCount; // данные
  @override
  State<_TableDataRow> createState() => _TableDataRowState();
}

class _TableDataRowState extends State<_TableDataRow> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        mouseCursor: SystemMouseCursors.basic,
        hoverColor: Colors.grey.withOpacity(0.2),
        focusColor: ToolThemeDataHolder.mainLightCardColor.withOpacity(0.45),
        child: Row(
          children: [
            if (widget.listTitleMap['name'] != null)
              Flexible(
                flex: 2,
                child: ItemField(
                  value: widget.formEntityMap['name']!,
                  runType: String,
                  canBeNull: widget.listTitleMap['name']!.canBeNull,
                  dbID: widget.formEntityMap['id']!,
                  isEditable: widget.listTitleMap['name']!.isEditable,
                  dbKey: 'name',
                ),
              ),
            for (var keyTitle in widget.listTitleMap.keys)
              if (widget.listTitleMap[keyTitle]?.title != null &&
                  keyTitle != 'name' &&
                  widget.listTitleMap[keyTitle]?.hideConstValue == false)
                Flexible(
                  flex: 1,
                  child: ItemField(
                    value: widget.formEntityMap[keyTitle],
                    runType: widget.listTitleMap[keyTitle]!.type,
                    isSpinner: widget.listTitleMap[keyTitle]!.spinnerKey != null,
                    dbID: widget.formEntityMap['id']!,
                    canBeNull: widget.listTitleMap[keyTitle]!.canBeNull,
                    isEditable: widget.listTitleMap[keyTitle]!.isEditable,
                    keyGroup: widget.listTitleMap[keyTitle]!.keyGroup != null &&
                            (ConstName.mapSupGroup[widget.listTitleMap[keyTitle]!.keyGroup] ?? [])
                                .contains(widget.formEntityMap['id']!)
                        ? widget.listTitleMap[keyTitle]!.keyGroup
                        : null,
                    dbKey: keyTitle,
                  ),
                ),
            if (widget.isCanAddNew && (widget.elementCount ?? 0) > 1)
              MyDeleteIconButton(
                size: minFieldHeight / 1.5,
                onSelect: () {
                  TableViewModel.instance.buildRemoveCommand(itemID: widget.formEntityMap['id']!);
                },
                onDeselect: () {
                  TableViewModel.instance.removeRemoveCommand(itemID: widget.formEntityMap['id']!);
                },
              ),
          ],
        ),
      ),
    );
  }
}

class ItemField extends StatefulWidget {
  dynamic value;
  final int dbID;
  final String dbKey;
  bool isEditable;
  Type runType;
  bool canBeNull;
  String? keyGroup;
  bool isWasChanged = false;
  bool inputError = false;
  bool isSpinner;

  dynamic crntValue;
  final TextEditingController controller = TextEditingController();

  ItemField({
    Key? key,
    required this.value,
    required this.dbID,
    required this.dbKey,
    required this.runType,
    required this.canBeNull,
    this.isSpinner = false,
    this.keyGroup,
    required this.isEditable,
  }) : super(key: key) {
    if (value == null) {
      this.value = '';
    }
  }

  @override
  State<ItemField> createState() => _ItemFieldState();
}

class _ItemFieldState extends State<ItemField> {
  cheakChanged() {
    widget.isWasChanged = (widget.value.toString() != widget.crntValue);
  }

  setSaveCommand() {
    if (widget.isWasChanged && !widget.inputError) {
      TableViewModel.instance
          .buildInputCommand(value: widget.crntValue, columnKey: widget.dbKey, itemID: widget.dbID);
    } else if (widget.inputError) {
      TableViewModel.instance.removeInputCommand(itemID: widget.dbID);
    }
  }

  @override
  void setState(VoidCallback fn) {
    widget.crntValue = widget.controller.text.trim();
    cheakChanged();
    if (widget.isWasChanged) {
      setSaveCommand();
    }
    super.setState(() {});
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.crntValue = widget.value.toString();
      widget.controller.text = widget.value.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.keyGroup != null) {
      String? groupString = context
          .select((TableViewModel viewModel) => viewModel.mapGroupFieldInputValue[widget.keyGroup]);
      if (groupString != null && widget.controller.text.toString() != groupString) {
        widget.controller.text = groupString;
        setState(() {});
      }
    }
    bool intOnly = false;
    bool allowDouble = false;
    if (widget.isEditable) {
      widget.controller.addListener(() {
        String newText = widget.controller.text.toString();
        if (widget.keyGroup != null) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            TableViewModel.instance
                .putGroupFieldInputValue(groupKey: widget.keyGroup!, newText: newText);
          });
        }
        if (widget.crntValue != newText) {
          widget.inputError = ToolUserInput.haveInputError(
            controller: widget.controller,
            runtimeType: widget.runType,
            canBeNull: widget.canBeNull,
          );
          TableViewModel.instance.addUserInputError(
            key: '${widget.dbID}${widget.dbKey}',
            isError: widget.inputError,
          );
        }
      });
      if (widget.value.runtimeType == int) {
        intOnly = true;
      }
      if (widget.value.runtimeType == double) {
        intOnly = true;
        allowDouble = true;
      }
    }
    return Focus(
      onFocusChange: (focus) {
        if (widget.keyGroup != null) {
          if (!focus) {
            TableViewModel.instance.putIsGroupInFocusValue(
              groupKey: widget.keyGroup!,
              isInFocus: focus,
            );
          }
          if (focus) {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              TableViewModel.instance.putIsGroupInFocusValue(
                groupKey: widget.keyGroup!,
                isInFocus: focus,
              );
            });
          }
        }
        setState(() {});
      },
      child: Padding(
        padding: const EdgeInsets.all(1.5),
        child: TestInkWell()
          ..outsideChild = Container(
            constraints: BoxConstraints(
              minWidth: 220,
              minHeight: minFieldHeight / 1.5,
            ),
            alignment: AlignmentDirectional.center,
            child: SizedBox(
              width: double.infinity,
              height: minFieldHeight / 1.5,
              child: widget.isEditable && !widget.isSpinner
                  ? MyTextFormField(
                      controller: widget.controller,
                      numbOnly: intOnly,
                      autofocus: false,
                      allowDouble: allowDouble,
                      prefixIcon: widget.keyGroup != null
                          ? IconsGroupIndicator(groupKey: widget.keyGroup!)
                          : null,
                    )
                  : MyImmutableTextField(
                      text: widget.value.toString(),
                      textAlign: TextAlign.center,
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

class IconsGroupIndicator extends StatefulWidget {
  const IconsGroupIndicator({Key? key, required this.groupKey}) : super(key: key);
  final String groupKey;

  @override
  State<IconsGroupIndicator> createState() => _IconsGroupIndicatorState();
}

class _IconsGroupIndicatorState extends State<IconsGroupIndicator>
    with SingleTickerProviderStateMixin {
  final Tween<double> tweenRot = Tween<double>(begin: -0.00, end: 0.14);
  final Tween<Offset> tweenPos =
      Tween<Offset>(begin: const Offset(0, -0.5), end: const Offset(0, 0.5));
  late AnimationController animationController;
  bool isFocus = false;

  @override
  void initState() {
    animationController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 450));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    isFocus = context.select(
      (TableViewModel viewModel) => viewModel.mapIsGroupInFocus[widget.groupKey] ?? false,
    );
    if (isFocus) {
      animationController.repeat(reverse: true);
    } else {
      if (animationController.isAnimating) {
        animationController.reverse().then((value) => animationController.stop);
      }
    }
    return AnimatedRotation(
      duration: const Duration(milliseconds: 300),
      turns: isFocus ? 0.25 : 0.0,
      child: AnimatedBuilder(
        animation: animationController,
        builder: (context, child) => Transform.translate(
          offset: animationController.drive(tweenPos).value,
          child: Transform.rotate(
            angle: animationController.drive(tweenRot).value,

            //angle: 0.15 * animationController.value,
            child: child,
          ),
        ),
        child: Icon(
          Icons.link_outlined,
          color: isFocus ? ToolThemeDataHolder.mainCardColor : Colors.black87,
        ),
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
          mouseCursor: SystemMouseCursors.basic,
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
