import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:neumedic/recomendation_page.dart';
import 'dart:developer' as dev;

class AssessmentResultPage extends StatefulWidget {
  final String emotionResult;
  final String textIdentified;
  const AssessmentResultPage(
      {super.key, required this.emotionResult, required this.textIdentified});

  @override
  State<StatefulWidget> createState() => _AssessmentResultPageState();
}

class _AssessmentResultPageState extends State<AssessmentResultPage> {
  final Gemini gemini = Gemini.instance;
  final List<String> _recommendations = [];

  @override
  void initState() {
    super.initState();
  }

  Future<bool> _identifyText() async {
    Completer<bool> completer = Completer<bool>();
    try {
      String question =
          '"${widget.textIdentified}" give me a short recommendation about that in format : title and subtitle';
      gemini.streamGenerateContent(question).listen((event) {
        String? response = event?.output;
        if (response != null) {
          setState(() {
            _recommendations.add(response);
          });
          dev.log("response $response");
          dev.log(
              "meaning: ${_recommendations.join(" ")} 0:${_recommendations.first}");
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
            "Assessment Result",
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
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      child: Image.asset(
                        "assets/icons/netral.png",
                        width: 110,
                        height: 110,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "I feel ${widget.emotionResult}...",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      "I'm like:",
                      style: TextStyle(
                        color: Color(0xFF626262),
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 15),
                    _buildFeedbackContainer(widget.textIdentified),
                    // const SizedBox(height: 10),
                    // _buildFeedbackContainer("Drinking less water"),
                    const SizedBox(height: 15),
                    const Text(
                      "*Sometimes AI can make mistakes, so double-check the result.",
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 25.0, vertical: 5.0),
              child: ElevatedButton(
                onPressed: () async {
                  bool result = await _identifyText();
                  if (result && _recommendations.isNotEmpty) {
                    // Regex untuk Title
                    RegExp titleRegExp = RegExp(r'\*\* Title:\*\*\s*(.+?)\n');
                    // Regex untuk Subtitle
                    RegExp subtitleRegExp = RegExp(r'\*\*Subtitle:\*\*\s*(.+)');
                    String mainRecommendation = _recommendations.join(" ");
                    // Match Title
                    String? title = titleRegExp
                        .firstMatch(mainRecommendation)
                        ?.group(1)
                        ?.trim();
                    // Match Subtitle
                    String? subtitle = subtitleRegExp
                        .firstMatch(mainRecommendation)
                        ?.group(1)
                        ?.trim();
                    dev.log("title $title, subtitle $subtitle");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecomendationPage(
                          title: title!,
                          subtitle: subtitle!,
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  'See Recommendations for You',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 25.0, vertical: 5.0),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.white,
                  side: const BorderSide(
                    color: Colors.blue,
                    width: 1,
                  ),
                ),
                child: const Text(
                  "Try Again",
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedbackContainer(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(27)),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
      ),
    );
  }
}
