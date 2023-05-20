import 'dart:ui';
import 'package:flutter/material.dart';

class Case1 extends StatefulWidget {
  const Case1({super.key});

  @override
  State<StatefulWidget> createState() => _Case1State();
}

class _Case1State extends State<Case1> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  final offsetFactor = ValueNotifier<double>(0);

  @override
  void initState() {
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onHorizontalDragUpdate: _onHorizontalDragUpdate,
        onHorizontalDragEnd: _onHorizontalDragEnd,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Flow(delegate: _SwipeFlowDelegate(offsetFactor), children: [
            _content,
            _overflow,
            CloseButton(onPressed: () => offsetFactor.value = 0)
          ],),
        ),
      ),
    );
  }

  get _content => Image.asset('assets/sesame.png');

  get _overflow => ColoredBox(color: Colors.blue.withOpacity(0.5));

  get _width =>
      MediaQuery
          .of(context)
          .size
          .width;

  _onHorizontalDragUpdate(DragUpdateDetails details) {
    print(offsetFactor.value + details.delta.dx);
    offsetFactor.value = clampDouble(offsetFactor.value + details.delta.dx, 0, _width);
  }

  _onHorizontalDragEnd(DragEndDetails details) {
    if (offsetFactor.value > _width / 2) {
      _openOverflow();
    } else {
      _closeOverflow();
    }
  }

  Future _openOverflow() async {
    final animation = Tween<double>(begin: offsetFactor.value, end: _width).animate(_ctrl);
    animation.addListener(() => offsetFactor.value = animation.value);
    await _ctrl.forward(from: 0);
  }

  Future _closeOverflow() async {
    final animation = Tween<double>(begin: offsetFactor.value, end: 0).animate(_ctrl);
    animation.addListener(() => offsetFactor.value = animation.value);
    await _ctrl.forward(from: 0);
  }
}

class _SwipeFlowDelegate extends FlowDelegate {
  final ValueNotifier<double> offset;

  const _SwipeFlowDelegate(this.offset) : super(repaint: offset);

  @override
  void paintChildren(FlowPaintingContext context) {
    context.paintChild(0);
    context.paintChild(1, transform: Matrix4.translationValues(offset.value, 0, 0));

    if (offset.value == context.size.width) {
      context.paintChild(
          2, transform: Matrix4.translationValues(context.size.width / 2 - 30, context.size.height / 2 - 30, 0));
    }
  }

  @override
  bool shouldRepaint(covariant _SwipeFlowDelegate oldDelegate) {
    return oldDelegate.offset.value != offset.value;
  }
}
