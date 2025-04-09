import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/pages/guardian/carb_guardian.dart';
import 'package:myapp/pages/guardian/guardian_home_page.dart';
import 'package:myapp/pages/guardian/member-page.dart';

class MyFamilyPage extends StatelessWidget {
  const MyFamilyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC), 
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4F7FC),
        elevation: 0,
        title: Row(
          children: [
            const Icon(Icons.groups, color: Colors.black),
            const SizedBox(width: 8),
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
          padding: const EdgeInsets.all(16),
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
              _buildButton('Adding New Member',() {},),
              const SizedBox(height: 16),
              _buildButton(
                'Display The Members',
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FamilyMembersPage()),
                    );
                  },
              )
            ],
          ),
        ),
      ),
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
              MaterialPageRoute(builder: (context) => GuardianHomePage(guardianId: 'fBlCBuQHY1Z26H1IanKl')),
            );
          }
           if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CarbsPage()),
            );
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
      title: Text(
        title,
        style: GoogleFonts.lato(color: Colors.black),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black),
      onTap: onTap,
    ),
  );
}
}
