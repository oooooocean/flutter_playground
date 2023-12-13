import 'package:flutter/material.dart';
import 'package:get/get.dart';

class _Controller extends GetxController {
  var value = false.obs..firstRebuild=false;

  @override
  void onReady() {
    ever(value, (_) => print('ever $_'));
    Future.delayed(const Duration(seconds: 2), () => value.value = false);
    super.onReady();
  }
}

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GetBuilder(
      init: _Controller(),
      builder: (_Controller controller) => Center(child: Obx(() {
        return Text(controller.value.string);
      })),
    ));
  }
}
