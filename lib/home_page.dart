import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

import 'package:neumedic/daily_assessment_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDate = DateTime.now();
  List<DateTime> _weekDates = [];

  void _updateWeekDates(DateTime selectedDate) {
    final int currentWeekDay = selectedDate.weekday; // 1 = Monday, 7 = Sunday
    final DateTime sunday = selectedDate.subtract(Duration(days: currentWeekDay));
    setState(() {
      _weekDates = List.generate(7, (index) => sunday.add(Duration(days: index)));
    });
  }

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
      _updateWeekDates(pickedDate);
    }
  }

  List<String> moods = ['very_angry', 'angry', 'netral', 'happy', 'very_happy'];

  String getRandomMood(List<String> words) {
  // Membuat objek Random
  Random random = Random();
  
  // Menghasilkan indeks acak dan mengembalikan kata dari daftar
  int randomIndex = random.nextInt(words.length);
  return words[randomIndex];
}

  @override
  void initState() {
    super.initState();
    _updateWeekDates(_selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue[50],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundImage: NetworkImage(
                                  'https://pics.craiyon.com/2023-11-26/oMNPpACzTtO5OVERUZwh3Q.webp'
                                ),
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
                                    'Situ Team',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 52),
                      const Text(
                        'How are you today?',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildMoodIcon("very_angry"),
                          _buildMoodIcon("angry"),
                          _buildMoodIcon("netral"),
                          _buildMoodIcon("happy"),
                          _buildMoodIcon("very_happy"),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DailyAssessmentPage(),
                              ),
                            );
                          },
                          child: const Text('Take Assessment'),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, -3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Mood Stats', 
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                            )
                          ),
                          InkWell(
                            onTap: _selectDate,
                            child: const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Icon(Icons.date_range)
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: _weekDates.map((date) {
                          return _buildDayBox(
                            DateFormat('E').format(date), // Format singkat nama hari
                            DateFormat('d').format(date), // Format tanggal
                            date == _selectedDate,
                            getRandomMood(moods)
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Weekly Report', 
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                        )
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: 1000,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Column(
                          children: [
                            Text(
                              'No Available Report',
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            SizedBox(height: 10),
                            Text('Take an assessment with EEG module to get'),
                          ],
                        ),
                      ),
                      SizedBox(height: 50),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMoodIcon(String mood) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: AssetImage('assets/icons/${mood}.png')
        )
      ),
      // child: ,
    );
  }

  Widget _buildDayBox(String day, String date, bool isSelected, String mood) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
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
              Text(
                day.substring(0, 1),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
              Text(
                date,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20,),
        _buildMoodIcon(mood)
      ],
    );
  }
}