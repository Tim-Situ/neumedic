import 'package:flutter/material.dart';

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
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue[50],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  backgroundImage: NetworkImage(
                                      'https://via.placeholder.com/150'),
                                ),
                                SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Good morning,',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    Text(
                                      'Muhammad Haulul',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              print("Tes");
                            },
                            icon: Icon(Icons.notifications_outlined),
                          ),
                        ],
                      ),
                      SizedBox(height: 52),
                      Text(
                        'How are you today?',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildMoodIcon(Colors.red),
                          _buildMoodIcon(Colors.orange),
                          _buildMoodIcon(Colors.yellow),
                          _buildMoodIcon(Colors.green),
                          _buildMoodIcon(Colors.greenAccent),
                        ],
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {},
                          child: Text('Take Assessment'),
                        ),
                      ),
                      SizedBox(height: 32),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, -3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Mood Stats', style: TextStyle(fontSize: 18)),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildDayBox('S', '14'),
                          _buildDayBox('M', '18'),
                          _buildDayBox('T', '15', isSelected: true),
                          _buildDayBox('W', '17'),
                          _buildDayBox('T', '19'),
                          _buildDayBox('F', '20'),
                          _buildDayBox('S', '20'),
                        ],
                      ),
                      SizedBox(height: 20),
                      Text('Weekly Report', style: TextStyle(fontSize: 18)),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Text('No Available Report'),
                            SizedBox(height: 10),
                            Text('Take an assessment with EEG module to get'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, color: Colors.blue),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart, color: Colors.black),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today, color: Colors.black),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings, color: Colors.black),
              label: '',
            ),
          ],
          currentIndex: 0, // Indeks item yang aktif
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.black,
          showUnselectedLabels: false,
          showSelectedLabels: false,
          onTap: (index) {
            // Tambahkan logika untuk navigasi jika diperlukan
          },
        ),
      ),
    );
  }

  Widget _buildMoodIcon(Color color) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildDayBox(String day, String date, {bool isSelected = false}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue : Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.black12,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(day),
          Text(
            date,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
