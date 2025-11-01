import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/pages/patient/patient_carb_tracker.dart';
import 'package:myapp/pages/patient/patient_home.dart';
import 'package:myapp/pages/patient/patient_profile.dart';
import 'package:myapp/services/shared_prefs_service.dart';
import 'package:myapp/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PredictedEventsPage extends StatefulWidget {
  const PredictedEventsPage({super.key});

  @override
  State<PredictedEventsPage> createState() => _PredictedEventsPageState();
}

class _PredictedEventsPageState extends State<PredictedEventsPage> {
  Future<List<PredictedEvent>>? _predictedEventsFuture;
  final UserService _userService = UserService();


  @override
  void initState() {
    super.initState();
    _predictedEventsFuture = _initializeFuture();
  }

  Future<List<PredictedEvent>> _initializeFuture() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    if (userId != null) {
      return await _userService.fetchPredictedEvents(userId);
    } else {
      return []; // fallback to avoid null
    }
  }



  Color getRiskColor(String eventType) {
    if (eventType.contains('Hypo')) {
      return const Color(0xFFF6CE30); // Yellow for low
    } else if (eventType.contains('Hyper')) {
      return const Color(0xFFE85454); // Red for high
    } else {
      return const Color(0xFF6C757D); // Gray fallback
    }
  }

  String getRiskLabel(String eventType) {
    if (eventType.contains('Hypo')) {
      return 'Low';
    } else if (eventType.contains('Hyper')) {
      return 'High';
    } else {
      return 'Normal';
    }
  }

  String formatTime(DateTime time) {
  final hour = time.hour > 12 ? time.hour - 12 : time.hour; // Ensure hour is an integer
  final minute = time.minute.toString().padLeft(2, '0'); // Padding to maintain format
  final period = time.hour >= 12 ? 'PM' : 'AM';
  return '$hour:$minute $period';
}


@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xFFF4F7FC),
    appBar: AppBar(
      title: Text('Predicted Events', style: GoogleFonts.lato(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold)),
      backgroundColor: Colors.white,
      elevation: 1,
    ),
    body: FutureBuilder<List<PredictedEvent>>(
      future: _predictedEventsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No predicted events found'));
        }

        final events = snapshot.data!;

        // Filter out the "Normal" events
        final filteredEvents = events.where((event) => getRiskLabel(event.eventType) != 'Normal').toList();

        if (filteredEvents.isEmpty) {
          return const Center(child: Text('No significant events to display'));
        }

        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Text(
                'Upcoming Events:',
                style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredEvents.length,
                  itemBuilder: (context, index) {
                    final event = filteredEvents[index];
                    final riskColor = getRiskColor(event.eventType);
                    final riskLabel = getRiskLabel(event.eventType);

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: Color(0xFFABABAB), width: 1),
                      ),
                      child: ListTile(
                        leading: Icon(Icons.access_time, color: riskColor),
                        title: Text(
                          '${formatTime(event.predictedTime)} — ${event.predictedGlucose.toStringAsFixed(1)} mg/dL',
                          style: GoogleFonts.lato(fontSize: 17, fontWeight: FontWeight.w700),
                        ),
                        subtitle: Text(
                          event.eventType,
                          style: GoogleFonts.lato(fontSize: 14),
                        ),
                        trailing: Chip(
                          label: Text(
                            riskLabel,
                            style: GoogleFonts.lato(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          backgroundColor: riskColor,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
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
}
