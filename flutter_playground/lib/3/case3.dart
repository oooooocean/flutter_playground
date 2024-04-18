import 'package:flutter/material.dart';

class Case3 extends StatefulWidget {
  const Case3({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<Case3> with SingleTickerProviderStateMixin {
  final str = '醉后不知天在水满船清梦压星河';
  final style = const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white);
  late Size strSize;
  late AnimationController _ctrl;
  final gradient = const LinearGradient(colors: [Colors.red, Colors.grey]);
  late double wordWidth;

  @override
  void initState() {
    strSize = (TextPainter(text: TextSpan(text: str, style: style), textDirection: TextDirection.ltr)..layout()).size;
    wordWidth = strSize.width / str.length;
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 5));
    _ctrl.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.9),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: AnimatedBuilder(
            animation: _ctrl,
            builder: (_, __) => ShaderMask(
              shaderCallback: (rect) => gradient.createShader(
                Rect.fromLTWH(strSize.width * _ctrl.value, 0, wordWidth, strSize.height),
              ),
              child: __,
            ),
            child: Text(str, style: style),
          ),
        ),
      ),
    );
  }
}
