import 'package:flutter/material.dart';
import 'package:form_demo_web/data/tools/tool_help_data.dart';
import 'package:form_demo_web/data/tools/tool_theme_data.dart';
import 'package:form_demo_web/presentation/my_widgets/my_immutable_text_field.dart';
import 'package:form_demo_web/presentation/my_widgets/my_text_from_field.dart';
import 'package:form_demo_web/presentation/view_models/bracket_data_view_model.dart';
import 'package:provider/provider.dart';

class BracketProducedRightScreen extends StatelessWidget {
  const BracketProducedRightScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.select((BracketDataViewModel vm) => vm.producedBracket);
    context.select((BracketDataViewModel vm) => vm.additionCalculateNumber);
    Map<String, SpendMaterial> materialProduceMap =
        BracketDataViewModel.instance.getMaterialProduceMap();
    List<String> keyList = materialProduceMap.keys.toList();
    return Padding(
      padding: const EdgeInsets.only(top: 6.0, left: 25, right: 40),
      child: ListView.builder(
        itemCount: keyList.length + 2,
        itemBuilder: (context, itemId) {
          if (itemId == 0) {
            return buildTitleRow();
          }
          if (itemId == keyList.length + 1) {
            return const AdditionDataListView();
          }
          return ProducedItem(
              title: keyList[itemId - 1], spendMaterial: materialProduceMap[keyList[itemId - 1]]!);
        },
      ),
    );
  }

  Widget buildTitleRow() {
    var boxDecoration = BoxDecoration(
      color: Colors.grey[300],
      border: Border.all(color: Colors.transparent),
      borderRadius: BorderRadius.circular(12.0),
    );

    Function titleCell = (String text) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1.5, vertical: 2),
          child: DecoratedBox(
            decoration: boxDecoration,
            child: Center(
              child: MyImmutableTextField(
                text: text,
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
        );
    return Row(
      children: [
        Flexible(
          fit: FlexFit.tight,
          flex: 3,
          child: titleCell('Материал'),
        ),
        Flexible(
          fit: FlexFit.tight,
          flex: 2,
          child: titleCell('КГ'),
        ),
        Flexible(
          fit: FlexFit.tight,
          flex: 2,
          child: titleCell('МП'),
        ),
        const Flexible(flex: 1, fit: FlexFit.tight, child: SizedBox()),
        Flexible(
          fit: FlexFit.tight,
          flex: 2,
          child: titleCell('Склад'),
        ),
        Flexible(
          fit: FlexFit.tight,
          flex: 2,
          child: titleCell('Остаток'),
        )
      ],
    );
  }
}

class AdditionDataListView extends StatefulWidget {
  const AdditionDataListView({Key? key}) : super(key: key);

  @override
  State<AdditionDataListView> createState() => _AdditionDataListViewState();
}

class _AdditionDataListViewState extends State<AdditionDataListView> {
  late TextEditingController additionTextController;

  @override
  void initState() {
    super.initState();
    additionTextController = TextEditingController();
    additionTextController.text = BracketDataViewModel.instance.additionCalculateNumber.toString();
    additionTextController.addListener(() {
      BracketDataViewModel.instance
          .setAdditionCalculateNumber(int.tryParse(additionTextController.text));
    });
  }

  @override
  Widget build(BuildContext context) {
    int additionCalculateNumber =
        context.select((BracketDataViewModel vm) => vm.additionCalculateNumber);
    Map<String, int> additionCalculateMap = BracketDataViewModel.instance.getAdditionCalculateMap();
    List<String> keyList = additionCalculateMap.keys.toList();
    TransformationController transformationController = TransformationController();
    try {
      return InteractiveViewer(
        transformationController: transformationController,
        child: Container(
          height: 200 + additionCalculateMap.length * 18,
          width: double.infinity,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: Divider(
                  height: 5,
                  thickness: 2,
                  color: ToolThemeDataHolder.mainCardColor.withOpacity(0.7),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 6.0, top: 2.0),
                child: Text('Дополнительно: ', style: TextStyle(fontSize: 16)),
              ),
              buildUserInputRow(),
              const SizedBox(height: 15),
              Flexible(
                child: ListView.builder(
                  itemCount: additionCalculateMap.length,
                  itemBuilder: (context, itemId) {
                    return buildDataRow(
                        name: keyList[itemId],
                        calculateCount: additionCalculateMap[keyList[itemId]] ?? 111);
                  },
                ),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      print('eroro $e');
      return const Text("ERORO");
    }
  }

  Widget buildUserInputRow() {
    return Row(
      children: [
        Flexible(
          flex: 3,
          fit: FlexFit.tight,
          child: buildDataCell(
            color: ToolThemeDataHolder.mainLightCardColor.withOpacity(0.8),
            child: const MyImmutableTextField(
              text: 'Метров на м.п.',
              style: TextStyle(fontSize: 22),
            ),
          ),
        ),
        Flexible(
          flex: 2,
          fit: FlexFit.tight,
          child: buildDataCell(
            color: ToolThemeDataHolder.mainLightCardColor.withOpacity(0.6),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: MyTextFormField(
                numbOnly: true,
                textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                controller: additionTextController,
              ),
            ),
          ),
        ),
        const Flexible(flex: 7, fit: FlexFit.tight, child: SizedBox()),
      ],
    );
  }

  Widget buildDataRow({required String name, required int calculateCount}) {
    return Row(
      children: [
        Flexible(
          flex: 3,
          fit: FlexFit.tight,
          child: buildDataCell(
            child: MyImmutableTextField(
              text: name,
              style: const TextStyle(fontSize: 22),
            ),
          ),
        ),
        Flexible(
          flex: 2,
          fit: FlexFit.tight,
          child: buildDataCell(
            child: MyImmutableTextField(
              text: calculateCount.toString(),
              style: const TextStyle(fontSize: 22),
            ),
          ),
        ),
        const Flexible(flex: 2, fit: FlexFit.tight, child: SizedBox()),
        const Flexible(flex: 5, fit: FlexFit.tight, child: SizedBox()),
      ],
    );
  }
}

class ProducedItem extends StatefulWidget {
  const ProducedItem({Key? key, required this.title, required this.spendMaterial})
      : super(key: key);
  final String title;
  final SpendMaterial spendMaterial;

  @override
  State<ProducedItem> createState() => _ProducedItemState();
}

class _ProducedItemState extends State<ProducedItem> {
  late TextEditingController textController;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
    textController.text = widget.spendMaterial.historySupply ?? '';
    textController.addListener(() {
      if (widget.spendMaterial.historySupply != textController.text) {
        BracketDataViewModel.instance
            .saveHistoryBracketSupply(name: widget.title, data: textController.text);
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Row(
        children: [
          Flexible(
            fit: FlexFit.tight,
            flex: 3,
            child: buildDataCell(
              child: MyImmutableTextField(
                text: widget.title,
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
          Flexible(
            fit: FlexFit.tight,
            flex: 2,
            child: buildDataCell(
              child: MyImmutableTextField(
                text: ToolHelpData.separateThousandString(widget.spendMaterial.kgSpend),
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
          Flexible(
            fit: FlexFit.tight,
            flex: 2,
            child: buildDataCell(
              child: MyImmutableTextField(
                text: widget.spendMaterial.mpSpend != null
                    ? ToolHelpData.separateThousandString(widget.spendMaterial.mpSpend!)
                    : '',
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
          const Flexible(flex: 1, fit: FlexFit.tight, child: SizedBox()),
          Flexible(
            fit: FlexFit.tight,
            flex: 2,
            child: buildDataCell(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: MyTextFormField(
                  numbOnly: true,
                  controller: textController,
                  textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Flexible(
            fit: FlexFit.tight,
            flex: 2,
            child: buildDataCell(
              child: MyImmutableTextField(
                text: textController.text == ''
                    ? ''
                    : (double.parse(textController.text) - widget.spendMaterial.kgSpend)
                        .toStringAsFixed(1),
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget buildDataCell({required Widget child, Color? color}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 2),
    child: DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(),
        color: color ?? Colors.grey[100],
        borderRadius: BorderRadius.circular(3.0),
      ),
      child: Center(child: child),
    ),
  );
}
