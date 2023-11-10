import 'package:flutter/material.dart';
import 'package:form_demo_web/data/services/service_active_work_view_model.dart';
import 'package:form_demo_web/data/tools/tool_navigator.dart';
import 'package:form_demo_web/data/tools/tool_widget.dart';
import 'package:form_demo_web/presentation/global_single_widgets/bookmark_widget.dart';
import 'package:form_demo_web/presentation/launch_screen.dart';

class WorkSpaceViewModel extends ChangeNotifier {
  static WorkSpaceViewModel get instance => _instance ??= WorkSpaceViewModel();
  static WorkSpaceViewModel? _instance;

  List<BookmarkWidget> listBookmark = [];

  int get listBookmarkSize => listBookmark.length;

  Widget leftWidget = ToolWidget.noDataTextWidget;
  Widget rightWidget = ToolWidget.noDataTextWidget;
  Widget singleWidget = ToolWidget.noDataTextWidget;
  bool isSingleWidgetScreen = false;
  bool needUpdate = false;

  setLeftWidget(Widget widget) {
    leftWidget = widget;
    notifyListeners();
  }

  setRightWidget(Widget widget) {
    rightWidget = widget;
    notifyListeners();
  }

  setSingleWidget(Widget widget) {
    singleWidget = widget;
    notifyListeners();
  }

  toggleSingleWidgetScreen(bool value) {
    isSingleWidgetScreen = value;
  }

  BookmarkWidget? checkBookmarkExist(EnumSingleViewModel singleViewModel) {
    for (var bookmark in listBookmark) {
      if (bookmark.viewModel == singleViewModel.getViewModel()) {
        return bookmark;
      }
    }
    return null;
  }

  addBookMark(BookmarkWidget bookmarkWidget) {
    listBookmark.add(bookmarkWidget);
    notifyListeners();
  }

  List<BookmarkWidget> getListBookmarks() {
    return listBookmark;
  }

  changeBookmarkOn(BookmarkWidget bookmarkWidget) {
    for (var item in listBookmark) {
      if (item != bookmarkWidget) {
        item.isPressed = false;
      }
    }
    ServiceActiveWorkViewModel.setActiveWorkViewModel(viewModel: bookmarkWidget.viewModel);
    needUpdate = !needUpdate;
    notifyListeners();
  }

  removeBookmark(BookmarkWidget bookmarkWidget) {
    bookmarkWidget.viewModel.selfDispose();
    if (listBookmark.length == 1) {
      ToolNavigator.pushReplacement(const LaunchScreen());

      return;
    }
    if (bookmarkWidget.isPressed) {
      if (bookmarkWidget == listBookmark.last) {
        listBookmark.remove(bookmarkWidget);
        listBookmark.last.onBookmarkPressed();
      } else {
        var index = listBookmark.indexOf(bookmarkWidget);
        listBookmark.remove(bookmarkWidget);
        listBookmark[index].onBookmarkPressed();
      }
    } else {
      listBookmark.remove(bookmarkWidget);
    }
    notifyListeners();
  }

  WorkSpaceViewModel() {
    if (_instance != null) {
      throw ("pls dont create second ViewModel, use instance");
    }
  }

  @override
  void dispose() {
    _instance = null;
    super.dispose();
  }
}
