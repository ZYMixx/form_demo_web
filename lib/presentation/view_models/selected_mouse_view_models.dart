import 'package:flutter/material.dart';
import 'package:form_demo_web/data/repository/selected_mouse_repository.dart';

class SelectedMouseViewModels extends ChangeNotifier {
  static SelectedMouseViewModels get instance => _instance ??= SelectedMouseViewModels();
  static SelectedMouseViewModels? _instance;

  SelectedMouseRepository mouseSelectRep = SelectedMouseRepository.instance;

  Offset? get start => mouseSelectRep.start;

  Offset? get end => mouseSelectRep.end;

  double get left => mouseSelectRep.left;

  double get top => mouseSelectRep.top;

  double get right => mouseSelectRep.right;

  double get bottom => mouseSelectRep.bottom;

  Size? get borderSize => mouseSelectRep.borderSize;

  Offset? get borderStartPosition => mouseSelectRep.borderStartPosition;

  double get scrollPos => mouseSelectRep.scrollPos;

  Offset get scrollOffSet => mouseSelectRep.scrollOffSet;

  SelectedMouseViewModels() {
    if (_instance != null) {
      throw ("pls dont create second SelectedMouseViewModels, use instance");
    }
  }

  setStartPoint(Offset point) {
    mouseSelectRep.setStartPoint(point);
    notifyListeners();
  }

  setEndPoint(Offset point) {
    mouseSelectRep.setEndPoint(point);
    notifyListeners();
  }

  clearStartEndPoints() {
    mouseSelectRep.clearStartEndPoints();
    notifyListeners();
  }

  setBorderWidgetKey(GlobalKey key) {
    mouseSelectRep.setBorderWidgetKey(key);
  }

  setScrollPos(double scrollPos) {
    mouseSelectRep.setScrollPos(scrollPos);
    notifyListeners();
  }

  dropSelectedItem() {
    mouseSelectRep.dropSelectedItem();
  }

  setScrollBorderCallBack(Function(double) callBack) {
    mouseSelectRep.setScrollBorderCallBack(callBack);
  }

  callBorderScroll(double scrollDistance) {
    mouseSelectRep.callBorderScroll(scrollDistance);
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    _instance = null;
  }
}
