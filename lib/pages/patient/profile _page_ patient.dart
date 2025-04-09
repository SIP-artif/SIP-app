import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myapp/pages/patient/carbs_patient.dart';
import 'package:myapp/pages/patient/home%20page%20patient.dart';
import 'package:myapp/pages/personal_info_page.dart';


class PatientProfilePage extends StatelessWidget {
  final Color backgroundColor = Color(0xFFF4F7FC);
  final Color blackColor = Color(0xFF000000);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.fastfood), label: "Carbs"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          }
           if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CarbsTrackerApp()),
            );
          }
        },
      ),
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: Text(
          'My Profile',
          style: TextStyle(color: blackColor, fontSize: 24, fontWeight: FontWeight.bold),
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
                title: Text('Personal Information', style: TextStyle(color: blackColor)),
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
                style: TextStyle(
                  color: blackColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                )),
            SizedBox(height: 12),
            _buildOverviewItem(Icons.devices, 'My Devices', onTap: () {
  Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
}),
_buildOverviewItem(Icons.medical_services, 'My Doctor', onTap: () {
  Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
}),
_buildOverviewItem(Icons.history, 'History', onTap: () {
  Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
}),
_buildOverviewItem(Icons.play_circle_outline, 'Get Started', onTap: () {
  Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
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
      title: Text(title, style: TextStyle(color: blackColor)),
      trailing: Icon(Icons.arrow_forward_ios, color: blackColor, size: 16),
      onTap: onTap,
    ),
  );
}
}
