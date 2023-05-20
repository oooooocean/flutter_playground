import 'package:flutter/material.dart';
import 'package:flutter_playground/1/case1.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const Home(),
      routes: {'/case1': (_) => Case1()},
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: [
        ListTile(title: const Text('基于 Flow 实现滑动显隐层'), onTap: () => Navigator.of(context).pushNamed('/case1'),),
      ],),
    );
  }
}
