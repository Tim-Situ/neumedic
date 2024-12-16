import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:neumedic/assessment_result_page.dart';
import 'dart:developer' as dev;

class DailyAssessmentPage extends StatefulWidget {
  const DailyAssessmentPage({super.key});

  @override
  State<StatefulWidget> createState() => _DailyAssessmentPageState();
}

class _DailyAssessmentPageState extends State<DailyAssessmentPage> {
  final TextEditingController _inputController = TextEditingController();
  final Gemini gemini = Gemini.instance;
  final List<String> _emotionResult = [];
  final List<String> _textIdentified = [];

  @override
  void initState() {
    super.initState();
  }

  Future<bool> _identifyText() async {
    Completer<bool> completer = Completer<bool>();
    try {
      String question =
          'what is the similiar sentence of this : ${_inputController.text}. give me just one sentence';
      gemini.streamGenerateContent(question).listen((event) {
        String? response = event?.output;
        if (response != null) {
          setState(() {
            _textIdentified.add(response);
          });
          dev.log("response $response");
          dev.log(
              "meaning: ${_textIdentified.join(" ")} 0:${_textIdentified.first}");
        }
      }, onDone: () {
        // Selesaikan completer saat stream selesai
        if (!completer.isCompleted) {
          completer.complete(true);
        }
      }, onError: (e) {
        dev.log("error: $e");
        if (!completer.isCompleted) {
          completer.complete(false);
        }
      });
      return completer.future;
    } catch (e) {
      dev.log("error: $e");
      return false;
    }
  }

  Future<bool> _getResult() async {
    Completer<bool> completer = Completer<bool>();
    try {
      String question =
          '${_inputController.text} Based on that explanation what emotion does it looks like? choose one below : 1. Anger 2. Sad 3. Neutral 4. Happy 5. Joy .just answer with the choice text without the number';
      gemini.streamGenerateContent(question).listen((event) {
        String? response = event?.output;
        if (response != null) {
          setState(() {
            _emotionResult.add(response);
          });
          dev.log("response $response");
          dev.log(
              "emotion: ${_emotionResult.toString()} 0:${_emotionResult.first}");
        }
        // Menyelesaikan completer hanya saat data pertama diterima
        if (!completer.isCompleted) {
          completer.complete(true);
        }
      }, onError: (e) {
        dev.log("error: $e");
        if (!completer.isCompleted) {
          completer.complete(false);
        }
      });
      return completer.future;
    } catch (e) {
      dev.log("error: $e");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            "Daily Assessment",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Expression Analysis",
                      style: TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      "Write freely whatever you think. Medi is here to listen! It only takes 30 seconds",
                      style: TextStyle(
                        color: Color(0xFF626262),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _inputController,
                      maxLines: null,
                      minLines: 8,
                      decoration: InputDecoration(
                        hintText: 'My burden as a nurse is so heavy...',
                        filled: true,
                        fillColor: const Color(0xFFF9FAFB),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.grey,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.blue, // Warna border saat fokus
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.keyboard_voice),
                          SizedBox(width: 10),
                          TextButton(
                            onPressed: () {
                              showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text(
                                      'Speech is not Available for now'),
                                  content: const Text(
                                      'Sorry speech service is still on maintenance'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'OK'),
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Text(
                              'Use voice instead',
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
              child: ElevatedButton(
                onPressed: () async {
                  bool result = await _getResult();
                  bool result2 = await _identifyText();
                  if ((result && result2) && _emotionResult.isNotEmpty) {
                    String IdentifiedText = _textIdentified.join(" ");
                    dev.log("identified text: $IdentifiedText");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AssessmentResultPage(
                          emotionResult: _emotionResult.first,
                          textIdentified: IdentifiedText,
                        ),
                      ),
                    );
                  } else {
                    dev.log("Emotion result is empty or error occurred");
                    // Tampilkan pesan error kepada pengguna
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Failed to analyze emotion. Please try again.'),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(
                      double.infinity, 50), // Tombol memenuhi lebar layar
                ),
                child: const Text('Continue'),
              ),
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}
