import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/pages/patient/patient_TIR.dart';
import 'package:myapp/pages/patient/patient_avg_glucose.dart';
import 'package:myapp/pages/patient/patient_insulin_history.dart';
import 'package:myapp/pages/patient/patient_carb_tracker.dart';
import 'package:myapp/pages/patient/patient_home.dart';
import 'package:myapp/pages/patient/patient_predicted_events.dart';
import 'package:myapp/pages/patient/patient_profile.dart';
import 'package:myapp/services/shared_prefs_service.dart';

class HistoryPagePatient extends StatelessWidget {

  const HistoryPagePatient({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4F7FC),
      appBar: AppBar(
        leading: BackButton(),
        title: Text(
          'History',
          style: GoogleFonts.lato(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Card Grid
            Container(
              decoration: BoxDecoration(
                color: Color(0xFFF4F7FC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Color(0xFFCDD5DF), width: 1),
              ),
              padding: EdgeInsets.all(16),
              child: GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                childAspectRatio: 1.3,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                children: [
                  _buildInnerCard("Average Glucose", context),
                  _buildInnerCard("Insulin history", context),
                  _buildInnerCard("Time In Range (TIR)", context),
                  _buildInnerCard("Predicted events", context),
                ],
              ),
            ),
            const SizedBox(height: 40),
            _buildHistoryTable(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex:2,
  backgroundColor: Color(0xFFFFFFFF), // White background
  selectedItemColor: Color(0xFF215F90), // Icon and label when selected
  unselectedItemColor: Color(0xFF215F90).withOpacity(0.6), // Slightly faded for unselected
  showUnselectedLabels: true,
  selectedLabelStyle: GoogleFonts.lato(
    fontWeight: FontWeight.w500,
    fontSize: 13,
  ),
  unselectedLabelStyle: GoogleFonts.lato(
    fontWeight: FontWeight.w300,
    fontSize: 12,
  ),
  items: const [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: "Home",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.fastfood),
      label: "Carbs",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: "Profile",
    ),
  ],
  onTap: (index) async {
    String? uid = await getUserIdFromPrefs();
    if (index == 1) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => CarbsPagePatient()));
    } else if (index == 2) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => PatientProfilePage()));
    } else if (index == 0) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => UserHomePage(userId: uid!)));
    }
  },
),
    );
  }

Widget _buildInnerCard(String title, BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2 - 26,
      child: GestureDetector(
        onTap: () {
          if (title == "Insulin history") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => InsulinHistoryPage()),
            );
          }else if (title == "Predicted events") {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PredictedEventsPage()),
    );
  } else if (title == "Time In Range (TIR)"){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TimeInRangePage()),
    );
  } else if (title == "Average Glucose"){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AvgGlucosePage()),
    );
  }
},
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFFFBFCFF),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color(0xFFCDD5DF), width: 1),
          ),
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold)),
              Align(
                alignment: Alignment.bottomRight,
                child: Icon(Icons.arrow_forward_ios, size: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildHistoryTable() {
    final List<Map<String, dynamic>> historyData = [
      {"dateTime": "Jan 3\n10:30 AM", "glucose": 75, "insulin": 0, "event": "Low"},
      {"dateTime": "Jan 15\n08:15 PM", "glucose": 180, "insulin": 4, "event": "High"},
      {"dateTime": "Jan 28\n12:45 PM", "glucose": 190, "insulin": 4, "event": "High"},
    ];

    Color getEventColor(String event) {
      switch (event) {
        case "Low":
          return Color(0xFFE85454);
        case "High":
          return Color(0xFFEAB308);
        default:
          return Colors.black;
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFE6EFF8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFCDD5DF), width: 1),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: Text("Date & Time", style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold))),
              Expanded(child: Text("Glucose", style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold))),
              Expanded(child: Text("Insulin", style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold))),
              Expanded(child: Text("Events", style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold))),
            ],
          ),
          Divider(color: Color(0xFFABABAB)),
          ...historyData.map((entry) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Row(
                    children: [
                      Expanded(child: Text(entry["dateTime"], style: GoogleFonts.lato(fontSize: 16, color: Color(0xFF535353)))),
                      Expanded(child: Text("${entry["glucose"]} \nmg/dL", style: GoogleFonts.lato(fontSize: 16, color: Color(0xFF535353)))),
                      Expanded(child: Text("${entry["insulin"]} units", style: GoogleFonts.lato(fontSize: 16, color: Color(0xFF535353)))),
                      Expanded(
                        child: Text(entry["event"],
                          style: GoogleFonts.lato(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: getEventColor(entry["event"]),
                          )),
                      ),
                    ],
                  ),
                ),
                Divider(color: Color(0xFFABABAB)),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }
}