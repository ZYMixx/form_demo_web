import 'package:flutter/material.dart';
import 'package:form_demo_web/presentation/view_models/selected_mouse_view_models.dart';
import 'package:provider/provider.dart';

/// Экран для отрисовки синей рамки при выделении курсором

class SelectedMouseScreen extends StatelessWidget {
  final Widget child;
  GlobalKey? borderWidgetKey;
  ScrollController? scrollController;

  static int oldMilliseconds = 0;

  SelectedMouseScreen({Key? key, required this.child, this.borderWidgetKey, this.scrollController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (borderWidgetKey != null) {
      SelectedMouseViewModels.instance.setBorderWidgetKey(borderWidgetKey!);
    }
    if (scrollController != null) {
      scrollController!.addListener(() {
        SelectedMouseViewModels.instance.setScrollPos(scrollController!.offset);
      });
      SelectedMouseViewModels.instance.setScrollBorderCallBack((double scrollDistance) {
        if (scrollController!.position.extentAfter != 0 && scrollDistance > 0) {
          scrollController!.jumpTo(scrollController!.offset + scrollDistance);
        } else {
          if (scrollController!.offset != 0) {
            scrollController!.jumpTo(scrollController!.offset + scrollDistance);
          }
        }
      });
    }
    return ChangeNotifierProvider(
      create: (context) => SelectedMouseViewModels.instance,
      child: Stack(
        children: [
          buildMouseDetector(child),
          const RectangleMousePainter(),
        ],
      ),
    );
  }

  Widget buildMouseDetector(Widget childWidget) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (PointerDownEvent event) {
        SelectedMouseViewModels.instance.dropSelectedItem();
        SelectedMouseViewModels.instance.setStartPoint(event.localPosition);
        SelectedMouseViewModels.instance.setEndPoint(event.localPosition);
      },
      onPointerMove: (PointerMoveEvent event) {
        if (oldMilliseconds + 40 < event.timeStamp.inMilliseconds) {
          oldMilliseconds = event.timeStamp.inMilliseconds;
          SelectedMouseViewModels.instance.setEndPoint(event.localPosition);
        }
      },
      onPointerUp: (PointerUpEvent event) {
        SelectedMouseViewModels.instance.clearStartEndPoints();
      },
      onPointerCancel: (PointerCancelEvent event) {
        SelectedMouseViewModels.instance.clearStartEndPoints();
      },
      child: childWidget,
    );
  }
}

class RectangleMousePainter extends StatelessWidget {
  const RectangleMousePainter({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Offset? start = context.select((SelectedMouseViewModels vm) => vm.start);
    Offset? end = context.select((SelectedMouseViewModels vm) => vm.end);
    Size? borderSize = context.select((SelectedMouseViewModels vm) => vm.borderSize);
    double scrollPos = context.select((SelectedMouseViewModels vm) => vm.scrollPos);
    return CustomPaint(
      painter: DrawingPainter(start: start, end: end, borderSize: borderSize, scrollPos: scrollPos),
    );
  }
}

class DrawingPainter extends CustomPainter {
  Offset? start = Offset.zero;
  Offset? end = Offset.zero;
  Size? borderSize;
  double scrollPos;

  DrawingPainter({required this.start, required this.end, this.borderSize, this.scrollPos = 0});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.blue.withOpacity(0.25)
      ..style = PaintingStyle.fill;

    Paint paintStroke = Paint()
      ..color = Colors.blue.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    if (start != null && end != null) {
      double startDY = start!.dy - scrollPos;
      startDY = (startDY < 0) ? 0 : startDY;
      double endDY = (end!.dy < 0) ? 0 : end!.dy;
      double endDX = (end!.dx < 0) ? 0 : end!.dx;
      if (borderSize != null) {
        if (end!.dy > borderSize!.height) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            SelectedMouseViewModels.instance.callBorderScroll(125);
          });
        } else if (end!.dy < 0) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            SelectedMouseViewModels.instance.callBorderScroll(-125);
          });
        }
        startDY = (startDY > borderSize!.height) ? borderSize!.height : startDY;
        endDY = (endDY > borderSize!.height) ? borderSize!.height : endDY;
        endDX = (endDX > borderSize!.width) ? borderSize!.width : endDX;
      }

      var testStart = Offset(start!.dx, startDY);
      var testEnd = Offset(endDX, endDY);
      Rect rect = Rect.fromPoints(testStart, testEnd!);
      canvas.drawRect(rect, paint);
      canvas.drawRect(rect, paintStroke);
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) {
    return true;
  }
}
