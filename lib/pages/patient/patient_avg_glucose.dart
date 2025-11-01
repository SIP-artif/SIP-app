import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:myapp/pages/patient/patient_carb_tracker.dart';
import 'package:myapp/pages/patient/patient_home.dart';
import 'package:myapp/pages/patient/patient_profile.dart';
import 'package:myapp/services/shared_prefs_service.dart';

class AvgGlucosePage extends StatelessWidget {
  final List<double> glucoseValues = [279, 203, 251, 210, 198, 253, 275, 276];
  final List<String> times = [
    '00:00',
    '03:00',
    '06:00',
    '09:00',
    '12:00',
    '15:00',
    '18:00',
    '21:00'
  ];

  final List<Color> barColors = [
    Color(0xFFFF5C3C),
    Color(0xFFFFC107),
    Color(0xFFFFA000),
    Color(0xFFFFC107),
    Color(0xFFFFEB3B),
    Color(0xFFFF5722),
    Color(0xFFFF5722),
    Color(0xFFFF3D00),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "Average Glucose",
          style: GoogleFonts.lato(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(height: 8),
            Center(
              child: Text(
                "5 - 11 May  2025",
                style: GoogleFonts.lato(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 30),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: AspectRatio(
                      aspectRatio: 1.2,
                      child: BarChart(
                        BarChartData(
                          barGroups: List.generate(glucoseValues.length, (index) {
                            return BarChartGroupData(
                              x: index,
                              barRods: [
                                BarChartRodData(
                                  toY: glucoseValues[index],
                                  color: barColors[index],
                                  width: 16,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ],
                            );
                          }),
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, _) {
                                  int index = value.toInt();
                                  if (index < times.length) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Text(
                                        times[index],
                                        style: GoogleFonts.lato(fontSize: 14),
                                      ),
                                    );
                                  }
                                  return SizedBox.shrink();
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                            topTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                            rightTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                          ),
                          gridData: FlGridData(show: false),
                          borderData: FlBorderData(show: false),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Average: 224 mg/dL",
                    style: GoogleFonts.lato(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
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