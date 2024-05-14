import 'package:flutter/material.dart';
import 'package:nexus/models/extractive_model.dart';
import 'package:nexus/repositories/extractive_model_repository.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<ExtractiveModel> _modelResponseFuture;
  final _repository = ExtractiveModelRepository();

  @override
  void initState() {
    super.initState();
    _modelResponseFuture = _repository.sendRequest(
        text:
            "What was beyond the bend in the stream was unknown. Both were curious, but only one was brave enough to want to explore. That was the problem. There was always one that let fear rule her life. Balloons are pretty and come in different colors, different shapes, different sizes, and they can even adjust sizes as needed. But don't make them too big or they might just pop, and then bye-bye balloon. It'll be gone and lost for the rest of mankind. They can serve a variety of purposes, from decorating to water balloon wars. You just have to use your head to think a little bit about what to do with them. She glanced up into the sky to watch the clouds taking shape. First, she saw a dog. Next, it was an elephant. Finally, she saw a giant umbrella and at that moment the rain began to pour. He wandered down the stairs and into the basement. The damp, musty smell of unuse hung in the air. A single, small window let in a glimmer of light, but this simply made the shadows in the basement deeper. He inhaled deeply and looked around at a mess that had been accumulating for over 25 years. He was positive that this was the place he wanted to live. There once lived an old man and an old woman who were peasants and had to work hard to earn their daily bread. The old man used to go to fix fences and do other odd jobs for the farmers around, and while he was gone the old woman, his wife, did the work of the house and worked in their own little plot of land.");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Model Response'),
      ),
      body: Center(
        child: FutureBuilder<ExtractiveModel>(
          future: _modelResponseFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final model = snapshot.data!;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Model Name: ${model.modelName}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Arguments Sent: ${model.arguments?.sentences}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Text: ${model.text}',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
