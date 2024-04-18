import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Case2 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<Case2> {
  final _key = GlobalKey(debugLabel: 'test');

  _testToast() {
    final entry = OverlayEntry(
      builder: (_) => Material(
        color: Colors.black.withOpacity(0.5),
        child: const Center(child: CupertinoActivityIndicator(color: Colors.white)),
      ),
    );
    Overlay.of(context).insert(entry);
    Future.delayed(const Duration(seconds: 3)).then((value) {
      entry.remove();
    });
  }

  _testTip() {
    final render = _key.currentContext?.findRenderObject() as RenderBox;
    final offset = render.localToGlobal(Offset.zero);
    final size = render.size;
    final entry = OverlayEntry(
      builder: (_) => Material(
        color: Colors.transparent,
        child: Padding(
            padding: EdgeInsets.only(left: offset.dx, top: offset.dy + size.height),
            child: const Align(
                alignment: Alignment.topLeft,
                child: ColoredBox(color: Colors.black, child: Text('-----', style: TextStyle(color: Colors.white))))),
      ),
    );
    Overlay.of(context).insert(entry);
    Future.delayed(const Duration(seconds: 3)).then((value) {
      entry.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('一些小功能试验')),
      body: ListView(
        children: [
          ListTile(title: Text('Toast测试', key: _key), onTap: _testTip),
          ListTile(
              title: TextButton(
                onPressed: () => print('tap TextButton'),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => print('tap gesture'),
                  child: Text('点击测试'),
                ),
              ),
              onTap: () => print('tap ListTile')),
        ],
      ),
    );
  }
}
