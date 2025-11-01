import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/pages/guardian/guardian_carb_tracker.dart';
import 'package:myapp/pages/guardian/guardian_home.dart';
import 'package:myapp/pages/guardian/guardian_profile.dart';

class TimeInRangePage extends StatelessWidget {
  const TimeInRangePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      appBar: AppBar(
        leading: BackButton(),
        title: Text(
          'Time In Range',
          style: GoogleFonts.lato(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              '4 - 10 May',
              style: GoogleFonts.lato(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'mg/dL',
                style: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.w600,),
              ),
            ),
            const SizedBox(height: 10),

            // TIR Bar Chart (simulated with Rows)
            _buildBar('> 240', 0.54, Colors.deepOrange),
            _buildBar('181-240', 0.23, Colors.orange),
            _buildBar('70-180', 0.19, Colors.lightGreen),
            _buildBar('< 70', 0.04, Colors.redAccent),

            const SizedBox(height: 20),
            Text(
              'Target Range: 70-180 mg/dL',
              style: GoogleFonts.lato(fontSize: 18),
            ),
            const SizedBox(height: 20),

            // Date Range Buttons
            SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: Row(
    mainAxisSize: MainAxisSize.min ,
    children: [
      _buildRangeButton('7 Days', true),
      const SizedBox(width: 10),
      _buildRangeButton('14 Days', false),
      const SizedBox(width: 10),
      _buildRangeButton('30 Days', false),
    ],
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

  Widget _buildBar(String label, double percentage, Color color) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 15),
    child: LayoutBuilder(
      builder: (context, constraints) {
        // Calculate max available width minus label and percentage text
        double totalWidth = constraints.maxWidth;
        double labelWidth = 80;
        double spaceAfterBar = 45; // extra space for '%'
        double availableBarWidth = totalWidth - labelWidth - spaceAfterBar;

        return Row(
          children: [
            SizedBox(
              width: labelWidth,
              child: Text(
                label,
                style: GoogleFonts.lato(fontSize:16, fontWeight:FontWeight.w600),
              ),
            ),
            SizedBox(
              width: availableBarWidth,
              child: Stack(
                children: [
                  Container(
                    height: 30,
                    width: availableBarWidth * percentage,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 5),
            Text(
              '${(percentage * 100).toInt()}%',
              style: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        );
      },
    ),
  );
}

 Widget _buildRangeButton(String label, bool isSelected) {
  return Container(
    margin: const EdgeInsets.only(right: 4),
    decoration: BoxDecoration(
      color: isSelected ? const Color(0xFFFFFFFF) : Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: const Color(0xFFCDD5DF)),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
    child: Text(
      label,
      style: GoogleFonts.lato(
        fontSize: 16,
        color: Colors.black,
      ),
    ),
  );
}
}