import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/pages/patient/patient_doctor_main.dart';
import 'package:myapp/pages/patient/patient_carb_tracker.dart';
import 'package:myapp/pages/patient/patient_history.dart';
import 'package:myapp/pages/patient/patient_home.dart';
import 'package:myapp/pages/patient/patient_devices.dart';
import 'package:myapp/pages/patient/patient_personal_info.dart';
import 'package:myapp/pages/patient/patient_tutorial.dart';
import 'package:myapp/services/shared_prefs_service.dart';


class PatientProfilePage extends StatelessWidget {
  final Color backgroundColor = Color(0xFFF4F7FC);
  final Color blackColor = Color(0xFF000000);
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: backgroundColor,
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
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: Text(
          'My Profile',
          style: GoogleFonts.lato(color: blackColor, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: ListTile(
                leading: Icon(Icons.info_outline, color: blackColor),
                title: Text('Personal Information', style: GoogleFonts.lato(color: blackColor, fontSize: 18)),
                trailing: Icon(Icons.keyboard_arrow_down, color: blackColor),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PersonalInfoPage()),
                  );
                },
              ),
            ),
            SizedBox(height: 24),
            Text('Overview',
                style: GoogleFonts.lato(
                  color: blackColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                )),
            SizedBox(height: 12),
            _buildOverviewItem(Icons.devices, 'My Devices', onTap: () async {
  Navigator.push(context, MaterialPageRoute(builder: (context) => MyDevicesPage()));
}),
_buildOverviewItem(Icons.medical_services, 'My Doctor', onTap: () {
  
  Navigator.push(context, MaterialPageRoute(builder: (context) => MyDoctorPagePatient()));
}),
_buildOverviewItem(Icons.history, 'History', onTap: () {
  Navigator.push(context, MaterialPageRoute(builder: (context) => HistoryPagePatient()));
}),
_buildOverviewItem(Icons.play_circle_outline, 'Get Started', onTap: () async {
  Navigator.push(context, MaterialPageRoute(builder: (context) => TutorialPagePatient()));
}),

          ],
        ),
      ),
    );
  }
Widget _buildOverviewItem(IconData icon, String title, {VoidCallback? onTap}) {
  return Container(
    margin: EdgeInsets.only(bottom: 12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 4,
          offset: Offset(0, 2),
        )
      ],
    ),
    child: ListTile(
      leading: Icon(icon, color: blackColor),
      title: Text(title, style: GoogleFonts.lato(color: blackColor, fontSize: 18)),
      trailing: Icon(Icons.arrow_forward_ios, color: blackColor, size: 16),
      onTap: onTap,
    ),
  );
}
}
