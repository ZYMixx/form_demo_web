import 'package:flutter/material.dart';
import 'package:form_demo_web/data/services/service_sort_calculate_data.dart';
import 'package:form_demo_web/data/tools/tool_help_data.dart';
import 'package:form_demo_web/domain/calculate_item.dart';
import 'package:form_demo_web/presentation/my_widgets/my_flow_excel_button.dart';
import 'package:form_demo_web/presentation/my_widgets/my_immutable_text_field.dart';
import 'package:form_demo_web/presentation/shield_screen/left_block_work_widgets/shield_data_builder.dart';
import 'package:form_demo_web/presentation/view_models/shield_data_view_model.dart';
import 'package:provider/provider.dart';

import '../../data/tools/tool_theme_data.dart';

class ShieldCalculateDataExpansionPanel extends StatefulWidget {
  const ShieldCalculateDataExpansionPanel({Key? key}) : super(key: key);

  @override
  State<ShieldCalculateDataExpansionPanel> createState() =>
      _ShieldCalculateDataExpansionPanelState();
}

class _ShieldCalculateDataExpansionPanelState extends State<ShieldCalculateDataExpansionPanel> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ShieldDataViewModel.instance,
      child: const CalculateDataPanel(),
    );
  }
}

class CalculateDataPanel extends StatefulWidget {
  const CalculateDataPanel({Key? key}) : super(key: key);

  @override
  State<CalculateDataPanel> createState() => _CalculateDataPanelState();
}

class _CalculateDataPanelState extends State<CalculateDataPanel> {
  List<bool> _isOpen = [];

  @override
  Widget build(BuildContext context) {
    ServiceSortCalculateData? sortData =
        context.select((ShieldDataViewModel vm) => vm.sortCalculateData);
    context.select((ShieldDataViewModel vm) => vm.isOrdered);
    List<CalculateExpansionPanel> listWidget = [];
    if (sortData != null) {
      for (var i = 0; i < sortData.listAllSortCalculateData.length; i++) {
        if (_isOpen.length < sortData.listAllSortCalculateData.length) {
          _isOpen.add(false);
        }
        listWidget.add(CalculateExpansionPanel(
            list: sortData.listAllSortCalculateData[i], isExpanded: _isOpen[i]));
      }
    }
    if ((sortData != null)) {
      return Scaffold(
        floatingActionButton: const MyFlowExcelInnerButton(),
        body: Container(
          decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(4.0),
              color: Colors.grey[300]),
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                buildTitleBlock("Позиция", "Сумма(руб.)"),
                ExpansionPanelList(
                  expandedHeaderPadding: const EdgeInsets.all(0.0),
                  elevation: 6,
                  dividerColor: Colors.black,
                  children: listWidget,
                  expansionCallback: (i, isOpen) {
                    setState(() {
                      _isOpen[i] = isOpen;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return const SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Text("Щит не найден"),
        ),
      );
    }
  }
}

class CalculateExpansionPanel extends ExpansionPanel {
  CalculateExpansionPanel({
    required List<CalculateShieldItem> list,
    required super.isExpanded,
  }) : super(
          headerBuilder: (_, _2) => buildExpansionHeader(list[0].title, list[0].cost),
          body: buildExpansionBody(list),
          canTapOnHeader: true,
          backgroundColor: isExpanded ? Colors.white : Colors.blue[100],
        );
}

Widget buildTitleBlock(String title, String summTitle) {
  //ExpansionPanel(backgroundColor: Colors.deepOrange)
  return Row(
    children: [
      Container(
        constraints: BoxConstraints(
          minWidth: 400,
          minHeight: minFieldHeight / 1.5,
        ),
        alignment: AlignmentDirectional.centerStart,
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 0),
          child: MyImmutableTextField(
            text: title,
            style: ToolThemeDataHolder.defFillConstTextStyle,
          ),
        ),
      ),
      Flexible(
        child: Container(
          width: double.infinity,
          height: minFieldHeight / 1.5,
          alignment: AlignmentDirectional.center,
          child: InkWell(
            onTap: () {
              ShieldDataViewModel.instance.orderDataList();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 60.0, bottom: 0),
                    child: MyImmutableTextField(
                      text: summTitle,
                      style: ToolThemeDataHolder.defFillTextDataStyle,
                    ),
                  ),
                ),
                ShieldDataViewModel.instance.isOrdered == null
                    ? const Icon(Icons.horizontal_rule)
                    : ShieldDataViewModel.instance.isOrdered! == true
                        ? const Icon(Icons.keyboard_arrow_up)
                        : const Icon(Icons.keyboard_arrow_down)
              ],
            ),
          ),
        ),
      ),
    ],
  );
}

Widget buildExpansionHeader(String title, double summ) {
  return Row(
    children: [
      Flexible(
        child: Container(
          constraints: BoxConstraints(
            minWidth: 320,
            minHeight: minFieldHeight / 1.5,
          ),
          alignment: AlignmentDirectional.centerStart,
          child: Padding(
            padding: const EdgeInsets.only(left: 28.0, bottom: 0),
            child: MyImmutableTextField(
              text: title,
              style: ToolThemeDataHolder.defConstTextStyle,
            ),
          ),
        ),
      ),
      Flexible(
        child: Container(
          width: double.infinity,
          height: minFieldHeight * 1.2,
          alignment: AlignmentDirectional.center,
          child: Padding(
            padding: const EdgeInsets.only(left: 200.0, bottom: 0),
            child: Container(
              color: Colors.white,
              width: 135,
              height: minFieldHeight * 1.2,
              child: Center(
                child: MyImmutableTextField(
                  copyText: summ.toString(),
                  text: ToolHelpData.separateThousandString(summ),
                  style: ToolThemeDataHolder.defConstTextStyle,
                ),
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

Widget buildExpansionBody(List<CalculateShieldItem> list) {
  List<Widget> wList = [];
  for (var i = 1; i < list.length; i++) {
    wList.add(buildShowDataItem(title: list[i].title, cost: list[i].cost));
  }

  return Column(
    children: wList,
  );
}

Widget buildShowDataItem({
  required String title,
  required double cost,
}) {
  return InkWell(
    onTap: () {},
    hoverColor: Colors.grey[300],
    child: DecoratedBox(
      position: DecorationPosition.foreground,
      decoration: BoxDecoration(
        border: Border.all(width: 0.7),
        borderRadius: BorderRadius.circular(3.0),
      ),
      child: Row(
        children: [
          Container(
            color: Colors.grey[300],
            constraints: BoxConstraints(
              minWidth: 460,
              minHeight: minFieldHeight / 1.2,
            ),
            alignment: AlignmentDirectional.centerStart,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 0),
              child: MyImmutableTextField(
                text: title,
                style: ToolThemeDataHolder.defFillConstTextStyle,
              ),
            ),
          ),
          Flexible(
            child: Container(
              width: double.infinity,
              height: minFieldHeight / 1.2,
              alignment: AlignmentDirectional.center,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, bottom: 0),
                child: MyImmutableTextField(
                  text: cost.toString(),
                  style: ToolThemeDataHolder.defFillTextDataStyle,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
