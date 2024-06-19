import 'package:flutter/material.dart';
import 'speech_to_text.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: const Text("Flashcard Everything"),
        ),
        body: Center(
          child: ElevatedButton(
            child: const Text('Start Flashcarding!'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SpeechScreen()),
              );
            },
          ),
        ));
  }
}
