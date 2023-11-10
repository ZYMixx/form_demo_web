import 'package:flutter/material.dart';
import 'package:form_demo_web/data/tools/tool_theme_data.dart';
import 'package:form_demo_web/presentation/my_widgets/my_animated_card.dart';

///используется instanse одной и таже кнопки на разных экранах
///с помощью [Stack] открывается spinner поверх других виджетов

const Size buttonSize = Size(140, 40);
Function _showFlowButtons = () {};

BuildContext? buttonContext;

abstract class ExcelButtonListener {
  tableButtonPressed();

  tableCopyButtonPressed();

  textButtonPressed();

  textCopyButtonPressed();

  VoidCallback? hideExelButton;
}

class MyFlowExcelInnerButton extends StatelessWidget {
  const MyFlowExcelInnerButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyAnimatedCard(
      intensity: 0.01,
      child: ElevatedButton(
        onPressed: () {
          buttonContext = context;
          _showFlowButtons();
        },
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(6.0),
          shadowColor: MaterialStateProperty.all(Colors.black),
          backgroundColor: MaterialStateProperty.all(Colors.green),
          fixedSize: MaterialStateProperty.all(buttonSize),
        ),
        child: const Text(
          'Таблица',
          style: ToolThemeDataHolder.defConstTextStyle,
        ),
      ),
    );
  }
}

class MyFlowExcelButton extends StatefulWidget {
  const MyFlowExcelButton({Key? key, required this.listener}) : super(key: key);
  final ExcelButtonListener listener;

  @override
  State<MyFlowExcelButton> createState() => _MyFlowExcelButtonState();
}

class _MyFlowExcelButtonState extends State<MyFlowExcelButton> with SingleTickerProviderStateMixin {
  late AnimationController menuAnimation;

  @override
  void initState() {
    widget.listener.hideExelButton = setOpenStatusFalse;
    menuAnimation = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _showFlowButtons = changeOpenStatus;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Flow(
      delegate: MyFlowExcelDelegate(menuAnimation: menuAnimation),
      children: [
        buildMenuButton(text: 'Скрыть', color: Colors.redAccent, callBack: () {}),
        Column(
          children: [
            buildMenuButton(
              text: 'Текст',
              color: Colors.green,
              callBack: widget.listener.textButtonPressed,
            ),
            buildMenuButton(
              text: 'Копировать',
              color: Colors.greenAccent,
              callBack: widget.listener.textCopyButtonPressed,
            ),
          ],
        ),
        Column(
          children: [
            buildMenuButton(
              text: 'Таблица',
              color: Colors.green,
              callBack: widget.listener.tableButtonPressed,
            ),
            buildMenuButton(
              text: 'Копировать',
              color: Colors.greenAccent,
              callBack: widget.listener.tableCopyButtonPressed,
            ),
          ],
        ),
      ],
    );
  }

  @override
  dispose() {
    buttonContext = null;
    super.dispose();
  }

  changeOpenStatus() {
    menuAnimation.status == AnimationStatus.completed
        ? menuAnimation.reverse()
        : menuAnimation.forward();
  }

  setOpenStatusFalse() {
    menuAnimation.reverse();
  }

  Widget buildMenuButton({required String text, required Color color, required Function callBack}) {
    return MyAnimatedCard(
      intensity: 0.008,
      child: DecoratedBox(
        position: DecorationPosition.foreground,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          border: Border.all(width: 0.5),
        ),
        child: DecoratedBox(
          decoration:
              BoxDecoration(color: Colors.grey[200], boxShadow: [ToolThemeDataHolder.defShadowBox]),
          child: Material(
            color: color,
            child: InkWell(
              onTap: () => {
                changeOpenStatus(),
                if (menuAnimation.status == AnimationStatus.reverse) {callBack()},
              },
              hoverColor: Colors.black12,
              child: SizedBox(
                width: buttonSize.width,
                height: buttonSize.height,
                child: Center(
                  child: Text(
                    text,
                    style: ToolThemeDataHolder.defConstTextStyle,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MyFlowExcelDelegate extends FlowDelegate {
  MyFlowExcelDelegate({required this.menuAnimation}) : super(repaint: menuAnimation);

  final Animation<double> menuAnimation;

  @override
  bool shouldRepaint(MyFlowExcelDelegate oldDelegate) {
    return menuAnimation != oldDelegate.menuAnimation;
  }

  @override
  void paintChildren(FlowPaintingContext context) {
    if (buttonContext == null) {
      return;
    }
    if (!buttonContext!.mounted) {
      return;
    }
    Offset buttonPosition = Offset.zero;
    try {
      RenderBox buttonBox = buttonContext?.findRenderObject() as RenderBox;
      buttonPosition = buttonBox.localToGlobal(const Offset(0, -66));
    } catch (e) {
      return;
    }
    var marign = 10;
    final startX = buttonPosition.dx;
    final startY = buttonPosition.dy;
    double dy = 0.0;
    for (int i = context.childCount - 1; i >= 0; --i) {
      dy = buttonSize.height * 2 * (i) + marign * (i);
      var moveYPos = startY + -dy * menuAnimation.value;
      context.paintChild(
        i,
        opacity: menuAnimation.value,
        transform: Matrix4.translationValues(
          startX,
          moveYPos,
          0,
        ),
      );
    }
  }
}
