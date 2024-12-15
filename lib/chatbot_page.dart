import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'dart:developer' as dev;

import 'package:flutter_tts/flutter_tts.dart';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<StatefulWidget> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  TextEditingController _controller = TextEditingController();
  List<Map<String, String>> _messages = [
    {"sender": "bot", "text": "Hello ujen, how are you?"},
  ];
  final FlutterTts _flutterTts = FlutterTts();
  late String language = 'en-US';
  final Gemini gemini = Gemini.instance;
  final List<String> responses = [];

  ScrollController _scrollController =
      ScrollController(); // Tambahkan ScrollController

  void _sendMessage() {
    try {
      setState(() {
        _messages.add({"sender": "user", "text": _controller.text});
      });
      String question = _controller.text;
      gemini.streamGenerateContent(question).listen((event) {
        Map<String, String> lastMessage = _messages.last;
        if (lastMessage != null && lastMessage["sender"] == "bot") {
          lastMessage = _messages.removeLast();
          String? response = event?.output;
          responses.add(response!);
          String _geminiresponse = responses.join(" ");
          setState(() {
            _messages.add({"sender": "bot", "text": _geminiresponse});
          });
          dev.log("response $response");
          _speak(responses.join(" "));
        } else {
          String? response = event?.output;
          setState(() {
            responses.add(response!);
            _messages.add({"sender": "bot", "text": response});
          });
          dev.log("else on response: $response");
        }
      });
      dev.log(responses.toString());
    } catch (e) {
      dev.log("error: $e");
    } finally {
      setState(() {
        responses.clear();
      });
      dev.log("after clearing: ${responses.toString()}");
      _controller.clear();
      _scrollToBottom();
    }
  }

  Future<void> _speak(String text) async {
    try {
      print("TTS sedang berbicara: $text"); // Debugging
      await _flutterTts.setLanguage(language); // Ubah ke "en-US" jika perlu
      await _flutterTts.setSpeechRate(0.5); // Kecepatan bicara
      await _flutterTts.setVolume(1.0); // Volume maksimum
      await _flutterTts.setPitch(1.0); // Pitch suara
      await _flutterTts.speak(text); // Mulai berbicara
    } catch (e) {
      print("TTS Error: $e");
    }
  }

  // Fungsi untuk scroll ke bawah
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 110,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Widget _buildMessageItem(Map<String, String> message) {
    return Align(
      alignment: message["sender"] == "bot"
          ? Alignment.centerLeft
          : Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
            color:
                message["sender"] == "bot" ? Colors.white : Color(0xFFE7F9FF),
            borderRadius: const BorderRadius.all(Radius.circular(27)),
            border: Border.all(color: Color(0xFFE8E8E8))),
        child: Text(
          message["text"]!,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
          "NeuBot",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  if (language == 'en-US') {
                    language = 'id-ID';
                  } else {
                    language = 'en-US';
                  }
                });
              },
              icon: Icon(
                language == 'en-US'
                    ? Icons.swap_horizontal_circle
                    : Icons.swap_horizontal_circle_outlined,
                color: Colors.orange,
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController, // Set controller ke ListView
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return _buildMessageItem(_messages[index]);
                },
              ),
            ),
            Row(
              children: [
                Container(
                  width: 47,
                  height: 47,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withOpacity(0.3),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.keyboard_voice_sharp, // Ikon yang diinginkan
                    color: Colors.white,
                    size: 30, // Ukuran ikon
                  ),
                ),
                SizedBox(
                  width: 13,
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 13,
                ),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    width: 47,
                    height: 47,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _flutterTts.stop();
    _controller.dispose();
    super.dispose();
  }
}
