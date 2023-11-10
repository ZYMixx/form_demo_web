import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_demo_web/data/services/service_calculate_shield_data.dart';
import 'package:form_demo_web/data/tools/tool_theme_data.dart';
import 'package:form_demo_web/presentation/my_widgets/my_animated_card.dart';
import 'package:form_demo_web/presentation/my_widgets/my_text_from_field.dart';
import 'package:form_demo_web/presentation/my_widgets/my_widget_button.dart';
import 'package:form_demo_web/presentation/shield_screen/left_block_work_widgets/shield_data_builder.dart';
import 'package:form_demo_web/presentation/view_models/specification_view_model.dart';
import 'package:provider/provider.dart';

//ServiceCalculateShieldData

class RightChooseShieldInputScreen extends StatelessWidget {
  const RightChooseShieldInputScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SpecificationViewModel.instance,
      child: UserShieldAddedWidget(),
    );
  }
}

class UserShieldAddedWidget extends StatelessWidget {
  UserShieldAddedWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<ServiceCalculateShieldData> listAddedShield =
        context.select((SpecificationViewModel vm) => vm.listUserAddedShieldData);
    context.select((SpecificationViewModel vm) => vm.listAddedShieldSize);
    context.select((SpecificationViewModel vm) => vm.needUpdate);
    return RawKeyboardListener(
      focusNode: FocusNode(),
      onKey: (event) {
        final isEnterPressed = event.isKeyPressed(LogicalKeyboardKey.enter);
        if (isEnterPressed) {
          SpecificationViewModel.instance.onCalculationPressed();
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            fit: FlexFit.tight,
            flex: 3,
            child: ListView.builder(
              itemCount: listAddedShield.length + 1,
              itemBuilder: (contect, itemID) {
                if (itemID == 0) {
                  return buildTitleBlock(title: "Щит", sumTitle: "Количество");
                }
                return DefaultRightWidget(calculateShieldData: listAddedShield[itemID - 1]);
              },
            ),
          ),
          Flexible(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: MyWidgetButton(
                onPressed: () {
                  SpecificationViewModel.instance.onCalculationPressed();
                },
                name: "Калькуляция",
                color: Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DefaultRightWidget extends StatefulWidget {
  DefaultRightWidget({
    required this.calculateShieldData,
  }) : super(key: UniqueKey());
  ServiceCalculateShieldData calculateShieldData;

  @override
  State<DefaultRightWidget> createState() => _DefaultRightWidgetState();
}

class _DefaultRightWidgetState extends State<DefaultRightWidget> {
  bool inputError = false;
  TextEditingController controller = TextEditingController();

  bool haveInputError(TextEditingController controller) {
    if (controller.text == "0" || controller.text == "" || controller.text[0] == "0") {
      inputError = true;
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    String fullName = widget.calculateShieldData.konstrData.konstr.fullName;
    controller.text = SpecificationViewModel.instance.mapUserShieldInputData[fullName] ?? "";
    controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));
    controller.addListener(() {
      SpecificationViewModel.instance.saveShieldUserInput(fullName, controller.text);
      if (inputError) {
        setState(() {
          inputError = false;
        });
      }
    });
    if (SpecificationViewModel.instance.calculateButtonPressed) {
      if (!inputError) {
        haveInputError(controller);
      }
    }
    return Column(
      children: [
        const SizedBox(
          height: 5,
        ),
        MyAnimatedCard(
          intensity: 0.001,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 3.0),
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(3.0),
                boxShadow: [ToolThemeDataHolder.lowLowShadowBox],
              ),
              child: Row(
                children: [
                  Flexible(
                    child: InkWell(
                      onTap: () {},
                      child: GestureDetector(
                        onLongPress: () => SpecificationViewModel.instance
                            .removeAddedShield(widget.calculateShieldData),
                        child: Container(
                          decoration: BoxDecoration(
                            border: const Border(
                              bottom: BorderSide(width: 1),
                              left: BorderSide(width: 1),
                              top: BorderSide(width: 1),
                            ),
                            color: Colors.grey[300],
                          ),
                          width: double.infinity,
                          height: minFieldHeight / 1.5,
                          alignment: AlignmentDirectional.centerStart,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 120),
                            child: Center(
                              child: Text(
                                fullName,
                                style: ToolThemeDataHolder.defFillTextDataStyle,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Material(
                    color: inputError ? Colors.red[400] : null,
                    child: InkWell(
                      hoverColor: inputError ? null : Colors.grey[200],
                      mouseCursor: SystemMouseCursors.basic,
                      focusColor: inputError
                          ? null
                          : ToolThemeDataHolder.colorMonoPlastGreen.withAlpha(100),
                      highlightColor: null,
                      onTap: () {},
                      child: DecoratedBox(
                        position: DecorationPosition.background,
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Container(
                          constraints: BoxConstraints(
                            minWidth: 220,
                            minHeight: minFieldHeight / 1.5,
                          ),
                          alignment: AlignmentDirectional.center,
                          child: SizedBox(
                            width: 220,
                            height: minFieldHeight / 1.5,
                            child: MyTextFormField(
                              controller: controller,
                              numbOnly: true,
                              allowDouble: false,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Material(
                    child: InkWell(
                      hoverColor: Colors.grey[300],
                      mouseCursor: MouseCursor.defer,
                      highlightColor: null,
                      onTap: () {},
                      child: DecoratedBox(
                        position: DecorationPosition.background,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          border: const Border(
                            bottom: BorderSide(width: 1),
                            right: BorderSide(width: 1),
                            top: BorderSide(width: 1),
                          ),
                        ),
                        child: Container(
                          constraints: BoxConstraints(
                            minWidth: 175,
                            minHeight: minFieldHeight / 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Widget buildTitleBlock({required String title, required String sumTitle}) {
  return Padding(
    padding: const EdgeInsets.only(top: 2),
    child: Row(
      children: [
        Flexible(
          child: Container(
            width: double.infinity,
            height: minFieldHeight / 1.5,
            alignment: AlignmentDirectional.center,
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, bottom: 0),
              child: Text(
                title,
                style: ToolThemeDataHolder.defFillConstTextStyle,
              ),
            ),
          ),
        ),
        Container(
          constraints: BoxConstraints(
            minWidth: 570,
            minHeight: minFieldHeight / 1.5,
          ),
          alignment: AlignmentDirectional.center,
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0, bottom: 0),
            child: Text(
              sumTitle,
              style: ToolThemeDataHolder.defFillConstTextStyle,
            ),
          ),
        ),
      ],
    ),
  );
}
