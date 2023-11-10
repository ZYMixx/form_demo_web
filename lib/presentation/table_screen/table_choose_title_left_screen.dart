import 'package:flutter/material.dart';
import 'package:form_demo_web/data/tools/tool_theme_data.dart';
import 'package:form_demo_web/presentation/my_widgets/my_animated_card.dart';
import 'package:form_demo_web/presentation/shield_screen/left_block_work_widgets/shield_data_builder.dart';
import 'package:form_demo_web/presentation/view_models/table_view_model.dart';
import 'package:provider/provider.dart';

class TableChooseTitleLeftScreen extends StatelessWidget {
  const TableChooseTitleLeftScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TableViewModel.instance,
      child: ExpansionDataPanel(
        listWidget: [],
      ),
    );
  }
}

class ExpansionDataPanel extends StatefulWidget {
  List<MyTableExpansionPanel> listWidget;

  ExpansionDataPanel({Key? key, required this.listWidget}) : super(key: key);

  @override
  State<ExpansionDataPanel> createState() => _ExpansionDataPanelState();
}

class _ExpansionDataPanelState extends State<ExpansionDataPanel> {
  List<MyTableExpansionPanel> listExpansionWidget = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    buildAllPanelWidgets();
    return Container(
      decoration: BoxDecoration(
          border: Border.all(), borderRadius: BorderRadius.circular(4.0), color: Colors.grey[300]),
      child: SingleChildScrollView(
        child: Column(
          children: [
            buildTitleBlock("Позиция"),
            ExpansionPanelList(
              expandedHeaderPadding: EdgeInsets.all(0.0),
              elevation: 6,
              dividerColor: Colors.black,
              children: listExpansionWidget,
              expansionCallback: (i, isOpen) {
                setState(() {
                  TableViewModel.instance.expansionIsOpen[i] = isOpen;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  buildAllPanelWidgets() {
    var i = 0;
    listExpansionWidget = [];
    for (var titleName in TableViewModel.instance.mapExpansionData.keys) {
      MyTableExpansionPanel panel = MyTableExpansionPanel(
          title: titleName,
          list: TableViewModel.instance.mapExpansionData[titleName]!,
          isExpanded: TableViewModel.instance.expansionIsOpen[i++]);
      listExpansionWidget.add(panel);
    }
  }

  Widget buildTitleBlock(String title) {
    int minFieldHeight = 60;
    return Container(
      constraints: BoxConstraints(
        minWidth: 400,
        minHeight: minFieldHeight / 1.5,
      ),
      alignment: AlignmentDirectional.centerStart,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, bottom: 0),
        child: Text(
          title,
          //style: ToolThemeDataHolder.defFillConstTextStyle,
        ),
      ),
    );
  }
}

class MyTableExpansionPanel extends ExpansionPanel {
  MyTableExpansionPanel({
    required String title,
    required List<String> list,
    required super.isExpanded,
  }) : super(
          headerBuilder: (_, _2) => buildExpansionHeader(title),
          body: buildExpansionBody(list),
          canTapOnHeader: true,
          backgroundColor: isExpanded ? Colors.white : Colors.blue[100],
        );
}

Widget buildExpansionHeader(String title) {
  return Row(
    children: [
      MyAnimatedCard(
        intensity: 0.005,
        child: Container(
          constraints: BoxConstraints(
            minWidth: 320,
            minHeight: minFieldHeight / 1.5,
          ),
          alignment: AlignmentDirectional.centerStart,
          child: Padding(
            padding: const EdgeInsets.only(left: 28.0, bottom: 0),
            child: Text(
              title,
              style: ToolThemeDataHolder.defConstTextStyle,
            ),
          ),
        ),
      ),
    ],
  );
}

Widget buildExpansionBody(List<String> list) {
  List<Widget> wList = [];
  for (var i = 0; i < list.length; i++) {
    wList.add(buildShowDataItem(title: list[i]));
  }

  return Column(
    children: wList,
  );
}

Widget buildShowDataItem({
  required String title,
}) {
  return ShowDataItem(title: title);
}

class ShowDataItem extends StatelessWidget {
  const ShowDataItem({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    String? selectTitle =
        context.select((TableViewModel vm) => TableViewModel.instance.titleSelected);
    return DecoratedBox(
      position: DecorationPosition.foreground,
      decoration: BoxDecoration(
        border: Border.all(width: 0.7),
        borderRadius: BorderRadius.circular(3.0),
      ),
      child: Row(
        children: [
          Flexible(
            child: Material(
              color: selectTitle == title ? Colors.blue[300] : Colors.grey[50],
              child: InkWell(
                onTap: () => TableViewModel.instance.onTitleItemPressed(title),
                hoverColor: selectTitle == title ? Colors.blue[400] : Colors.grey[300],
                child: Container(
                  constraints: BoxConstraints(
                    minHeight: minFieldHeight,
                  ),
                  alignment: AlignmentDirectional.centerStart,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 18.0, bottom: 0),
                    child: Center(
                      child: Text(
                        title,
                        style: ToolThemeDataHolder.defFillTextDataStyle,
                      ),
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
}
