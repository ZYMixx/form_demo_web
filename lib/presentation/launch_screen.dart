import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_demo_web/data/tools/tool_navigator.dart';
import 'package:form_demo_web/data/tools/tool_show_toast.dart';
import 'package:form_demo_web/data/tools/tool_theme_data.dart';
import 'package:form_demo_web/presentation/App.dart';
import 'package:form_demo_web/presentation/global_single_widgets/bookmark_widget.dart';
import 'package:form_demo_web/presentation/history_screen.dart';
import 'package:form_demo_web/presentation/my_widgets/my_accept_action_screen.dart';
import 'package:form_demo_web/presentation/my_widgets/my_animated_card.dart';
import 'package:form_demo_web/presentation/view_models/abstract_work_view_model.dart';
import 'package:form_demo_web/presentation/view_models/bracket_data_view_model.dart';
import 'package:form_demo_web/presentation/view_models/history_screen_view_model.dart';
import 'package:form_demo_web/presentation/view_models/shield_data_view_model.dart';
import 'package:form_demo_web/presentation/view_models/specification_view_model.dart';
import 'package:form_demo_web/presentation/view_models/table_view_model.dart';
import 'package:form_demo_web/presentation/view_models/trenoga_data_view_model.dart';
import 'package:form_demo_web/presentation/view_models/work_space_view_model.dart';
import 'package:form_demo_web/presentation/work_space_screen.dart';

class LaunchScreen extends StatelessWidget {
  const LaunchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: TablesChooserWidget(),
    );
  }
}

class TablesChooserWidget extends StatelessWidget {
  const TablesChooserWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FractionallySizedBox(
        widthFactor: 1,
        heightFactor: 1,
        child: Column(
          children: [
            const SizedBox(
              width: double.infinity,
              child: ColoredBox(color: ToolThemeDataHolder.colorMonoPlastGreen),
            ),
            Flexible(
              child: Stack(
                children: [
                  Opacity(
                    opacity: 0.40,
                    child: SvgPicture.asset(
                      'images/uzor_launch_bg.svg',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      color: ToolThemeDataHolder.colorMonoPlastGreen,
                    ),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          ToolThemeDataHolder.colorMonoPlastGreen.withOpacity(0.25),
                          Colors.white.withOpacity(0.25),
                        ],
                        stops: const [0.3, 0.9],
                      ),
                    ),
                    child: const SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 10),
                    child: Image.asset(
                      'images/mono_logo_mini.png',
                      filterQuality: FilterQuality.high,
                      width: 500,
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        const Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: SizedBox(
                            width: 40,
                          ),
                        ),
                        Flexible(flex: 2, child: TableBlock(heroContext: context)),
                        const Flexible(
                          flex: 1,
                          fit: FlexFit.loose,
                          child: SizedBox(
                            width: 40,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TableBlock extends StatelessWidget {
  const TableBlock({Key? key, required this.heroContext}) : super(key: key);
  final BuildContext heroContext;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 6.0,
      clipBehavior: Clip.hardEdge,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 1000,
          minWidth: 1000,
          maxHeight: 700,
          minHeight: 700,
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 12.0, bottom: 12.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: ToolThemeDataHolder.colorMonoPlastGreen,
                width: 4,
              ),
              color: Colors.white,
            ),
            padding: const EdgeInsets.all(1.5),
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  transform: const GradientRotation(0.1),
                  end: Alignment.bottomLeft,
                  begin: Alignment.topCenter,
                  colors: [
                    const Color(0xFFc0c0c0).withOpacity(0.5),
                    const Color(0xFFc0c0c0).withOpacity(0.33),
                    const Color(0xFFc0c0c0).withOpacity(0.7),
                  ],
                  stops: const [0.45, 0.55, 0.8],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Row(
                    children: [
                      const Flexible(fit: FlexFit.tight, flex: 1, child: SizedBox()),
                      Flexible(
                        flex: 5,
                        fit: FlexFit.tight,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 35.0),
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            clipBehavior: Clip.hardEdge,
                            children: [
                              buildLaunchTableWidget(EnumSingleViewModel.shieldBuild),
                              buildLaunchTableWidget(EnumSingleViewModel.specification),
                              buildLaunchTableWidget(EnumSingleViewModel.table),
                              buildLaunchTableWidget(EnumSingleViewModel.trenoga),
                              buildLaunchTableWidget(EnumSingleViewModel.bracket),
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                        fit: FlexFit.loose,
                        flex: 1,
                        child: Align(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onLongPress: () async {
                                  var myAcceptWidget =
                                      MyAcceptActionScreen(text: 'Очистить историю?');
                                  await showDialog(
                                    context: App.navigatorKey.currentContext!,
                                    builder: (context) {
                                      return myAcceptWidget;
                                    },
                                  );
                                  if (myAcceptWidget.isConfirmed) {
                                    HistoryScreenViewModel.instance.removeAllHistoryData();
                                    ToolShowToast.show('История очищена');
                                  }
                                },
                                onTap: () => ToolNavigator.pushHero(HistoryScreen()),
                                child: const MyAnimatedCard(
                                  intensity: 0.04,
                                  child: Hero(
                                    tag: "test_teg",
                                    child: Icon(
                                      Icons.history,
                                      color: Colors.black87,
                                      size: 80,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static changeScreenButton(EnumSingleViewModel singleViewModel) {
    BookmarkWidget? oldBookmark = WorkSpaceViewModel.instance.checkBookmarkExist(singleViewModel);
    if (oldBookmark == null) {
      var bookmark = BookmarkWidget(viewModel: singleViewModel.viewModel);
      WorkSpaceViewModel.instance.addBookMark(bookmark);
      ToolNavigator.push(const WorkSpaceScreen());
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        bookmark.onBookmarkPressed.call();
      });
    } else {
      ToolNavigator.push(const WorkSpaceScreen());
      oldBookmark.onBookmarkPressed();
    }
  }
}

Widget buildLaunchTableWidget(EnumSingleViewModel launchTitle) {
  return buildTableWidget(launchTitle);
}

Widget buildTableWidget(EnumSingleViewModel singleViewModel) {
  return MyAnimatedCard(
    intensity: 0.04,
    child: Card(
      child: Card(
        child: InkWell(
          onTap: () => TableBlock.changeScreenButton(singleViewModel),
          child: SizedBox(
            height: 160,
            width: 160,
            child: ColoredBox(
              color: ToolThemeDataHolder.mainLightCardColor,
              child: Center(
                child: SizedBox(
                  height: 150,
                  width: 150,
                  child: ColoredBox(
                    color: Colors.white,
                    child: Center(
                      child: SizedBox(
                        height: 140,
                        width: 140,
                        child: ColoredBox(
                          color: ToolThemeDataHolder.mainLightCardColor,
                          child: Center(
                            child: Text(
                              singleViewModel.modelName.length < 9
                                  ? singleViewModel.modelName
                                  : singleViewModel.modelName.substring(0, 7) +
                                      '-\n' +
                                      singleViewModel.modelName.substring(7),
                              textAlign: TextAlign.center,
                              style: ToolThemeDataHolder.defConstTextStyle.copyWith(fontSize: 21),
                            ),
                          ),
                        ),
                      ),
                    ),
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

enum EnumSingleViewModel {
  shieldBuild,
  table,
  specification,
  trenoga,
  bracket;

  AbstractWorkViewModel get viewModel => getViewModel();
  String get modelName => getName();

  String getName() {
    switch (this) {
      case shieldBuild:
        return 'Щит';
      case specification:
        return 'Спецификация';
      case table:
        return 'Таблицы';
      case bracket:
        return 'Кронштейн';
      case trenoga:
        return 'Тринога';
    }
  }

  getViewModel() {
    switch (this) {
      case shieldBuild:
        return ShieldDataViewModel.instance;
      case specification:
        return SpecificationViewModel.instance;
      case table:
        return TableViewModel.instance;
      case bracket:
        return BracketDataViewModel.instance;
      case trenoga:
        return TrenogaDataViewModel.instance;
    }
  }
}
