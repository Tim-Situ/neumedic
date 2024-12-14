import 'package:flutter/material.dart';

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

  ScrollController _scrollController = ScrollController();  // Tambahkan ScrollController

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _messages.add({"sender": "user", "text": _controller.text});
        _messages.add({"sender": "bot", "text": "You said: ${_controller.text}"});
      });
      _controller.clear();
      _scrollToBottom();
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
          color: message["sender"] == "bot" ? Colors.white : Color(0xFFE7F9FF),
          borderRadius: const BorderRadius.all(Radius.circular(27)),
          border: Border.all(
            color: Color(0xFFE8E8E8)
          )
        ),
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,  // Set controller ke ListView
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
                SizedBox(width: 13,),
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
                SizedBox(width: 13,),
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
}
