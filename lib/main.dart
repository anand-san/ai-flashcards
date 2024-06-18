import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart' as material;
import 'package:highlight_text/highlight_text.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

void main() {
  material.runApp(const MyApp());
}

class MyApp extends material.StatelessWidget {
  const MyApp({super.key});

  @override
  material.Widget build(material.BuildContext context) {
    return material.MaterialApp(
      title: 'Flutter Voice',
      debugShowCheckedModeBanner: false,
      theme: material.ThemeData(
        primarySwatch: material.Colors.red,
        visualDensity: material.VisualDensity.adaptivePlatformDensity,
      ),
      home: const SpeechScreen(),
    );
  }
}

class SpeechScreen extends material.StatefulWidget {
  const SpeechScreen({super.key});

  @override
  material.State<SpeechScreen> createState() => _SpeechScreenState();
}

class _SpeechScreenState extends material.State<SpeechScreen> {
  final Map<String, HighlightedWord> _highlights = {
    'flutter': HighlightedWord(
      onTap: () => print('flutter'),
      textStyle: const material.TextStyle(
        color: material.Colors.blue,
        fontWeight: material.FontWeight.bold,
      ),
    ),
  };

  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'Press the button and start speaking';
  double _confidence = 1.0;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  material.Widget build(material.BuildContext context) {
    return material.Scaffold(
      appBar: material.AppBar(
        title: material.Text(
            'Confidence: ${(_confidence * 100.0).toStringAsFixed(1)}%'),
      ),
      floatingActionButtonLocation:
          material.FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: material.Theme.of(context).primaryColor,
        // endRadius: 75.0,
        duration: const Duration(milliseconds: 2000),
        // repeatPauseDuration: const Duration(milliseconds: 100),
        repeat: true,
        child: material.FloatingActionButton(
          onPressed: _listen,
          child: material.Icon(
              _isListening ? material.Icons.mic : material.Icons.mic_none),
        ),
      ),
      body: material.SingleChildScrollView(
        reverse: true,
        child: material.Container(
          padding: const material.EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
          child: TextHighlight(
            text: _text,
            words: _highlights,
            textStyle: const material.TextStyle(
              fontSize: 32.0,
              color: material.Colors.black,
              fontWeight: material.FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  void _listen() async {
    var locales = await _speech.locales();
    for (var locale in locales) {
      print(
          'name: ${locale.name}, id: ${locale.localeId}, string: ${locale.toString()}');
    }

    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            }
          }),
          // localeId: 'de_DE'
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }
}
