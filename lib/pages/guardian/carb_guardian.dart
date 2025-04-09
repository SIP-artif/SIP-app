import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/pages/guardian/guardian_home_page.dart';
import 'package:myapp/pages/guardian/guardian_profile_page.dart';
import 'package:myapp/pages/patient/home%20page%20patient.dart';
import 'package:myapp/pages/patient/profile%20_page_%20patient.dart';

class CarbsPage extends StatefulWidget {
  const CarbsPage({super.key});

  @override
  State<CarbsPage> createState() => _CarbsTrackerAppState();
}

class _CarbsTrackerAppState extends State<CarbsPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CarbsTrackerPage(),
    );
  }
}

class CarbsTrackerPage extends StatefulWidget {
  const CarbsTrackerPage({super.key});

  @override
  State<CarbsTrackerPage> createState() => _CarbsTrackerPageState();
}

class _CarbsTrackerPageState extends State<CarbsTrackerPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> fetchCarbHistory() async {
    QuerySnapshot snapshot = await _firestore.collection('carbHistory').get();
    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Carbohydrates Tracker',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.fastfood), label: 'Carbs'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => GuardianHomePage(guardianId: 'fBlCBuQHY1Z26H1IanKl')),
            );
          }
           if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePageGuardian()),
            );
          }
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Enter carbs (grams)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(10),
                    ),
                    child: const Text('+'),
                  ),
                  const SizedBox(width: 5),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(10),
                    ),
                    child: const Text('-'),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    'Add Entry',
                    style: GoogleFonts.lato(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'History (Last 10 Days)',
                style: GoogleFonts.lato(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blue.shade50,
                  ),
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: fetchCarbHistory(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No data available.'));
                      }

                      var carbHistory = snapshot.data!;
                      return ListView.builder(
                        itemCount: carbHistory.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  carbHistory[index]['date'],
                                  style: GoogleFonts.lato(fontSize: 16),
                                ),
                                Text(
                                  '${carbHistory[index]['amount']}g',
                                  style: GoogleFonts.lato(fontSize: 16),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
