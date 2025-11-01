import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/pages/patient/patient_carb_tracker.dart';
import 'package:myapp/pages/patient/patient_home.dart';
import 'package:myapp/pages/patient/patient_profile.dart';
import 'package:myapp/services/shared_prefs_service.dart';

class TutorialPagePatient extends StatelessWidget {
  const TutorialPagePatient({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      appBar: AppBar(
        title: Text(
          'Insulin Pump Setup',
          style: GoogleFonts.lato( fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFF4F7FC),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            // Video Placeholder
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 2,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.play_arrow,
                  size: 70,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 50),
            // Watch the Tutorial Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF297CC0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                },
                child: Text(
                  'Watch the Tutorial',
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            Center(
              child: GestureDetector(
                onTap: () {
                },
                child: Text(
                  'Having trouble setting up your smart pump?',
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                      color: Color(0xFF2C7BBC),
                      decoration: TextDecoration.underline,
                      fontSize: 16,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 30),
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
}
