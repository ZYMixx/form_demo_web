import 'package:flutter/material.dart';
import 'package:form_demo_web/presentation/my_widgets/my_animated_card.dart';

class MyWidgetButton extends StatefulWidget {
  final String name;
  final VoidCallback onPressed;
  final Color color;
  final Color? contentColor;
  final double height;
  final IconData? icon;

  const MyWidgetButton(
      {super.key,
      required this.onPressed,
      required this.name,
      required this.color,
      this.contentColor,
      this.icon,
      this.height = 60});

  @override
  State<MyWidgetButton> createState() => _MyWidgetButtonState();
}

class _MyWidgetButtonState extends State<MyWidgetButton> {
  @override
  Widget build(BuildContext context) {
    return MyAnimatedCard(
      intensity: 0.005,
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: ElevatedButton(
          onPressed: widget.onPressed,
          style: ButtonStyle(
            fixedSize: MaterialStateProperty.all<Size>(
              Size.fromHeight(widget.height),
            ),
            minimumSize: MaterialStateProperty.all<Size>(
              Size.fromHeight(widget.height),
            ),
            backgroundColor: MaterialStateProperty.all<Color>(widget.color),
          ),
          child: widget.icon == null
              ? Text(
                  widget.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 22,
                      textBaseline: TextBaseline.ideographic,
                      color: widget.contentColor),
                )
              : Icon(
                  widget.icon,
                  color: widget.contentColor,
                ),
        ),
      ),
    );
  }
}
