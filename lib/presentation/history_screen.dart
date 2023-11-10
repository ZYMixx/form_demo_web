import 'package:flutter/material.dart';
import 'package:form_demo_web/data/tools/tool_theme_data.dart';
import 'package:form_demo_web/presentation/my_widgets/my_animated_card.dart';
import 'package:form_demo_web/presentation/view_models/history_screen_view_model.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    HistoryScreenViewModel.instance.loadData();
    return ChangeNotifierProvider(
      create: (_) => HistoryScreenViewModel.instance,
      child: const HistoryScreenBlock(),
    );
  }
}

class HistoryScreenBlock extends StatelessWidget {
  const HistoryScreenBlock({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<HistoryScreenItemData> listHistoryItem =
        context.select((HistoryScreenViewModel viewModel) => viewModel.listHistoryItemData);
    return Align(
      alignment: Alignment.centerRight,
      child: Align(
        alignment: Alignment.centerRight,
        child: Material(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.only(top: 150.0, right: 50.0),
            child: FractionallySizedBox(
              widthFactor: 0.3,
              heightFactor: 0.75,
              child: Hero(
                tag: "test_teg",
                child: Material(
                  elevation: 10.0,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: ToolThemeDataHolder.colorMonoPlastGreen,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(4.0),
                      color: Colors.grey[200],
                    ),
                    child: Stack(
                      children: [
                        const Center(
                          child: Opacity(
                            opacity: 0.15,
                            child: Icon(
                              Icons.history,
                              size: 80,
                              opticalSize: 0.2,
                            ),
                          ),
                        ),
                        ListView.builder(
                          itemCount: listHistoryItem.length,
                          itemBuilder: (contex, itemID) {
                            return buildHistoryItemRow(listHistoryItem.reversed.toList()[itemID]);
                          },
                        ),
                        const Center(
                          child: Opacity(
                            opacity: 0.15,
                            child: Icon(
                              Icons.history,
                              size: 80,
                              opticalSize: 0.2,
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
      ),
    );
  }

  buildHistoryItemRow(HistoryScreenItemData historyData) {
    return MyAnimatedCard(
      intensity: 0.01,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
        child: Material(
          color: Colors.grey[300],
          elevation: 1.0,
          child: InkWell(
            onTap: () => HistoryScreenViewModel.instance.pushHistoryScreen(historyData.listMap),
            hoverColor: ToolThemeDataHolder.colorMonoPlastGreen.withOpacity(0.15),
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Row(
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4.0, top: 2, bottom: 2),
                      child: ListView.builder(
                        itemCount: historyData.listTitle.length,
                        itemBuilder: (contex, itemID) {
                          return Text(
                            historyData.listTitle[itemID],
                            style: ToolThemeDataHolder.defFillConstTextStyle,
                            maxLines: 1,
                          );
                        },
                      ),
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 1,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '${historyData.shieldCount} шт',
                        style: ToolThemeDataHolder.defConstTextStyle,
                      ),
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          historyData.dataTime.substring(0, 8),
                          style: ToolThemeDataHolder.defFillConstTextStyle,
                        ),
                        Text(
                          historyData.dataTime.substring(9, 14),
                          style: ToolThemeDataHolder.defFillConstTextStyle,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
