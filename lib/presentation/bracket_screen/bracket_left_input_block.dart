import 'package:flutter/material.dart';
import 'package:form_demo_web/data/tools/tool_theme_data.dart';
import 'package:form_demo_web/presentation/my_widgets/my_text_from_field.dart';
import 'package:form_demo_web/presentation/my_widgets/my_widget_button.dart';
import 'package:form_demo_web/presentation/view_models/bracket_data_view_model.dart';
import 'package:provider/provider.dart';

class BracketLeftInputBlock extends StatelessWidget {
  const BracketLeftInputBlock({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BracketDataViewModel.instance,
      child: const BracketLeftInputBlockBody(),
    );
  }
}

class BracketLeftInputBlockBody extends StatelessWidget {
  const BracketLeftInputBlockBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              double size = constraints.maxWidth;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                child: InputBracketBox(size: size),
              );
            },
          ),
        ],
      ),
    );
  }
}

class InputBracketBox extends StatefulWidget {
  const InputBracketBox({
    super.key,
    required this.size,
  });

  final double size;

  @override
  State<InputBracketBox> createState() => _InputBracketBoxState();
}

class _InputBracketBoxState extends State<InputBracketBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [ToolThemeDataHolder.defShadowBox],
        color: Colors.grey[300],
      ),
      constraints: const BoxConstraints(minWidth: 100),
      width: widget.size < 200 ? 200 : widget.size,
      height: widget.size < 100 ? 100 : widget.size / 2.0,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Center(
              child: AnimatedToggleText(),
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 3,
                    child: MyWidgetButton(
                      onPressed: BracketDataViewModel.instance.removeOnePressed,
                      name: "minus",
                      contentColor: Colors.black,
                      icon: Icons.remove,
                      color: ToolThemeDataHolder.mainLightCardColor,
                    ),
                  ),
                  Container(
                    width: 200,
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.grey[200],
                    ),
                    child: const AnimatedBracketNumber(),
                  ),
                  Flexible(
                    flex: 3,
                    child: MyWidgetButton(
                      onPressed: BracketDataViewModel.instance.addOnePressed,
                      name: "plus",
                      contentColor: Colors.black,
                      icon: Icons.add,
                      color: ToolThemeDataHolder.mainLightCardColor,
                    ),
                  ),
                  const Flexible(
                    flex: 3,
                    fit: FlexFit.loose,
                    child: SizedBox(),
                  ),
                ],
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 24.0),
                child: Text(
                  BracketDataViewModel.instance.name,
                  style: const TextStyle(fontSize: 38, fontWeight: FontWeight.w300),
                ),
              ),
            ),
            const Flexible(
              child: SizedBox(
                height: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedBracketNumber extends StatefulWidget {
  const AnimatedBracketNumber({
    super.key,
  });

  @override
  State<AnimatedBracketNumber> createState() => _AnimatedBracketNumberState();
}

class _AnimatedBracketNumberState extends State<AnimatedBracketNumber> {
  final TextEditingController rentabilityController = TextEditingController();
  final TextEditingController producedController = TextEditingController();

  @override
  void initState() {
    super.initState();
    rentabilityController.addListener(() {
      BracketDataViewModel.instance.setRentabilityCount(int.parse(rentabilityController.text));
    });
    producedController.addListener(() {
      BracketDataViewModel.instance.setProducedCount(int.parse(producedController.text));
    });
  }

  @override
  Widget build(BuildContext context) {
    BracketTabEnum bracketTab = context.select((BracketDataViewModel vm) => vm.selectedTab);
    int rentabilityCount = context.select((BracketDataViewModel vm) => vm.targetRentability);
    int producedCount = context.select((BracketDataViewModel vm) => vm.producedBracket);
    rentabilityController.text = rentabilityCount.toString();
    producedController.text = producedCount.toString();
    return Stack(
      children: [
        AnimatedOpacity(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInCubic,
          opacity: bracketTab == BracketTabEnum.rentability ? 1 : 0,
          child: AnimatedSlide(
            curve: Curves.easeIn,
            offset: bracketTab == BracketTabEnum.rentability
                ? const Offset(0, 0)
                : const Offset(0.52, 0),
            duration: const Duration(milliseconds: 350),
            child: MyTextFormField(
              numbOnly: true,
              textStyle: ToolThemeDataHolder.defFillTextDataStyle.copyWith(fontSize: 40),
              controller: rentabilityController,
            ),
          ),
        ),
        AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInCubic,
          opacity: bracketTab == BracketTabEnum.produced ? 1 : 0,
          child: AnimatedSlide(
            curve: Curves.easeIn,
            offset:
                bracketTab == BracketTabEnum.produced ? const Offset(0, 0) : const Offset(-0.45, 0),
            duration: const Duration(milliseconds: 250),
            child: MyTextFormField(
              numbOnly: true,
              textStyle: ToolThemeDataHolder.defFillTextDataStyle.copyWith(fontSize: 40),
              controller: producedController,
            ),
          ),
        ),
      ],
    );
  }
}

class AnimatedToggleText extends StatelessWidget {
  const AnimatedToggleText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    BracketTabEnum bracketTab = context.select((BracketDataViewModel vm) => vm.selectedTab);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          children: [
            AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: bracketTab == BracketTabEnum.rentability ? 1 : 0,
              curve: Curves.easeInCubic,
              child: AnimatedSlide(
                curve: Curves.easeIn,
                offset: bracketTab == BracketTabEnum.rentability
                    ? const Offset(0, 0)
                    : const Offset(1, 0),
                duration: const Duration(milliseconds: 350),
                child: const Text(
                  'Рентабельность:',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInCubic,
              opacity: bracketTab == BracketTabEnum.produced ? 1 : 0,
              child: AnimatedSlide(
                curve: Curves.easeIn,
                offset: bracketTab == BracketTabEnum.produced
                    ? const Offset(0, 0)
                    : const Offset(-1, 0),
                duration: const Duration(milliseconds: 250),
                child: const Text(
                  'Произведено:',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
