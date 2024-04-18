import 'package:flutter/material.dart';
import 'package:flutter_playground/1/case1.dart';
import 'package:flutter_playground/2/case2.dart';
import 'package:flutter_playground/3/case3.dart';
import 'package:flutter_playground/test.dart';
import 'package:get/get.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: const Home(),
      routes: {'/case1': (_) => const Case1(), '/case2': (_) => Case2(), '/case3': (_) => const Case3()},
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          ListTile(title: const Text('基于 Flow 实现滑动显隐层'), onTap: () => Navigator.of(context).pushNamed('/case1')),
          ListTile(title: const Text('测试小功能: Overlay'), onTap: () => Navigator.of(context).pushNamed('/case2')),
          ListTile(title: const Text('Text & Shader'), onTap: () => Navigator.of(context).pushNamed('/case3')),
        ],
      ),
    );
  }
}
