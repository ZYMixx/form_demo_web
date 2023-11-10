import 'package:flutter/material.dart';
import 'package:form_demo_web/data/tools/tool_navigator.dart';
import 'package:form_demo_web/data/tools/tool_theme_data.dart';
import 'package:form_demo_web/domain/db_form_entity/konstr_form.dart';
import 'package:form_demo_web/presentation/connect_db_screen.dart';
import 'package:form_demo_web/presentation/my_widgets/my_text_from_field.dart';
import 'package:form_demo_web/presentation/view_models/shield_data_view_model.dart';
import 'package:form_demo_web/presentation/work_space_screen.dart';

import '../../my_widgets/сhoose_data_list_view_item.dart';

//![image_comment](/image_comment/img_ChooseShieldParmsWidget.png)

class ChooseShieldParmsWidget extends StatelessWidget {
  const ChooseShieldParmsWidget({
    Key? key,
    required this.callBack,
    required this.dataList,
  }) : super(key: key);

  final Function(dynamic) callBack;
  final Future<List<dynamic>> dataList;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(4.0),
          color: Colors.grey[200],
          boxShadow: [ToolThemeDataHolder.defShadowBox]),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: FutureBuilder(
          future: dataList,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                );
              default:
                if (snapshot.hasError) {
                  return InkWell(
                    onTap: () => {
                      ShieldDataViewModel.instance.dispose(),
                      ToolNavigator.push(ConnectDbScreen(
                        screen: WorkSpaceScreen(),
                      ))
                    },
                    child: Text("Error: ${snapshot.error}"),
                  );
                  //ЗДЕСЬ
                } else {
                  var dataList = snapshot.data as List<dynamic>;
                  return HeightChooseWidget(dataList: dataList, callBack: callBack);
                }
            }
          },
        ),
      ),
    );
  }
}

class HeightChooseWidget extends StatefulWidget {
  const HeightChooseWidget({
    super.key,
    required this.dataList,
    required this.callBack,
  });

  final List dataList;
  final Function(dynamic p1) callBack;

  @override
  State<HeightChooseWidget> createState() =>
      _HeightChooseWidgetState(needSearch: dataList.length > 10);
}

class _HeightChooseWidgetState extends State<HeightChooseWidget> {
  final bool needSearch;
  List<dynamic> sortedDataList = [];

  _HeightChooseWidgetState({required this.needSearch});

  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    sortedDataList.addAll(widget.dataList);
  }

  @override
  Widget build(BuildContext context) {
    controller.addListener(() {
      String searchString = controller.text;
      List<KonstrForm> list = [];
      for (var dataItem in widget.dataList) {
        if (dataItem.runtimeType == KonstrForm) {
          if ((dataItem as KonstrForm).height.toString().startsWith(searchString)) {
            list.add(dataItem);
          }
        } else {
          list.add(dataItem);
        }
      }
      sortedDataList = [];
      sortedDataList.addAll(list);
      setState(() {});
    });
    return Column(
      children: [
        if (needSearch)
          Container(
            height: 20,
            color: Colors.white,
            child: MyTextFormField(
              controller: controller,
              numbOnly: true,
              hint: 'поиск',
            ),
          ),
        Expanded(
          child: ListView.builder(
            itemCount: sortedDataList.length,
            itemBuilder: (context, itemId) {
              return buildDataBlock(
                sortedDataList[itemId],
                widget.callBack,
              );
            },
          ),
        ),
      ],
    );
  }
}

// задаём параметры отображающиеся на кнопке и данные которые передадутся по callback
Widget buildDataBlock(dynamic dataItem, Function(dynamic) callBack) {
  var text;
  Function setterCallBack = () {};
  if (dataItem.runtimeType == String) {
    text = dataItem;
    setterCallBack = () {
      callBack(text);
    };
  }
  if (dataItem.runtimeType == KonstrForm) {
    var item = (dataItem as KonstrForm);
    text = "${item.height} ${item.comment}";
    setterCallBack = () {
      callBack(item);
    };
  }
  return ChooseDataListViewItem(setterCallBack: setterCallBack, text: text);
}
