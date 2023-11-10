import 'package:flutter/material.dart';
import 'package:form_demo_web/data/services/service_bracket_calculate.dart';
import 'package:form_demo_web/data/tools/tool_double_round.dart';
import 'package:form_demo_web/data/tools/tool_help_data.dart';
import 'package:form_demo_web/data/tools/tool_theme_data.dart';
import 'package:form_demo_web/presentation/bracket_screen/bracket_produced_right_screen.dart';
import 'package:form_demo_web/presentation/launch_screen.dart';
import 'package:form_demo_web/presentation/my_widgets/my_animated_card.dart';
import 'package:form_demo_web/presentation/my_widgets/my_immutable_text_field.dart';
import 'package:form_demo_web/presentation/my_widgets/my_widget_button.dart';
import 'package:form_demo_web/presentation/view_models/bracket_data_view_model.dart';
import 'package:form_demo_web/presentation/view_models/table_view_model.dart';
import 'package:provider/provider.dart';

class BracketRightDataPanel extends StatefulWidget {
  const BracketRightDataPanel({Key? key}) : super(key: key);

  @override
  State<BracketRightDataPanel> createState() => _BracketRightDataPanelState();
}

class _BracketRightDataPanelState extends State<BracketRightDataPanel>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      if (_tabController.index == 0) {
        BracketDataViewModel.instance.changeBracketTab(tab: BracketTabEnum.rentability);
      }
      if (_tabController.index == 1) {
        BracketDataViewModel.instance.changeBracketTab(tab: BracketTabEnum.produced);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
    switch (BracketDataViewModel.instance.selectedTab) {
      case BracketTabEnum.rentability:
        _tabController.index = 0;
        break;
      case BracketTabEnum.produced:
        _tabController.index = 1;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    TabBar tabs = TabBar(
      controller: _tabController,
      tabs: const [
        Tab(text: 'Рентабельность'),
        Tab(text: 'Произведено'),
      ],
    );
    return ChangeNotifierProvider(
      create: (_) => BracketDataViewModel.instance,
      child: Theme(
        data: ThemeData(
          tabBarTheme: TabBarTheme(
            unselectedLabelStyle: ToolThemeDataHolder.defFillTextDataStyle.copyWith(fontSize: 17),
            labelStyle: ToolThemeDataHolder.defConstTextStyle.copyWith(fontSize: 21),
            unselectedLabelColor: Colors.white70,
            indicator: BoxDecoration(
              border: Border.all(color: Colors.black, width: 1.0),
              borderRadius: BorderRadius.circular(4.0),
              color: ToolThemeDataHolder.mainCardColor.withAlpha(100),
            ),
            labelColor: Colors.white,
          ),
        ),
        child: Column(
          children: [
            Material(
              elevation: 2,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: ToolThemeDataHolder.mainLightCardColor,
                  border: Border.all(color: Colors.black, width: 1.0),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: tabs,
              ),
            ),
            Flexible(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  CountBracketDataWidget(),
                  ProducedBracketDataWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CountBracketDataWidget extends StatelessWidget {
  const CountBracketDataWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BracketCalculateItem bracketCalculate =
        context.select((BracketDataViewModel vm) => vm.bracketCalculateItem);
    int targetRentabel = context.select((BracketDataViewModel vm) => vm.targetRentability);
    return Padding(
      padding: const EdgeInsets.only(right: 50, left: 40),
      child: Row(
        children: [
          Flexible(
            flex: 2,
            child: Column(
              children: [
                buildColumnDivaider(text: 'Цена'),
                buildShowDataItem(
                  title: "Цена 1-шт",
                  value: ToolDoubleRound.round(number: bracketCalculate.getSumCostWithOutVat()),
                  height: 80,
                  numAnimation: true,
                ),
                buildShowDataItem(
                  title: "Цена **с НДС**",
                  value:
                      ToolDoubleRound.round(number: bracketCalculate.getSumCostWithOutVat() * 1.20),
                  height: 80,
                  numAnimation: true,
                ),
                const SizedBox(height: 10),
                buildColumnDivaider(text: 'Рентабельность'),
                buildShowDataItem(
                  title: "**${targetRentabel}**-%",
                  value: ToolDoubleRound.round(
                    number: bracketCalculate.getSumCostWithVat() * ((100 + targetRentabel) / 100),
                  ),
                  height: 80,
                  numAnimation: true,
                ),
                for (int numRent in [5, 10, 15, 20])
                  buildShowDataItem(
                    title: "**$numRent**-%",
                    value: ToolDoubleRound.round(
                      number: bracketCalculate.getSumCostWithVat() * ((100 + numRent) / 100),
                    ),
                    height: 60,
                    numAnimation: true,
                  ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          Flexible(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Container(
                alignment: Alignment.topCenter,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      buildColumnDivaider(text: 'Затраты'),
                      buildDataInfoColumn(
                          dataMap: bracketCalculate.materialCostMap,
                          summ: bracketCalculate.sumMaterial),
                      buildDataInfoColumn(
                          dataMap: bracketCalculate.salaryWorkCostMap,
                          summ: bracketCalculate.sumSalaryWork),
                      buildDataInfoColumn(
                          dataMap: bracketCalculate.otherCostCostMap,
                          summ: bracketCalculate.sumOtherCost),
                      MyWidgetButton(
                        onPressed: () {
                          TableViewModel.instance.chaneSelectedDBTable('Материалы.');
                          TableViewModel.instance.expansionIsOpen[3] = true;
                          TableBlock.changeScreenButton(EnumSingleViewModel.table);
                        },
                        name: 'Изменить Данные',
                        color: ToolThemeDataHolder.mainLightCardColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          //Flexible(flex: 1, fit: FlexFit.tight, child: SizedBox())
        ],
      ),
    );
  }

  Padding buildColumnDivaider({required String text}) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10, top: 10),
      child: Container(
        color: Colors.grey[300],
        height: 40,
        child: Center(
          child: Text(
            text,
            style: ToolThemeDataHolder.defFillTextDataStyle,
          ),
        ),
      ),
    );
  }

  Widget buildDataInfoColumn({required Map<String, double> dataMap, required double summ}) {
    List<Widget> list = [];
    for (var title in dataMap.keys) {
      list.add(buildDataInfoRow(title: title, data: dataMap[title]!));
      list.add(const Divider(height: 1));
    }
    list.add(
      buildDataInfoRow(title: 'сумма', data: summ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: Colors.grey[200],
        ),
        child: Column(
          children: list,
        ),
      ),
    );
  }

  buildDataInfoRow({required String title, required double data}) {
    return Row(
      children: [
        Flexible(
          flex: 2,
          fit: FlexFit.tight,
          child: Center(
            child: Text(
              title,
              style: title == 'сумма'
                  ? const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)
                  : const TextStyle(fontSize: 16),
            ),
          ),
        ),
        Flexible(
          fit: FlexFit.tight,
          child: Text(
            ToolHelpData.separateThousandString(data),
            style: title == 'сумма'
                ? const TextStyle(fontSize: 17, fontWeight: FontWeight.w500)
                : const TextStyle(fontSize: 17),
          ),
        ),
      ],
    );
  }
}

class ProducedBracketDataWidget extends StatelessWidget {
  const ProducedBracketDataWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BracketProducedRightScreen();
  }
}

Widget buildMultiShowDataItem({
  required String title,
  Map<String, dynamic>? mapValue,
  List<String>? listValue,
  required double height,
  int? bracketCount,
  bool numAnimation = false,
}) {
  return Padding(
    padding: const EdgeInsets.only(left: 8.0, top: 10.0),
    child: Row(
      children: [
        Flexible(
          flex: 1,
          child: DecoratedBox(
            position: DecorationPosition.foreground,
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(width: 1.5),
                bottom: BorderSide(width: 1.5),
              ),
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                boxShadow: [ToolThemeDataHolder.lowLowShadowBox],
                border: const Border(
                  left: BorderSide(
                    width: 5.0,
                    color: ToolThemeDataHolder.mainCardColor,
                  ),
                ),
                color: Colors.grey[300],
              ),
              child: Container(
                constraints: BoxConstraints(
                  minWidth: 200,
                  minHeight: height,
                ),
                alignment: AlignmentDirectional.centerStart,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, bottom: 0),
                  child: MyImmutableTextField(
                    text: title,
                    style: ToolThemeDataHolder.defTextDataStyle.copyWith(fontSize: height / 3),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (listValue == null && mapValue != null && bracketCount != null)
          for (var value in mapValue.values)
            buildShowDataBox(height, numAnimation, value * bracketCount),
        if (listValue != null)
          for (var value in listValue) buildShowDataBox(height, numAnimation, value),
      ],
    ),
  );
}

Widget buildShowDataItem({
  required String title,
  required dynamic value,
  required double height,
  bool numAnimation = false,
}) {
  return Padding(
    padding: const EdgeInsets.only(left: 8.0, top: 10.0),
    child: Row(
      children: [
        Flexible(
          flex: 1,
          child: DecoratedBox(
            position: DecorationPosition.foreground,
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(width: 1.5),
                bottom: BorderSide(width: 1.5),
              ),
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                boxShadow: [ToolThemeDataHolder.lowLowShadowBox],
                border: const Border(
                  left: BorderSide(
                    width: 5.0,
                    color: ToolThemeDataHolder.mainCardColor,
                  ),
                ),
                color: Colors.grey[300],
              ),
              child: Container(
                constraints: BoxConstraints(
                  minWidth: 100,
                  minHeight: height / 1.5,
                ),
                alignment: AlignmentDirectional.centerStart,
                child: Center(
                  child: MyImmutableTextField(
                    text: title,
                    isRichText: true,
                    style: ToolThemeDataHolder.defTextDataStyle.copyWith(fontSize: height / 3),
                  ),
                ),
              ),
            ),
          ),
        ),
        buildShowDataBox(height, numAnimation, value),
      ],
    ),
  );
}

Flexible buildShowDataBox(double height, bool numAnimation, value) {
  return Flexible(
    flex: 2,
    child: MyAnimatedCard(
      intensity: 0.02,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: ToolThemeDataHolder.colorMonoPlastGreen,
            width: 3,
          ),
          color: Colors.white,
          boxShadow: [ToolThemeDataHolder.lowLowShadowBox],
          borderRadius: BorderRadius.circular(6.0),
        ),
        width: double.infinity,
        height: height,
        alignment: AlignmentDirectional.centerStart,
        child: Padding(
          padding: const EdgeInsets.only(left: 0.0, bottom: 3),
          child: Center(
            child: numAnimation
                ? MyNumberAnimation(
                    targetNumber: value,
                    height: height,
                    duration: (value > 100)
                        ? const Duration(milliseconds: 200)
                        : const Duration(milliseconds: 0),
                  )
                : MyImmutableTextField(
                    copyText: value.toString(),
                    text: (value is double)
                        ? ToolHelpData.separateThousandString(value)
                        : value.toString(),
                    style: ToolThemeDataHolder.defFillTextDataStyle.copyWith(fontSize: height / 2),
                  ),
          ),
        ),
      ),
    ),
  );
}

class MyNumberAnimation extends StatefulWidget {
  final double targetNumber;
  final Duration duration;
  final double height;

  const MyNumberAnimation(
      {super.key, required this.targetNumber, required this.height, required this.duration});

  @override
  MyNumberAnimationState createState() => MyNumberAnimationState();
}

class MyNumberAnimationState extends State<MyNumberAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Tween<double> _myTween;

  double _currentNumber = 0;

  @override
  void initState() {
    super.initState();
    _myTween = Tween<double>(
      begin: _currentNumber,
      end: widget.targetNumber.toDouble(),
    );
    bindAnimationController();
  }

  cheekNeedUpdate() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (_controller.isCompleted && widget.targetNumber != _currentNumber) {
        _myTween = Tween<double>(
          begin: _currentNumber,
          end: widget.targetNumber.toDouble(),
        );
        _animation = _myTween.animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeOut,
          ),
        );
        _controller.reset();
        _controller.forward();
      }
    });
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  bindAnimationController() {
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = _myTween.animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    )..addListener(() {
        setState(() {
          _currentNumber = _animation.value.toDouble();
        });
      });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    cheekNeedUpdate();
    return MyImmutableTextField(
      copyText: _currentNumber.toString(),
      text: ToolHelpData.separateThousandString(_currentNumber),
      isRichText: true,
      style: ToolThemeDataHolder.defFillTextDataStyle.copyWith(fontSize: widget.height / 2),
    );
  }
}
