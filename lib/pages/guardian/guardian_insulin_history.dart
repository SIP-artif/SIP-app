import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/pages/guardian/guardian_carb_tracker.dart';
import 'package:myapp/pages/guardian/guardian_home.dart';
import 'package:myapp/pages/guardian/guardian_profile.dart';


class InsulinHistoryPage extends StatelessWidget {
  final List<Map<String, String>> insulinData = [
    {"date": "Jan 3 10:30 AM", "units": "20 units"},
    {"date": "Jan 3 08:15 PM", "units": "4 units"},
    {"date": "Jan 4 12:45 AM", "units": "2 units"},
    {"date": "Jan 4 10:30 AM", "units": "20 units"},
    {"date": "Jan 5 9:00 AM", "units": "5 units"},
    {"date": "Jan 5 7:45 PM", "units": "6 units"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4F7FC),
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: Text(
          'Insulin History',
          style: GoogleFonts.lato(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: const Color(0xFFE6EFF8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Date & Time',
                            style: GoogleFonts.lato(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Text(
                          'Insulin',
                          style: GoogleFonts.lato(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(width: 10),
                      ],
                    ),
                    
                    Divider(color: Color(0xFFABABAB)),
                    ...insulinData.map((entry) {
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Row(
                              children: [
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    entry['date']!,
                                    style: GoogleFonts.lato(
                                      fontSize: 16,
                                      color: Color(0xFF535353),
                                    ),
                                  ),
                                ),
                                Text(
                                  entry['units']!,
                                  style: GoogleFonts.lato(
                                    fontSize: 16,
                                    color: Color(0xFF535353),
                                  ),
                                ),
                                SizedBox(width: 10),
                              ],
                            ),
                          ),
                          Divider(color: Color(0xFFABABAB), height: 1),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                'For the past 10 days',
                style: GoogleFonts.lato(
                  color: Color(0xFF8EA2B4),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
  currentIndex: 2,
  backgroundColor: Color(0xFFFFFFFF),
  selectedItemColor: Color(0xFF215F90),
  unselectedItemColor: Color(0xFF215F90).withOpacity(0.6),
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
  onTap: (index) {
    switch (index) {
      case 0:
        Navigator.push(context, MaterialPageRoute(
          builder: (_) => GuardianHomePage(),
        ));
        break;
      case 1:
        Navigator.push(context, MaterialPageRoute(
          builder: (_) => CarbTrackingPage(),
        ));
        break;
      case 2:
        Navigator.push(context, MaterialPageRoute(
          builder: (_) => ProfilePageGuardian(),
        ));
        break;
    }
  },
),
    );
  }
}