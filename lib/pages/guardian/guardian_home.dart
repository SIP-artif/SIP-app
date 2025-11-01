import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/pages/guardian/guardian_modify_does.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:myapp/pages/guardian/guardian_carb_tracker.dart';
import 'package:myapp/pages/guardian/guardian_profile.dart';
import 'package:myapp/pages/menu.dart';
import 'package:myapp/pages/guardian/guardian_predicted_events.dart';
import 'package:myapp/services/user_service.dart';

class GuardianHomePage extends StatefulWidget {
  const GuardianHomePage({super.key});

  @override
  _GuardianHomePageState createState() => _GuardianHomePageState();
}

class _GuardianHomePageState extends State<GuardianHomePage> {
  final UserService _userService = UserService();
  List<Map<String, dynamic>> members = [];
  String? selectedMemberId;
  Map<String, dynamic>? memberData;
  double? suggestedDose;
  String? infoMessage;

  @override
  void initState() {
    super.initState();
    loadGuardianId();
  }

  Future<void> loadGuardianId() async {
    final prefs = await SharedPreferences.getInstance();
    final guardianId = prefs.getString('userId');
    if (guardianId != null) {
      fetchFamilyMembers(guardianId);
    }
  }

  Future<void> fetchFamilyMembers(String guardianId) async {
    final fetchedMembers = await UserService.fetchFamilyMembers(guardianId);
    setState(() {
      members = fetchedMembers;
      if (members.isNotEmpty) {
        selectedMemberId = members.first['id'];
        fetchMemberData(selectedMemberId!);
      }
    });
  }

  Future<void> fetchMemberData(String memberId) async {
  try {
    final userRef = FirebaseFirestore.instance.collection('Users').doc(memberId);

    final querySnapshot = await FirebaseFirestore.instance
        .collection('Daily_Data')
        .where('user_id', isEqualTo: userRef)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final data = await _userService.fetchUserGlucoseData(memberId);
      print("Fetched Member Data: $data");
      setState(() {
        memberData = data;
        suggestedDose = data['additional_doses'];
        infoMessage = null;
      });
    } else {
      print("No Daily_Data found for this user");
      setState(() {
        memberData = null;
        suggestedDose = null;
        infoMessage = "No health data available for this member!";
      });
    }
  } catch (e) {
    print("Error checking/fetching member data: $e");
    setState(() {
      memberData = null;
      suggestedDose = null;
      infoMessage = "An error occurred while fetching data.";
    });
  }
}

  LineChartData mainChartData() {
  final now = DateTime.now();
  final currentHour = now.hour.toDouble();
  final minHour = currentHour - 5;

  // Get all glucose spots
  final List<FlSpot> allSpots = memberData?['glucoseSpots'] ?? [];

  // Group the glucose spots by hour and calculate the average for each hour
  List<FlSpot> hourlyAverages = [];
  Map<int, List<double>> glucoseByHour = {};

  // Group glucose readings by hour
  for (var spot in allSpots) {
    final hour = spot.x.toInt();
    if (!glucoseByHour.containsKey(hour)) {
      glucoseByHour[hour] = [];
    }
    glucoseByHour[hour]!.add(spot.y);
  }

  // Calculate the average glucose for each hour
  glucoseByHour.forEach((hour, readings) {
    final average = readings.reduce((a, b) => a + b) / readings.length;
    hourlyAverages.add(FlSpot(hour.toDouble(), average));
  });

  // Filter to show only last 5 hours
  final List<FlSpot> visibleSpots = hourlyAverages
      .where((spot) => spot.x >= minHour && spot.x <= currentHour)
      .toList();

  return LineChartData(
    gridData: FlGridData(show: false),
    titlesData: FlTitlesData(
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: 20,
          reservedSize: 40,
          getTitlesWidget: (value, _) => Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Text(
              "${value.toInt()}",
              style: const TextStyle(fontSize: 10),
              textAlign: TextAlign.right,
            ),
          ),
        ),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          interval: 1,
          getTitlesWidget: (value, _) {
            final hour = value.toInt();
            final displayHour = hour % 12 == 0 ? 12 : hour % 12;
            final period = hour >= 12 ? 'PM' : 'AM';
            final label = hour == DateTime.now().hour ? "Now" : "$displayHour $period";
            return Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                label,
                style: const TextStyle(fontSize: 10),
                textAlign: TextAlign.center,
              ),
            );
          },
        ),
      ),
      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
    ),
    borderData: FlBorderData(
      show: true,
      border: const Border(
        left: BorderSide(color: Colors.black54),
        bottom: BorderSide(color: Colors.black54),
      ),
    ),
    minX: minHour,
    maxX: currentHour,
    minY: 0,
    maxY: 180,
    lineBarsData: [
      LineChartBarData(
        spots: visibleSpots,
        isCurved: true,
        color: Colors.black,
        barWidth: 3,
        dotData: FlDotData(
          show: true,
          getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
            radius: 4,
            color: Colors.blue,
            strokeWidth: 2,
            strokeColor: Colors.white,
          ),
        ),
      ),
    ],
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Welcome, Guardian!",
              style: GoogleFonts.lato(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Menu(),
          ],
        ),
      ),
      backgroundColor: Color(0xFFF4F7FC),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 30,),
              if (members.isNotEmpty)
                Container(
                  width: 360,
                  height: 55,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(3.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children:
                        members.map((member) {
                          return ChoiceChip(
                            label: Text(
                              member['name'],
                              style: GoogleFonts.lato(fontSize: 18),
                            ),
                            selected: selectedMemberId == member['id'],
                            onSelected: (selected) {
                              setState(() => selectedMemberId = member['id']);
                              fetchMemberData(member['id']);
                            },
                            selectedColor: Colors.white,
                            backgroundColor: Colors.grey.shade400,
                            labelStyle: GoogleFonts.lato(
                              color:
                                  selectedMemberId == member['id']
                                      ? Colors.black
                                      : Colors.black54,
                            ),
                            side: BorderSide(
                              color:
                                  selectedMemberId == member['id']
                                      ? Colors.black
                                      : Colors.transparent,
                            ),
                          );
                        }).toList(),
                  ),
                ),
                if (infoMessage != null) ...[
                  SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      infoMessage!,
                      style: GoogleFonts.lato( fontSize: 18,color: Colors.redAccent,fontWeight: FontWeight.w500,),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],

              if (memberData != null) ...[
                SizedBox(height: 40),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 15, 25, 7),
                      child: AspectRatio(
                        aspectRatio: 1.3,
                        child: LineChart(mainChartData()),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: 360,
                  height: 90,
                  child: InkWell(
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => PredictedEventsPage(
                                  userId: selectedMemberId!,
                                ),
                          ),
                        ),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.blueGrey, width: 0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: ListTile(
                          title: Text(
                            "Predicted Event: ${memberData!['predicted_event']}\nPredicted GL: ${memberData!['predicted_gl']}",
                            style: GoogleFonts.lato(fontSize: 16),
                          ),
                          trailing: Icon(
                            Icons.chevron_right,
                            color: Colors.black,
                            size: 35,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: 360,
                  height: 60,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => ModifyDosePage(
                                userId: selectedMemberId!,
                                suggestedDose: suggestedDose ?? 0.0,
                              ),
                        ),
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.blueGrey, width: 0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        title: Text(
                          "Suggested Dose: $suggestedDose units",
                          style: GoogleFonts.lato(fontSize: 16),
                        ),
                        trailing: Icon(
                          Icons.chevron_right,
                          color: Colors.black,
                          size: 35,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),
                SizedBox(
                width: 357,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Add emergency call action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE85454),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.local_hospital, color: Colors.white),
                      const SizedBox(width: 10),
                      Text(
                        "Call Emergency (997)",
                        style: GoogleFonts.lato(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30,),
              ],
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
  currentIndex: 0,
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