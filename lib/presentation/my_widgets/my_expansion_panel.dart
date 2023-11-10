import 'package:flutter/material.dart';
import 'package:form_demo_web/data/tools/tool_theme_data.dart';
import 'package:form_demo_web/presentation/my_widgets/my_animated_card.dart';
import 'package:form_demo_web/presentation/my_widgets/my_immutable_text_field.dart';
import 'package:form_demo_web/presentation/shield_screen/left_block_work_widgets/shield_data_builder.dart';

class MyExpansionPanel extends StatefulWidget {
  final List<Widget> listWidget;
  final String panelTitle;
  final Widget? buttonWidget;

  const MyExpansionPanel({
    Key? key,
    required this.listWidget,
    required this.panelTitle,
    this.buttonWidget,
  }) : super(key: key);

  @override
  State<MyExpansionPanel> createState() => _MyExpansionPanelState();
}

class _MyExpansionPanelState extends State<MyExpansionPanel> {
  bool _isOpen = false;
  List<CustomExpansionPanel> _listCustomExpansionPanel = [];

  @override
  Widget build(BuildContext context) {
    _listCustomExpansionPanel = [];
    _listCustomExpansionPanel.add(
      CustomExpansionPanel(
        list: widget.listWidget,
        isExpanded: _isOpen,
        panelTitle: widget.panelTitle,
        buttonWidget: widget.buttonWidget,
      ),
    );
    return Container(
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(4.0),
        color: Colors.grey[300],
      ),
      child: ExpansionPanelList(
        expandedHeaderPadding: EdgeInsets.all(0.0),
        elevation: 6,
        dividerColor: Colors.black,
        children: _listCustomExpansionPanel,
        expansionCallback: (i, isOpen) {
          setState(() {
            _isOpen = isOpen;
            setState(() {});
          });
        },
      ),
    );
  }
}

class CustomExpansionPanel extends ExpansionPanel {
  CustomExpansionPanel({
    required List<Widget> list,
    required String panelTitle,
    Widget? buttonWidget,
    required super.isExpanded,
  }) : super(
          headerBuilder: (_, _2) => buildExpansionHeader(panelTitle),
          body: buildExpansionBody(list, buttonWidget),
          canTapOnHeader: true,
          backgroundColor: isExpanded ? Colors.white : Colors.blue[100],
        );
}

Widget buildExpansionHeader(String title) {
  return Row(
    children: [
      MyAnimatedCard(
        intensity: 0.001,
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
    ],
  );
}

Widget buildExpansionBody(List<Widget> listWidget, Widget? buttonWidget) {
  int listSize = buttonWidget == null ? listWidget.length : listWidget.length + 1;
  double mHeight = (minFieldHeight + 6) / 1.5 * listSize;
  return Container(
    padding: EdgeInsets.only(left: 10, right: 10),
    constraints: BoxConstraints(
      maxHeight: mHeight > 500 ? 500 : mHeight, // ограничиваем максимальную высоту контейнера
    ),
    child: ScrollbarTheme(
      data: ScrollbarThemeData(
        thumbColor: MaterialStateProperty.all<Color>(ToolThemeDataHolder.mainCardColor),
        thumbVisibility: MaterialStateProperty.all<bool>(true),
      ),
      child: ListView.builder(
        itemCount: listSize,
        padding: EdgeInsets.only(right: 10.0),
        itemBuilder: (context, itemId) {
          if (buttonWidget != null && itemId == listSize - 1) {
            return buttonWidget;
          }
          return listWidget[itemId];
        },
      ),
    ),
  );
  //return Column(children: listWidget);
}
