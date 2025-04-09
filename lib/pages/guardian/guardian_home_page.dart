import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:myapp/pages/guardian/carb_guardian.dart';
import 'package:myapp/pages/guardian/carb_guardian.dart';
import 'package:myapp/pages/guardian/guardian_profile_page.dart';
import 'package:myapp/pages/menu.dart';

class GuardianHomePage extends StatefulWidget {
  final String guardianId;

  const GuardianHomePage({super.key, required this.guardianId});

  @override
  _GuardianHomePageState createState() => _GuardianHomePageState();
}

class _GuardianHomePageState extends State<GuardianHomePage> {
  List<Map<String, dynamic>> members = [];
  String? selectedMemberId;
  Map<String, dynamic>? memberData;
  num? suggestedDose;

  @override
  void initState() {
    super.initState();
    fetchFamilyMembers();
  }

  Future<void> fetchFamilyMembers() async {
    final guardianDoc = await FirebaseFirestore.instance
        .collection('Guardian')
        .doc(widget.guardianId)
        .get();

    if (guardianDoc.exists) {
      List<dynamic> memberRefs = guardianDoc.data()?['members'] ?? [];

      List<Map<String, dynamic>> fetchedMembers = [];
      for (var memberRef in memberRefs) {
        DocumentSnapshot memberSnapshot =
            await (memberRef as DocumentReference).get();
        if (memberSnapshot.exists) {
          fetchedMembers.add({'id': memberSnapshot.id, 'name': memberSnapshot['name']});
        }
      }

      setState(() {
        members = fetchedMembers;
        if (members.isNotEmpty) {
          selectedMemberId = members.first['id'];
          fetchMemberData(selectedMemberId!);
        }
      });
    }
  }

  Future<void> fetchMemberData(String memberId) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Daily_Data')
        .where('user_id', isEqualTo: FirebaseFirestore.instance.collection('Users').doc(memberId))
        .get();

    setState(() {
      memberData = {
        'glucose_level': querySnapshot.docs.map((doc) {
          return {
            'glucose_level': doc['glucose_level'] as num,
            'current_time': (doc['current_time'] as Timestamp).toDate(),
          };
        }).toList(),
        'predicted_gl': querySnapshot.docs.isNotEmpty
            ? querySnapshot.docs.first.data()['predicted_gl'] ?? 'N/A'
            : 'N/A',
        'predicted_event': querySnapshot.docs.isNotEmpty
            ? querySnapshot.docs.first.data()['predicted_event'] ?? 'None'
            : 'None',
      };
      suggestedDose = querySnapshot.docs.isNotEmpty
          ? querySnapshot.docs.first.data()['additional_doses'] ?? 0
          : 0;
    });
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
              )),
            const Menu(),
          ],
        ),
      ),

      backgroundColor: Color(0xFFF4F7FC),
      body: SingleChildScrollView(
      child: Center(  // Added Center widget to center the content
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,  // Adjust this to your preference (centered or top-aligned)
          crossAxisAlignment: CrossAxisAlignment.center,  // Centers the children horizontally
          children: [
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
                  children: members.map((member) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: ChoiceChip(
                        label: Text(
                          member['name'],
                          style: GoogleFonts.lato(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        selected: selectedMemberId == member['id'],
                        onSelected: (bool selected) {
                          setState(() {
                            selectedMemberId = member['id'];
                          });
                          fetchMemberData(member['id']);
                        },
                        selectedColor: Colors.white,
                        backgroundColor: Colors.grey.shade400,
                        labelStyle: TextStyle(
                          color: selectedMemberId == member['id']
                              ? Colors.black
                              : Colors.black54,
                        ),
                        side: BorderSide(
                          color: selectedMemberId == member['id']
                              ? Colors.black
                              : Colors.transparent,
                          width: 1,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        visualDensity: VisualDensity.compact,
                      ),
                    );
                  }).toList(),
                ),
              ),
            if (memberData != null) ...[
              SizedBox(height: 60),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 15, 25, 7),
              child: AspectRatio(
              aspectRatio: 1.3,
              child: LineChart(mainChartData()),),
            ),
          ),
        ),
              SizedBox(height: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 353,
                    height: 100,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.blueGrey, width: 0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(5, 10, 5, 5),
                        child: ListTile(
                          title: Text(
                            "Predicted Event: ${memberData!['predicted_event']} \nPredicted GL: ${memberData!['predicted_gl']}",
                            style: GoogleFonts.lato(fontSize: 18),
                          ),
                          trailing: Icon(Icons.chevron_right, color: Colors.black, size: 35),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 353,
                height: 60,
                child: Card(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.blueGrey, width: 0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text("Suggested Dose: $suggestedDose units",
                        style: GoogleFonts.lato(fontSize: 18)),
                    trailing: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/insulin');
                      },
                      child: Icon(Icons.chevron_right, color: Colors.black, size: 35),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 357,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFE85454),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.local_hospital, color: Colors.white),
                      SizedBox(width: 10),
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
            ],
          ],
        ),
      ),
    ),

      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.fastfood), label: "Carbs"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CarbsPage()),
            );
          }
           if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePageGuardian()),
            );
          }
        },
      ),
    );
  }

LineChartData mainChartData() {
  List<FlSpot> glucoseSpots = [
    FlSpot(6, 110), // 6 AM
    FlSpot(7, 140), // 7 AM
    FlSpot(8, 130), // 8 AM
    FlSpot(9, 150), // 9 AM
    FlSpot(10, 125), // 10 AM
    FlSpot(11, 160), // 11 AM
  ];

  return LineChartData(
    gridData: FlGridData(show: false),
    titlesData: FlTitlesData(
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: 20, // Space glucose levels
          reservedSize: 40, // Avoid overlapping Y-axis labels
          getTitlesWidget: (value, meta) {
            return Padding(
              padding: EdgeInsets.only(right: 5), // Adjust padding
              child: Text(
                "${value.toInt()}",
                style: TextStyle(fontSize: 10),
                textAlign: TextAlign.right,
              ),
            );
          },
        ),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: 1, // Show every hour
          reservedSize: 20, // Avoid overlap with Y-axis
          getTitlesWidget: (value, meta) {
            return Padding(
              padding: EdgeInsets.only(top: 5), // Shift labels down
              child: Text(
                "${value.toInt()} AM",
                style: TextStyle(fontSize: 10),
                textAlign: TextAlign.center,
              ),
            );
          },
        ),
      ),
      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)), // Remove top
      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)), // Remove right
    ),
    borderData: FlBorderData(
      show: true,
      border: Border(
        left: BorderSide(color: Colors.black54),
        bottom: BorderSide(color: Colors.black54),
      ), // Keep only left and bottom borders
    ),
    minX: 6, // Start at 6 AM
    maxX: 11, // End at 11 AM
    minY: 70,
    maxY: 180,
    lineBarsData: [
      LineChartBarData(
        spots: glucoseSpots,
        isCurved: true,
        color: Colors.black,
        barWidth: 3,

      ),
    ],
  );
}
}