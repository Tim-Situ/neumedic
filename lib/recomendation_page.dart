import 'package:flutter/material.dart';

class RecomendationPage extends StatefulWidget {
  const RecomendationPage({super.key});

  @override
  State<StatefulWidget> createState() => _RecomendationPageState();
}

class _RecomendationPageState extends State<RecomendationPage> {
  @override
  void initState() {
    super.initState();
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
            "Recomendation",
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
                      "I think you need to:",
                      style: TextStyle(
                        color: Color(0xFF626262),
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 15),
                    _buildFeedbackContainer(
                      "Take a short break, lie down for 15 minutes",
                      "Put away your cellphone and objects that can distract you"
                    ),
                    const SizedBox(height: 10),
                    _buildFeedbackContainer(
                      "Drink lots of water to avoid dehydration",
                      "adults need 2-3 liters (around 8-12 glasses) of water per day"
                    ),
                    const SizedBox(height: 60),
                    const Text(
                      "Relaxing music:",
                      style: TextStyle(
                        color: Color(0xFF626262),
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 15),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(27)),
                        border: Border.all(color: const Color(0xFFE8E8E8)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 80,   // Lebar container
                            height: 80, // Tinggi container
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(27)),
                              border: Border.all(color: const Color(0xFFE8E8E8)),
                            ),
                            margin: const EdgeInsets.only(right: 12),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(27), // Sama dengan border radius container
                              child: Image.network(
                                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS2LHYJ-uDwMRTvnI8LOJNmc21N14GtO77nXw&s",
                                fit: BoxFit.cover, // Gambar memenuhi container
                              ),
                            ),
                          ),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Relaxing Sleep Music + Stress Relief - Relaxing Music, Deep Sleep Instantly",
                                  style: TextStyle(
                                    color: Color(0xFFF57F17),
                                    fontSize: 14
                                  ),
                                ),
                                SizedBox(height: 10,),
                                Text(
                                  "Watch on Youtube",
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 5.0),
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

  Widget _buildFeedbackContainer(String title, String description) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(27)),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFFF57F17),
              fontSize: 14
            ),
          ),
          SizedBox(height: 10,),
          Text(
            description,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
