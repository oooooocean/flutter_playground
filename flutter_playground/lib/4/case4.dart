import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClipToolBar extends StatefulWidget {
  final List<double> vectors;
  final Color color;
  final Color bgColor;
  final Color clampedColor;
  final Color clampedBgColor;
  final double lineWidth;
  final double clampLineWidth;
  final TextStyle textStyle;
  final String Function(double) textBuilder;

  const ClipToolBar({
    super.key,
    required this.vectors,
    required this.textBuilder,
    this.textStyle = const TextStyle(fontSize: 14, color: Colors.grey),
    this.color = const Color(0xffdddddd),
    this.bgColor = const Color(0xfff4f4f4),
    this.clampedColor = const Color(0xffFFCC33),
    this.clampedBgColor = const Color(0x30FFCC33),
    this.lineWidth = 1.5,
    this.clampLineWidth = 3,
  });

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ClipToolBar> {
  final left = ValueNotifier<double>(0.25);
  final right = ValueNotifier<double>(0.75);
  AxisDirection? direction;

  onHorizontalDragStart(DragStartDetails details) {
    final boxWidth = (context.findRenderObject() as RenderBox).size.width;
    final point = details.localPosition.dx / boxWidth;
    direction = point <= 0.5 ? AxisDirection.left : AxisDirection.right;
  }

  onHorizontalDragUpdate(DragUpdateDetails details) {
    final boxWidth = (context.findRenderObject() as RenderBox).size.width;
    switch (direction) {
      case AxisDirection.left:
        final value = left.value + details.delta.dx / boxWidth;
        if (value >= right.value || value < 0) return;
        left.value = value;
        break;
      case AxisDirection.right:
        final value = right.value + details.delta.dx / boxWidth;
        if (value <= left.value || value > 1) return;
        right.value = value;
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: onHorizontalDragStart,
      onHorizontalDragUpdate: onHorizontalDragUpdate,
      child: LayoutBuilder(
        builder: (constraints, _) => CustomPaint(
          painter: _Painter(
            vectors: widget.vectors,
            color: widget.color,
            bgColor: widget.bgColor,
            clampedBgColor: widget.clampedBgColor,
            clampedColor: widget.clampedColor,
            leftPosition: left,
            rightPosition: right,
            textStyle: widget.textStyle,
            textBuilder: widget.textBuilder,
          ),
          size: Size(constraints.width, constraints.height),
        ),
      ),
    );
  }
}

class _Painter extends CustomPainter {
  final List<double> vectors;
  final Color color;
  final Color bgColor;
  final Color clampedColor;
  final Color clampedBgColor;
  final ValueNotifier<double> leftPosition;
  final ValueNotifier<double> rightPosition;
  final double chartOffY;
  final double lineWidth;
  final double clampLineWidth;
  final TextStyle textStyle;
  final String Function(double) textBuilder;

  _Painter({
    required this.vectors,
    required this.color,
    required this.bgColor,
    required this.clampedColor,
    required this.clampedBgColor,
    required this.leftPosition,
    required this.rightPosition,
    required this.textStyle,
    required this.textBuilder,
    this.chartOffY = 40,
    this.lineWidth = 1.5,
    this.clampLineWidth = 4,
  }) : super(repaint: Listenable.merge([leftPosition, rightPosition]));

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Offset.zero & size);
    final chartRect = Offset(lineWidth * 0.5, chartOffY) & Size(size.width - lineWidth, size.height - chartOffY);
    // 绘制背景
    canvas.drawColor(bgColor, BlendMode.srcOver);
    // 绘制线段
    _drawLines(canvas, chartRect);
    // 绘制clamped背景
    _drawClampedBg(canvas, chartRect);
    // 绘制clamped边缘和文字
    final clampLinePaint = Paint()
      ..strokeWidth = clampLineWidth
      ..color = clampedColor;
    [leftPosition.value, rightPosition.value].forEach((point) {
      _drawClampedLineAndText(canvas, point, chartRect, clampLinePaint);
    });
  }

  _drawLines(Canvas canvas, Rect chartRect) {
    final paint = Paint()..strokeWidth = lineWidth;
    final count = vectors.length;
    final space = chartRect.width / (count - 1);
    int index = 0;
    while (index < count) {
      final height = chartRect.height * vectors[index];
      final y = chartRect.top + (chartRect.height - height) * 0.5;
      final x = chartRect.left + space * index;
      final isClamped = x >= leftPosition.value * chartRect.width && x <= rightPosition.value * chartRect.width;
      if (isClamped) {
        canvas.drawLine(Offset(x, y), Offset(x, y + height), paint..color = clampedColor);
      } else {
        canvas.drawLine(Offset(x, y), Offset(x, y + height), paint..color = color);
      }
      index += 1;
    }
  }

  _drawClampedBg(Canvas canvas, Rect chartRect) {
    canvas.save();
    final clampedBgWidth = (rightPosition.value - leftPosition.value) * chartRect.width;
    final clampedBgOffX = leftPosition.value * chartRect.width + clampedBgWidth * 0.5;
    canvas.clipRect(Rect.fromCenter(
        center: ui.Offset(clampedBgOffX, chartRect.center.dy), width: clampedBgWidth, height: chartRect.height));
    canvas.drawColor(clampedBgColor, BlendMode.srcOver);
    canvas.restore();
  }

  _drawClampedLineAndText(Canvas canvas, double point, Rect chartRect, Paint clampLinePaint) {
    canvas.save();
    canvas.translate(chartRect.left + chartRect.width * point, chartRect.top);
    final text = textBuilder(point);
    final builder = ui.ParagraphBuilder(ui.ParagraphStyle(
      textAlign: TextAlign.center,
      fontSize: textStyle.fontSize,
      textDirection: TextDirection.ltr,
    ));
    builder.pushStyle(ui.TextStyle(color: textStyle.color));
    builder.addText(text);
    final paragraph = builder.build();
    paragraph.layout(const ui.ParagraphConstraints(width: double.infinity));
    paragraph.layout(ui.ParagraphConstraints(width: paragraph.longestLine));
    double paragraphOffX;
    if ((1 - point) * chartRect.width < paragraph.longestLine / 2) {
      paragraphOffX = -paragraph.longestLine;
    } else if (point * chartRect.width < paragraph.longestLine / 2) {
      paragraphOffX = 0;
    } else {
      paragraphOffX = -paragraph.longestLine / 2;
    }
    canvas.drawParagraph(
      paragraph,
      Offset(paragraphOffX, -paragraph.height),
    );
    canvas.drawLine(Offset.zero, Offset(0, chartRect.bottom), clampLinePaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _Painter oldDelegate) {
    return vectors != oldDelegate.vectors ||
        leftPosition != oldDelegate.leftPosition ||
        rightPosition != oldDelegate.rightPosition;
  }
}
