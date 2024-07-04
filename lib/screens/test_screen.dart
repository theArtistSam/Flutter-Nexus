import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ScrollTest extends StatelessWidget {
  ScrollTest({super.key, required this.controller});
  ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          controller: controller,
          child: Column(
            children: [
              for (int i = 0; i < 100; i++)
                Container(
                  color: i % 2 == 0 ? Colors.amber : Colors.red,
                  height: 200,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
