import 'package:flutter/material.dart';
import 'package:form_demo_web/data/tools/tool_navigator.dart';
import 'package:form_demo_web/data/tools/tool_theme_data.dart';
import 'package:form_demo_web/presentation/global_single_widgets/bookmark_widget.dart';
import 'package:form_demo_web/presentation/launch_screen.dart';
import 'package:form_demo_web/presentation/my_widgets/my_flow_excel_button.dart';
import 'package:form_demo_web/presentation/view_models/copy_screen_view_model.dart';
import 'package:form_demo_web/presentation/view_models/work_space_view_model.dart';
import 'package:provider/provider.dart';

class WorkSpaceScreen extends StatelessWidget {
  const WorkSpaceScreen({Key? key}) : super(key: key);
  static late BuildContext workSpaseContext;

  @override
  Widget build(BuildContext context) {
    workSpaseContext = context;
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (context) => WorkSpaceViewModel.instance,
        child: const WorkPageScaffold(),
      ),
    );
  }
}

class WorkPageScaffold extends StatefulWidget {
  const WorkPageScaffold({Key? key}) : super(key: key);

  @override
  State<WorkPageScaffold> createState() => _WorkPageScaffoldState();
}

class _WorkPageScaffoldState extends State<WorkPageScaffold> {
  @override
  Widget build(BuildContext context) {
    Widget rightWidget = context.select((WorkSpaceViewModel vm) => vm.rightWidget);
    Widget leftWidget = context.select((WorkSpaceViewModel vm) => vm.leftWidget);
    Widget singleWidget = context.select((WorkSpaceViewModel vm) => vm.singleWidget);
    bool isSingleWidgetScreen = context.select((WorkSpaceViewModel vm) => vm.isSingleWidgetScreen);
    return Column(
      children: [
        const WorkToolBar(),
        !isSingleWidgetScreen
            ? Flexible(
                flex: 9,
                fit: FlexFit.tight,
                child: DividedScreenScaffold(
                  leftWidget: leftWidget,
                  rightWidget: rightWidget,
                ),
              )
            : Flexible(
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0, bottom: 4.0, left: 6.0, right: 6.0),
                      child: singleWidget,
                    ),
                    MyFlowExcelButton(
                      listener: CopyScreenViewModel.instance,
                    ),
                  ],
                ),
              ),
      ],
    );
  }
}

class DividedScreenScaffold extends StatelessWidget {
  const DividedScreenScaffold({Key? key, required this.leftWidget, required this.rightWidget})
      : super(
          key: key,
        );

  final Widget leftWidget;
  final Widget rightWidget;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: ToolThemeDataHolder.colorMonoPlastGreen.withOpacity(0.5),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 0, bottom: 6.0, left: 6.0, right: 6.0),
            child: Row(
              children: [
                Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.grey[200],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: leftWidget,
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 5,
                  fit: FlexFit.tight,
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white,
                    ),
                    child: rightWidget,
                  ),
                ),
              ],
            ),
          ),
        ),
        MyFlowExcelButton(
          listener: CopyScreenViewModel.instance,
        ),
        //SelectedMouseScreen(),
      ],
    );
  }
}

class WorkToolBar extends StatelessWidget {
  const WorkToolBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.select((WorkSpaceViewModel vm) => vm.listBookmark);
    context.select((WorkSpaceViewModel vm) => vm.listBookmarkSize);
    context.select((WorkSpaceViewModel vm) => vm.needUpdate);
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            ToolThemeDataHolder.colorMonoPlastGreen.withOpacity(0.5),
            Colors.white.withOpacity(0.5),
          ],
          stops: const [0.10, 0.05],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 3.0, left: 5.0),
        child: InkWell(
          onTap: () {
            ToolNavigator.push(
              Material(
                color: ToolThemeDataHolder.mainLightShadowBgColor,
                child: InkWell(
                  splashColor: Colors.transparent,
                  onTap: ToolNavigator.pop,
                  hoverColor: null,
                  child: Padding(
                    padding: EdgeInsets.all(48.0),
                    child: FractionallySizedBox(
                      alignment: Alignment.center,
                      widthFactor: 0.5,
                      heightFactor: 0.9,
                      child: InkWell(
                        hoverColor: Colors.black12,
                        mouseCursor: SystemMouseCursors.basic,
                        child: TableBlock(heroContext: context),
                      ),
                    ),
                    //child: TableBlock(),
                  ),
                ),
              ),
            );
          },
          child: Stack(
            children: [
              Row(
                children: WorkSpaceViewModel.instance.getListBookmarks(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Image.asset(
                      'images/monoplast_logo_60h.png',
                      height: bookmarkHeight - 10,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
