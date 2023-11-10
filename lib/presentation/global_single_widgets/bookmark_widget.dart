import 'package:flutter/material.dart';
import 'package:form_demo_web/data/tools/tool_theme_data.dart';
import 'package:form_demo_web/presentation/my_widgets/my_animated_card.dart';
import 'package:form_demo_web/presentation/view_models/abstract_work_view_model.dart';
import 'package:form_demo_web/presentation/view_models/copy_screen_view_model.dart';
import 'package:form_demo_web/presentation/view_models/work_space_view_model.dart';
import 'package:provider/provider.dart';

const double bookmarkWidth = 180;
const double bookmarkHeight = 60;

class BookmarkWidget extends StatelessWidget {
  final AbstractWorkViewModel viewModel;
  bool isPressed = false;

  BookmarkWidget({
    super.key,
    required this.viewModel,
  });

  onBookmarkPressed() {
    CopyScreenViewModel.instance.hideExelButton?.call();
    if (!isPressed) {
      WorkSpaceViewModel.instance.toggleSingleWidgetScreen(viewModel.isSingleWidgetScreen);
      WorkSpaceViewModel.instance.setLeftWidget(viewModel.leftWidget);
      WorkSpaceViewModel.instance.setRightWidget(viewModel.rightWidget);
      WorkSpaceViewModel.instance.setSingleWidget(viewModel.singleWidget);
      isPressed = !isPressed;
      WorkSpaceViewModel.instance.changeBookmarkOn(this);
    }
  }

  @override
  Widget build(BuildContext context) {
    context.select((WorkSpaceViewModel vm) => vm.needUpdate);
    return InkWell(
      onTap: () {
        onBookmarkPressed();
      },
      child: GestureDetector(
        onLongPress: () {
          WorkSpaceViewModel.instance.removeBookmark(this);
        },
        onDoubleTap: () {
          WorkSpaceViewModel.instance.removeBookmark(this);
        },
        child: MyAnimatedCard(
          intensity: isPressed ? 0.0 : 0.010,
          child: Container(
            width: bookmarkWidth,
            height: bookmarkHeight,
            transformAlignment: Alignment.bottomCenter,
            transform: isPressed ? (Matrix4.identity()..scale(0.992, 0.975)) : null,
            decoration: BoxDecoration(
              boxShadow: !isPressed
                  ? [
                      BoxShadow(
                          color: ToolThemeDataHolder.mainCardColor.withAlpha(220),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: const Offset(-0.5, 2) // changes position of shadow
                          )
                    ]
                  : [
                      BoxShadow(
                          color: ToolThemeDataHolder.mainCardColor.withAlpha(180),
                          spreadRadius: 0.5,
                          blurRadius: 0.5,
                          offset: const Offset(-0.5, 1) // changes position of shadow
                          )
                    ],
              color: isPressed ? Colors.blue[600] : Colors.blue,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              viewModel.name,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                decoration: isPressed ? TextDecoration.underline : null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
