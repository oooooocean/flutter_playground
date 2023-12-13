import 'package:flutter/material.dart';
import 'package:flutter_playground/1/case1.dart';
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
      home: Home(),
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
        ListTile(title: const Text('基于 Flow 实现滑动显隐层'), onTap: (){
          Get.defaultDialog(title: '通知', content: Text('lalalalalalla'), onConfirm: (){}, confirmTextColor: );
              // Navigator.of(context).pushNamed('/case1');
        }),
      ],),
    );
  }
}
