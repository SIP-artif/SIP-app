import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/pages/patient/patient_modify_dose.dart';
import 'package:myapp/pages/patient/patient_carb_tracker.dart';
import 'package:myapp/pages/menu.dart';
import 'package:myapp/pages/patient/patient_predicted_events.dart';
import 'package:myapp/pages/patient/patient_profile.dart';
import 'package:myapp/services/data_generator.dart';
import 'package:myapp/services/shared_prefs_service.dart';
import 'package:myapp/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserHomePage extends StatefulWidget {
  final String userId;

  const UserHomePage({super.key, required this.userId});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  final UserService _userService = UserService();

  List<FlSpot> glucoseSpots = [];
  Map<String, dynamic> userData = {};
  double? suggestedDose;
  bool hasData = false;
  bool _hasStartedGenerator = false;

  @override
  void initState() {
    super.initState();
    fetchUserData();
    _startFakeDataGeneratorOnce();
  }
  Future<void> _startFakeDataGeneratorOnce() async {
    if (_hasStartedGenerator) return;

    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('userId');

    if (uid != null && uid.isNotEmpty) {
      FakeDataGenerator(uid: uid).startGenerating();
      _hasStartedGenerator = true;
    } else {
      print('No UID found in SharedPreferences.');
    }
  }

  Future<void> fetchUserData() async {
    final data = await _userService.fetchUserGlucoseData(widget.userId);
    List<FlSpot> rawSpots = List<FlSpot>.from(data['glucoseSpots']);

    Map<int, List<double>> hourlyGlucose = {};

    final now = DateTime.now();
    final nowHour = now.hour;
    final minHour = nowHour - 5;

    for (var spot in rawSpots) {
      int hour = spot.x.toInt();
      if (hour >= minHour && hour <= nowHour) {
        hourlyGlucose.putIfAbsent(hour, () => []);
        hourlyGlucose[hour]!.add(spot.y);
      }
    }

    List<FlSpot> averagedSpots = [];
    for (int hour = minHour; hour <= nowHour; hour++) {
      if (hourlyGlucose.containsKey(hour)) {
        double mean = hourlyGlucose[hour]!.reduce((a, b) => a + b) / hourlyGlucose[hour]!.length;
        averagedSpots.add(FlSpot(hour.toDouble(), mean));
      }
    }

    setState(() {
      glucoseSpots = averagedSpots;
      hasData = glucoseSpots.isNotEmpty;
      userData = {
        'predicted_gl': data['predicted_gl'],
        'predicted_event': data['predicted_event'],
      };
      suggestedDose = (data['additional_doses'] as num?)?.toDouble();
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
              "Welcome!",
              style: GoogleFonts.lato(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Menu(),
          ],
        ),
      ),
      backgroundColor: const Color(0xFFF4F7FC),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 30),
              if (hasData)
                Container(
                  margin: const EdgeInsets.all(20),
                  child: Card(
                    color: const Color(0xFFE3EBF5),
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
                )
              else
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    "No data available",
                    style: GoogleFonts.lato(fontSize: 18, color: Colors.black54),
                  ),
                ),
              const SizedBox(height: 20),
              if (hasData) ...[
                SizedBox(
                  width: 360,
                  height: 90,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PredictedEventsPage()),
                      );
                    },
                    child: Card(
                      color: const Color(0xFFE3EBF5),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.blueGrey, width: 0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                        child: ListTile(
                          title: Text(
                            "Predicted Event: ${userData['predicted_event']} \nPredicted GL: ${userData['predicted_gl']}",
                            style: GoogleFonts.lato(fontSize: 16),
                          ),
                          trailing: const Icon(Icons.chevron_right, size: 30),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 360,
                  height: 60,
                  child: Card(
                    color: const Color(0xFFE3EBF5),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.blueGrey, width: 0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: Text(
                        "Suggested Dose: $suggestedDose units",
                        style: GoogleFonts.lato(fontSize: 16),
                      ),
                      trailing: IconButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => ModifyDosePage(suggestedDose: suggestedDose ?? 0.0)),
                        ),
                        icon: const Icon(Icons.chevron_right, size: 30),
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 20),
              SizedBox(
                width: 357,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
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
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
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

  LineChartData mainChartData() {
    final nowHour = DateTime.now().hour;
    final minHour = nowHour - 5;

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
      minX: minHour.toDouble(),
      maxX: nowHour.toDouble(),
      minY: 0,
      maxY: 180,
      lineBarsData: [
        LineChartBarData(
          spots: glucoseSpots,
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
}