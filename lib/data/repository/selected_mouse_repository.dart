import 'package:flutter/material.dart';

class SelectedMouseRepository with WidgetsBindingObserver {
  /// Получение и обработка ячеек которые выделены рамкой курсора

  static SelectedMouseRepository get instance => _instance ??= SelectedMouseRepository();
  static SelectedMouseRepository? _instance;

  Offset? start = Offset.zero;
  Offset? end = Offset.zero;

  double left = 0;
  double top = 0;
  double right = 0;
  double bottom = 0;

  Function(double) scrollBorderCallBack = (scrollDistance) {};
  bool isCanScroll = true;

  double get scrollPos => absolutScrollPos - startScrollPos;
  double absolutScrollPos = 0;
  double startScrollPos = 0;

  GlobalKey? borderWidgetKey;
  Size? borderSize;
  Offset borderStartPosition = Offset.zero;

  Offset scrollOffSet = Offset.zero;

  List<SelectableScreenInterface> listSelectableScreen = [];

  SelectedMouseRepository() {
    if (_instance != null) {
      throw ("pls don't create second SelectedMouseRepository, use instance");
    }
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      updateBorderData();
    });
  }

  addListeners(SelectableScreenInterface selectableScreen) {
    listSelectableScreen.add(selectableScreen);
  }

  removeListener(SelectableScreenInterface selectableScreen) {
    listSelectableScreen.remove(selectableScreen);
  }

  setStartPoint(Offset point) {
    startScrollPos = absolutScrollPos;
    point = Offset(point.dx, point.dy);
    start = point;
  }

  setScrollPos(double scrollPos) {
    absolutScrollPos = scrollPos;
    if (end != null && start != null) {
      setStartPoint(Offset(start!.dx, start!.dy - this.scrollPos));
      setEndPoint(end!);
    }
  }

  setEndPoint(Offset point) {
    end = point;
    calculateSide();
    if (end != Offset.zero) {
      for (var selectableScreen in listSelectableScreen) {
        selectableScreen.callBack();
      }
    }
  }

  setBorderWidgetKey(GlobalKey key) {
    borderWidgetKey = key;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      updateBorderData();
    });
  }

  setScrollBorderCallBack(Function(double) callBack) {
    scrollBorderCallBack = callBack;
  }

  callBorderScroll(double scrollDistance) {
    if (isCanScroll) {
      scrollBorderCallBack(scrollDistance);
      isCanScroll = false;
      Future.delayed(const Duration(milliseconds: 120)).then((value) => isCanScroll = true);
    }
  }

  Size? updateBorderData() {
    if (borderWidgetKey != null) {
      RenderBox? renderBox = borderWidgetKey?.currentContext?.findRenderObject() as RenderBox?;
      borderSize = renderBox?.size;
      borderStartPosition = renderBox?.globalToLocal(Offset.zero) ?? Offset.zero;
      return (borderWidgetKey?.currentContext?.findRenderObject() as RenderBox?)?.size;
    }
    return null;
  }

  clearStartEndPoints() {
    end = Offset.zero;
    start = Offset.zero;
  }

  dropSelectedItem() {
    clearStartEndPoints();
    calculateSide();
    for (var selectableScreen in listSelectableScreen) {
      selectableScreen.callBack();
      selectableScreen.dropSelectedItem();
    }
  }

  bool isOffsetInRange(Offset? targetOffset) {
    if (targetOffset == null) {
      return false;
    }
    bool isXInRange = targetOffset.dx >= left && targetOffset.dx <= right;
    bool isYInRange =
        targetOffset.dy >= top + absolutScrollPos && targetOffset.dy <= bottom + absolutScrollPos;

    return isXInRange && isYInRange;
  }

  static int x = 0;

  calculateSide() {
    left = start!.dx < end!.dx ? start!.dx : end!.dx;
    top = start!.dy < end!.dy ? start!.dy : end!.dy;
    right = start!.dx > end!.dx ? start!.dx : end!.dx;
    bottom = start!.dy > end!.dy ? start!.dy : end!.dy;
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _instance = null;
  }
}

abstract class SelectableScreenInterface {
  callBack();

  dropSelectedItem();

  subscribe();

  unSubscribe();
}
