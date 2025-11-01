import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/pages/guardian/guardian_add_member.dart';
import 'package:myapp/pages/guardian/guardian_carb_tracker.dart';
import 'package:myapp/pages/guardian/guardian_home.dart';
import 'package:myapp/pages/guardian/guardian_profile.dart';
import 'package:myapp/pages/guardian/guardian_display_member.dart';

class MyFamilyPage extends StatelessWidget {
  const MyFamilyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      appBar: AppBar(
        leading: BackButton(),
        backgroundColor: const Color(0xFFF4F7FC),
        elevation: 0,
        title: Row(
          children: [
            Text(
              'My Family',
              style: GoogleFonts.lato(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFF4F7FC),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildButton('Adding New Member', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddMemberPage()),
                );
              }),
              const SizedBox(height: 16),
              _buildButton('Display The Members', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FamilyMembersPage()),
                );
              }),
            ],
          ),
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

  Widget _buildButton(String title, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        title: Text(title, style: GoogleFonts.lato(color: Colors.black)),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.black,
        ),
        onTap: onTap,
      ),
    );
  }
}
