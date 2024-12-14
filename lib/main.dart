import 'package:flutter/material.dart';
import 'package:neumedic/chatbot_page.dart';
import 'package:neumedic/home_page.dart';
import 'package:neumedic/signin_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: false,
      ),
      home: const SigninPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = <Widget>[
    const HomePage(),
  ];

  final List<IconData> _icons = [
    Icons.home_outlined,
    Icons.insert_chart_outlined_rounded,
    Icons.logout,
  ];

  void _onItemTapped(int index) {

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ChatbotPage()), 
      );
    }else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SigninPage()),
      );
    }else{
      setState(() {
        _selectedIndex = index;
      });
    } 
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: _pages[_selectedIndex],
        bottomNavigationBar: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
            boxShadow: [
              BoxShadow(
                color: Color(0x20208FF6),
                offset: Offset(0, -2),
                blurRadius: 50,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              _icons.length,
              (index) => GestureDetector(
                onTap: (() => _onItemTapped(index)),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  transform: index == 1
                      ? Matrix4.translationValues(0, -33, 0) // Menu tengah lebih tinggi
                      : Matrix4.identity(),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (index == 1)
                        Container(
                          width: 60,
                          height: 60,
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
                          child: Image.asset(
                            'assets/icons/icon-neumedic.png',
                            width: 60,
                            height: 60,
                          ),
                        )
                      else
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Icon(
                            _icons[index],
                            size: 30,
                            color: index == _selectedIndex
                                ? Colors.blue
                                : Colors.grey,
                          ),
                        ),
                      if (index == _selectedIndex && index != 1)
                        Positioned(
                          bottom: 10,
                          child: Container(
                            width: 7,
                            height: 7,
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
