import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_demo_web/data/services/service_konstr_data_builder.dart';
import 'package:form_demo_web/data/tools/tool_show_toast.dart';
import 'package:form_demo_web/data/tools/tool_theme_data.dart';
import 'package:form_demo_web/domain/constant_entity.dart';
import 'package:form_demo_web/presentation/my_widgets/my_immutable_text_field.dart';
import 'package:form_demo_web/presentation/my_widgets/my_widget_button.dart';
import 'package:form_demo_web/presentation/view_models/specification_view_model.dart';
import 'package:provider/provider.dart';

import '../../view_models/shield_data_view_model.dart';
import 'choose_shild_parms_widget.dart';

double minFieldHeight = 40;
double minFieldWidth = 120;
late ShieldDataViewModel viewModel;
late VoidCallback selectionEditorCallBack;

class ShieldDataBuilder extends StatelessWidget {
  const ShieldDataBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    setUpViewModel();
    return ChangeNotifierProvider(
      create: (context) => viewModel,
      child: const ChooseDataBlock(),
    );
  }
}

setUpViewModel() {
  viewModel = ShieldDataViewModel.instance;
}

class ChooseDataBlock extends StatelessWidget {
  const ChooseDataBlock({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool haveSecondWidth = context.select((ShieldDataViewModel vm) => vm.haveSecondWidth);
    int? shieldHeight = context.select((ShieldDataViewModel vm) => vm.shieldHeight);
    String? tip = context.select((ShieldDataViewModel vm) => vm.tip);
    int? clepkiCount = context.select((ShieldDataViewModel vm) => vm.clepkiCount);
    int? width = context.select((ShieldDataViewModel vm) => vm.width);
    Widget bottomWidder = setUpBottomWidget(tip, shieldHeight, clepkiCount);
    return Column(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                color: Colors.black.withAlpha(100),
                spreadRadius: 0.8,
                blurRadius: 0.8,
                offset: const Offset(-1.0, 2))
          ]),
          child: Material(
            color: Colors.transparent,
            clipBehavior: Clip.hardEdge,
            child: Column(
              children: [
                buildChooseDataRow(
                    title: "Тип",
                    text: viewModel.tip ?? "",
                    tapCallBack: () {
                      viewModel.setShieldTip(null);
                    }),
                buildChooseDataRow(
                    title: "Высота",
                    text: viewModel.shieldHeight != null ? "${viewModel.shieldHeight}" : "",
                    tapCallBack: () {
                      viewModel.setShieldHeight(null);
                    }),
                buildUserInputDataRowFirstWidth(title: "Ширина"),
                if (haveSecondWidth) buildUserInputDataRowSecondWidth(title: "Ширина 2"),
                if (clepkiCount == null && viewModel.isFullUserData())
                  buildUserInputDataRowClepkiCount(title: "Клёпки")
              ],
            ),
          ),
        ),
        Flexible(
          child: buildUnderBlockDecoration(bottomWidder),
        ),
      ],
    );
  }

  Widget setUpBottomWidget(String? tip, int? shieldHeight, int? clepki) {
    if (tip == null) {
      return ChooseShieldParmsWidget(
        callBack: (value) => viewModel.setShieldTip(value),
        dataList: viewModel.getAllKonstTip(),
      );
    } else if (shieldHeight == null) {
      return ChooseShieldParmsWidget(
        callBack: (value) => {viewModel.setKonstrForm(value), selectionEditorCallBack.call()},
        dataList: viewModel.getAllKonstByTip(),
      );
    } else if (clepki != null) {
      return buildShowSelectShieldData();
    } else {
      return addNewClipkiBlock();
    }
  }
}

Widget addNewClipkiBlock() {
  return Column(
    children: [
      MyWidgetButton(
          onPressed: () {
            if (viewModel.userClepkiCount == null) {
              ToolShowToast.showError("Введите число клёпок");
            } else {
              viewModel.insertNewClipki();
            }
          },
          name: "Сохранить клёпки",
          color: Colors.blue)
    ],
  );
}

///TODO Можно вынести
Widget buildChooseDataRow({
  required String title,
  required String text,
  required VoidCallback tapCallBack,
}) {
  return Padding(
    padding: const EdgeInsets.only(top: -0.0),
    child: Row(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(4.0),
              color: Colors.grey[300]),
          child: InkWell(
            onTap: tapCallBack,
            child: Container(
              constraints: BoxConstraints(
                minWidth: minFieldWidth,
                minHeight: minFieldHeight,
              ),
              alignment: AlignmentDirectional.centerStart,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, bottom: 2),
                child: Text(
                  title,
                  style: ToolThemeDataHolder.defConstTextStyle,
                ),
              ),
            ),
          ),
        ),
        Flexible(
          child: Material(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
              side: const BorderSide(color: Colors.black, width: 0.6),
            ),
            child: InkWell(
              onTap: tapCallBack,
              child: Padding(
                padding: const EdgeInsets.all(0.5),
                child: Container(
                  width: double.infinity,
                  height: minFieldHeight,
                  alignment: AlignmentDirectional.centerStart,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, bottom: 2),
                    child: Text(
                      text,
                      style: ToolThemeDataHolder.defTextDataStyle,
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

var _focusNodeFirstWidth = FocusNode();

///TODO Можно вынести
Widget buildUserInputDataRowFirstWidth({
  required String title,
}) {
  TextEditingController _controller = TextEditingController();
  _controller.text = viewModel.width != null ? viewModel.width.toString() : "";
  _controller.selection = TextSelection.fromPosition(TextPosition(offset: _controller.text.length));
  selectionEditorCallBack = () {
    _focusNodeFirstWidth.requestFocus();
    _controller.selection = TextSelection.fromPosition(TextPosition(offset: 0));
    // });
  };
  _controller.addListener(() {
    if (_controller.value.text.isNotEmpty) {
      viewModel.onWidthChangeListener(_controller.value.text);
    } else {
      viewModel.resetWidth();
    }
  });
  return (viewModel is SpecificationViewModel)
      ? RawKeyboardListener(
          focusNode: FocusNode(),
          autofocus: true,
          onKey: (event) {
            final isEnterPressed = event.isKeyPressed(LogicalKeyboardKey.enter);
            if (isEnterPressed && SpecificationViewModel.instance.readyAddShield) {
              SpecificationViewModel.instance.onAddShieldPressed();
            }
          },
          child: UserInputDataRow(
            title: title,
            controller: _controller,
            focusNode: _focusNodeFirstWidth,
          ),
        )
      : UserInputDataRow(
          title: title,
          controller: _controller,
          focusNode: _focusNodeFirstWidth,
        );
}

Widget buildUserInputDataRowSecondWidth({
  required String title,
}) {
  TextEditingController _controller = TextEditingController();
  _controller.text = viewModel.widthSecond != null ? viewModel.widthSecond.toString() : "";
  _controller.selection = TextSelection.fromPosition(TextPosition(offset: _controller.text.length));
  _controller.addListener(() {
    if (_controller.value.text.isNotEmpty) {
      print('EHY NULL ${_controller.value.text}');
      viewModel.onSecondWidthChangeListener(_controller.value.text);
    } else {
      viewModel.resetSecondWidth();
    }
  });
  return (viewModel is SpecificationViewModel)
      ? RawKeyboardListener(
          focusNode: FocusNode(),
          autofocus: true,
          onKey: (event) {
            final isEnterPressed = event.isKeyPressed(LogicalKeyboardKey.enter);
            if (isEnterPressed && SpecificationViewModel.instance.readyAddShield) {
              SpecificationViewModel.instance.onAddShieldPressed();
            }
          },
          child: UserInputDataRow(title: title, controller: _controller),
        )
      : UserInputDataRow(title: title, controller: _controller);
}

Widget buildUserInputDataRowClepkiCount({
  required String title,
}) {
  TextEditingController _controller = TextEditingController();
  _controller.text = viewModel.userClepkiCount != null ? viewModel.userClepkiCount.toString() : "";
  _controller.selection = TextSelection.fromPosition(TextPosition(offset: _controller.text.length));
  _controller.addListener(() {
    if (_controller.value.text.isNotEmpty) {
      viewModel.onUserClepkiChangeListener(_controller.value.text);
    } else {
      viewModel.resetUserClepkiCount();
    }
  });
  return UserInputDataRow(title: title, controller: _controller);
}

class UserInputDataRow extends StatelessWidget {
  const UserInputDataRow({
    super.key,
    required this.controller,
    required this.title,
    this.focusNode,
  });

  final TextEditingController controller;
  final String title;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: -0.0),
      child: Row(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(4.0),
                color: Colors.grey[300]),
            child: Container(
              constraints: BoxConstraints(
                minWidth: minFieldWidth,
                minHeight: minFieldHeight,
              ),
              alignment: AlignmentDirectional.centerStart,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, bottom: 2),
                child: Text(
                  title,
                  style: ToolThemeDataHolder.defConstTextStyle,
                ),
              ),
            ),
          ),
          Flexible(
            child: Material(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
                side: const BorderSide(color: Colors.black, width: 0.6),
              ),
              child: InkWell(
                child: Padding(
                  padding: const EdgeInsets.all(0.5),
                  child: Container(
                    width: double.infinity,
                    height: minFieldHeight,
                    alignment: AlignmentDirectional.centerStart,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, bottom: 5),
                      child: TextFormField(
                        focusNode: focusNode,
                        key: Key('firstHeight'),
                        expands: true,
                        maxLines: null,
                        minLines: null,
                        autofocus: false,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          isCollapsed: true,
                        ),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                        ],
                        controller: controller,
                        cursorWidth: 1,
                        cursorColor: ToolThemeDataHolder.colorMonoPlastGreen,
                        textAlignVertical: TextAlignVertical.center,
                        style: ToolThemeDataHolder.defTextDataStyle,
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

Widget buildUnderBlockDecoration(Widget widget) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: widget,
  );
}

Column buildShowSelectShieldData() {
  var konstr = viewModel.konstrForm;
  ConstantEntity konstrEntity = ConstantEntity(
    konstrForm: viewModel.konstrForm!,
    width: viewModel.width!,
    widthSecond: viewModel.widthSecond ?? 0,
    clepki: viewModel.clepkiCount!,
  );
  ServiceKonstrData konstrData = ServiceKonstrData(konstrEntity);
  return Column(
    children: [
      DecoratedBox(
        decoration: BoxDecoration(
          boxShadow: [ToolThemeDataHolder.defLowShadowBox],
        ),
        child: Material(
          elevation: 8,
          clipBehavior: Clip.hardEdge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
            side: const BorderSide(color: Colors.black, width: 0.7),
          ),
          child: Column(
            children: [
              buildShowDataItem(title: "Тип", text: konstr?.tip ?? ""),
              buildShowDataItem(title: "Комментарий", text: konstr?.comment ?? ""),
              buildShowDataItem(
                  title: "Высота", text: konstr?.height != null ? konstr!.height.toString() : ""),
              buildShowDataItem(
                  title: "Ширина", text: viewModel.width != null ? viewModel.width.toString() : ""),
              if (viewModel.haveSecondWidth)
                buildShowDataItem(
                    title: "Ширина 2",
                    text: viewModel.widthSecond != null ? viewModel.widthSecond.toString() : ""),
              buildShowDataItem(
                  title: "Линейные Отверстия",
                  text: konstr?.line_pipe != null ? konstr!.line_pipe.toString() : ""),
              buildShowDataItem(
                  title: "Линейные Связи",
                  text: konstr?.line_jumper != null ? konstr!.line_jumper.toString() : ""),
              buildShowDataItem(
                title: "Перемычки",
                text: konstrData.konstr.getP().toString(),
              ),
              buildShowDataItem(
                  title: "Длинна Перемычки",
                  text: konstrData.konstr.getP() != 0 ? konstrData.konstr.getDP().toString() : '0'),
              buildShowDataItem(
                  title: "Клепки",
                  text: viewModel.clepkiCount != null ? viewModel.clepkiCount.toString() : ""),
              buildShowDataItem(title: "Вальцовки", text: konstrData.konstr.getV().toString()),
            ],
          ),
        ),
      ),
    ],
  );
}

Widget buildShowDataItem({
  required String title,
  required String text,
}) {
  return Padding(
    padding: const EdgeInsets.all(0.5),
    child: DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Flexible(
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: const Border(
                  bottom: BorderSide(width: 1),
                  right: BorderSide(width: 0.3),
                ),
                color: Colors.grey[300],
              ),
              child: Container(
                constraints: BoxConstraints(
                  minWidth: 200,
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
            ),
          ),
          Flexible(
            child: Container(
              width: double.infinity,
              height: minFieldHeight / 1.5,
              alignment: AlignmentDirectional.centerStart,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, bottom: 0),
                child: MyImmutableTextField(
                  text: text,
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
