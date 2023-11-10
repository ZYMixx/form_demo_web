import 'package:flutter/material.dart';
import 'package:form_demo_web/data/services/service_specif_sort_calculate_data.dart';
import 'package:form_demo_web/data/tools/tool_help_data.dart';
import 'package:form_demo_web/data/tools/tool_theme_data.dart';
import 'package:form_demo_web/domain/calculate_item.dart';
import 'package:form_demo_web/presentation/my_widgets/my_animated_card.dart';
import 'package:form_demo_web/presentation/my_widgets/my_flow_excel_button.dart';
import 'package:form_demo_web/presentation/my_widgets/my_immutable_text_field.dart';
import 'package:form_demo_web/presentation/shield_screen/left_block_work_widgets/shield_data_builder.dart';
import 'package:form_demo_web/presentation/view_models/result_specif_calclulate_view_model.dart';
import 'package:provider/provider.dart';

late ResultSpecifCalculateViewModel _resultViewModel;

class CalculateSpecificationScreen extends StatelessWidget {
  const CalculateSpecificationScreen({Key? key, required this.resultViewModel}) : super(key: key);
  final ResultSpecifCalculateViewModel resultViewModel;

  @override
  Widget build(BuildContext context) {
    _resultViewModel = resultViewModel;
    return const CalculateDataExpansionPanel();
  }
}

class CalculateDataExpansionPanel extends StatefulWidget {
  const CalculateDataExpansionPanel({Key? key}) : super(key: key);

  @override
  State<CalculateDataExpansionPanel> createState() => _CalculateDataExpansionPanelState();
}

class _CalculateDataExpansionPanelState extends State<CalculateDataExpansionPanel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Scrollbar(
          child: ChangeNotifierProvider(
            create: (_) => _resultViewModel,
            child: CalculateDataPanel(listCalculateData: _resultViewModel.listCalculateData),
          ),
        ),
      ),
      floatingActionButton: MyFlowExcelInnerButton(),
    );
  }
}

class CalculateDataPanel extends StatefulWidget {
  const CalculateDataPanel({Key? key, required this.listCalculateData}) : super(key: key);
  final List<ServiceSpecifSortCalculateData> listCalculateData;

  @override
  State<CalculateDataPanel> createState() => _CalculateDataPanelState();
}

class _CalculateDataPanelState extends State<CalculateDataPanel> {
  List<bool> _isOpen = [];

  @override
  Widget build(BuildContext context) {
    context.select((ResultSpecifCalculateViewModel vm) => vm.isOrdered);
    ServiceSpecifSortCalculateData? sortData = widget.listCalculateData[0];
    List<ServiceSpecifSortCalculateData> sortDataTest = widget.listCalculateData;
    List<CalculateExpansionPanel> listWidget = [];
    _resultViewModel.clearCopyDataMap();
    if (sortData != null) {
      for (var i = 0; i < sortData.listAllSortCalculateData.length; i++) {
        if (_isOpen.length < sortData.listAllSortCalculateData.length) {
          _isOpen.add(false);
        }
        List<List<CalculateShieldItem>> list = [];
        for (var item in sortDataTest) {
          list.add(item.listAllSortCalculateData[i]);
        }
        listWidget.add(CalculateExpansionPanel(list: list, isExpanded: _isOpen[i]));
      }
    }
    return Container(
      decoration: BoxDecoration(
          border: Border.all(), borderRadius: BorderRadius.circular(4.0), color: Colors.grey[300]),
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
    );
  }
}

double takeFromAllList(List<List<CalculateShieldItem>> list, int index) {
  double summ = 0;
  for (var item in list) {
    summ += item[index].cost;
  }
  return summ;
}

Map<String, double> takeTitleFromAllList(List<List<CalculateShieldItem>> list) {
  double cost = 0;
  List<List<double>> secondaryList = [];
  String unitedTitle = list[0][0].title;
  Set<String> setName = {};

  for (var listInList in list) {
    setName.add(listInList[0].name);
  }
  for (var itemName in setName) {
    for (var i = 0; i < list.length; i++) {
      if (list[i][0].name == itemName) {
        cost += list[i][0].cost;
        secondaryList.add(list[i][0].secondaryData);
        cost = double.parse(cost.toStringAsFixed(2));
        if (secondaryList.isNotEmpty) {
          var unitedList = ServiceSpecifSortCalculateData.createUnitedTitle(secondaryList);
          unitedTitle =
              ServiceSpecifSortCalculateData.replaceTitleValue(list[0][0].name, unitedList);
        }
      }
    }
  }
  return {unitedTitle: cost};
}

class CalculateExpansionPanel extends ExpansionPanel {
  CalculateExpansionPanel({
    required List<List<CalculateShieldItem>> list,
    required super.isExpanded,
  }) : super(
          headerBuilder: (_, _2) => buildExpansionHeader(takeTitleFromAllList(list)),
          body: buildExpansionBody(list),
          canTapOnHeader: true,
          backgroundColor: isExpanded ? Colors.white : Colors.blue[100],
        );
}

Widget buildTitleBlock(String title, String summTitle) {
  Key key = UniqueKey();
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
          child: Text(
            title,
          ),
        ),
      ),
      Flexible(
        child: Container(
          width: double.infinity,
          height: minFieldHeight / 1.5,
          alignment: AlignmentDirectional.center,
          child: InkWell(
            key: key,
            onTap: () {
              _resultViewModel.orderDataList();
            },
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 60.0, bottom: 0),
                  child: Text(
                    summTitle,
                  ),
                ),
                _resultViewModel.isOrdered == null
                    ? const Icon(Icons.horizontal_rule)
                    : _resultViewModel.isOrdered! == true
                        ? const Icon(Icons.keyboard_arrow_down)
                        : const Icon(Icons.keyboard_arrow_up)
              ],
            ),
          ),
        ),
      ),
    ],
  );
}

//![ExpansionHeader](/image_comment/buildExpansionHeader.png)
Widget buildExpansionHeader(Map<String, double> dataMap) {
  String title = dataMap.keys.first;
  double summ = dataMap.values.first;
  return MyAnimatedCard(
    intensity: 0.001,
    child: Row(
      children: [
        Container(
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
        Flexible(
          child: Container(
            width: double.infinity,
            height: minFieldHeight / 0.85,
            alignment: AlignmentDirectional.center,
            child: Padding(
              padding: const EdgeInsets.only(left: 200.0, bottom: 0),
              child: Container(
                color: Colors.white,
                width: 135,
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
    ),
  );
}

Widget buildExpansionBody(List<List<CalculateShieldItem>> list) {
  List<ShowDataItem> wList = [];
  double cost = 0;
  List<List<double>> secondaryList = [];
  String unitedTitle = list[0][0].title;
  Set<String> setName = {};
  List<String> listDetailInfo = [];
  Map<String, double> copyResultMap = {};
  for (var listInList in list) {
    for (var i = 1; i < listInList.length; i++) {
      setName.add(listInList[i].name);
    }
  }
  var titleMap = takeTitleFromAllList(list);
  copyResultMap[titleMap.keys.first] = titleMap.values.first;
  for (var itemName in setName) {
    for (var j = 0; j < list.length; j++) {
      for (var i = 0; i < list[j].length; i++) {
        if (list[j][i].name == itemName) {
          listDetailInfo.add("${list[j][i].shieldFullName} : ${list[j][i].cost}");
          cost += list[j][i].cost;
          secondaryList.add(list[j][i].secondaryData);
          cost = double.parse(cost.toStringAsFixed(2));
          if (secondaryList.isNotEmpty) {
            var unitedList = ServiceSpecifSortCalculateData.createUnitedTitle(secondaryList);
            unitedTitle = ServiceSpecifSortCalculateData.replaceTitleValue(itemName, unitedList);
          }
        }
      }
    }
    List<String> myList = [];
    for (var itemCalculateData in _resultViewModel.listCalculateData) {
      for (var item in listDetailInfo) {
        if (item.contains(itemCalculateData.shieldData.konstrData.konstr.fullName)) {
          myList.add("${itemCalculateData.itemCount} x $item");
        }
      }
    }
    copyResultMap[unitedTitle] = cost;
    wList.add(ShowDataItem(title: unitedTitle, cost: cost, listDetailInfo: myList));
    cost = 0;
    secondaryList = [];
    listDetailInfo = [];
  }

  _resultViewModel.setCopyResultMap(copyResultMap: copyResultMap);
  return Column(
    children: _resultViewModel.orderWidgetList(widgetList: wList),
  );
}

class ShowDataItem extends StatefulWidget {
  ShowDataItem({
    required this.title,
    required this.cost,
    required this.listDetailInfo,
    super.key,
  });

  final String title;
  final double cost;
  final List<String> listDetailInfo;

  @override
  State<ShowDataItem> createState() => _ShowDataItemState();
}

class _ShowDataItemState extends State<ShowDataItem> with SingleTickerProviderStateMixin {
  bool isPresse = false;

  late AnimationController _controller;
  var tweenOpacity = Tween<double>(begin: 0.2, end: 1.0);
  var tweenOffset = Tween(begin: const Offset(0.0, 0.0), end: const Offset(0.0, 0.07));

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000))
      ..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var text = '';
    for (var item in widget.listDetailInfo) {
      text += "$item\n";
    }
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: SlideTransition(
        position: tweenOffset.animate(_controller),
        child: FadeTransition(
          opacity: tweenOpacity.animate(_controller),
          child: InkWell(
            onTap: () {
              setState(() {
                isPresse = !isPresse;
              });
            },
            hoverColor: Colors.grey[300],
            child: DecoratedBox(
              position: DecorationPosition.foreground,
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                        text: widget.title,
                        style: ToolThemeDataHolder.defFillConstTextStyle,
                      ),
                    ),
                  ),
                  Flexible(
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          height: minFieldHeight / 1.2,
                          alignment: AlignmentDirectional.center,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0, bottom: 0),
                            child: MyImmutableTextField(
                              copyText: widget.cost.toString(),
                              text: ToolHelpData.separateThousandString(widget.cost),
                              style: ToolThemeDataHolder.defFillTextDataStyle,
                            ),
                          ),
                        ),
                        if (isPresse)
                          Row(
                            children: [
                              MyImmutableTextField(
                                text: text,
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
