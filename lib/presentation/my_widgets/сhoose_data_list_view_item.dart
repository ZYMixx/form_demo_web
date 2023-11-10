import 'package:flutter/material.dart';
import 'package:form_demo_web/data/tools/tool_theme_data.dart';
import 'package:form_demo_web/presentation/my_widgets/my_animated_card.dart';

class ChooseDataListViewItem extends StatefulWidget {
  final Function setterCallBack;
  final String text;

  const ChooseDataListViewItem({
    super.key,
    required this.setterCallBack,
    required this.text,
  });

  @override
  State<ChooseDataListViewItem> createState() => _ChooseDataListViewItemState();
}

class _ChooseDataListViewItemState extends State<ChooseDataListViewItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  var tweenOpacity = Tween<double>(begin: 0.2, end: 1.0);
  var tweenScale = Tween<double>(begin: 0.99, end: 1.0);
  var tweenOffset = Tween(begin: const Offset(0.0, 0.0), end: const Offset(0.0, 0.07));

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 180))
      ..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: tweenOffset.animate(_controller),
      child: FadeTransition(
        opacity: tweenOpacity.animate(_controller),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: MyAnimatedCard(
            intensity: 0.015,
            child: Card(
              clipBehavior: Clip.hardEdge,
              elevation: 10,
              child: InkWell(
                onTap: () {
                  widget.setterCallBack.call();
                },
                hoverColor: ToolThemeDataHolder.colorMonoPlastGreen.withAlpha(50),
                highlightColor: ToolThemeDataHolder.colorMonoPlastGreen.withAlpha(160),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      widget.text,
                      style: ToolThemeDataHolder.defTextDataStyle,
                      softWrap: false,
                    ),
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
