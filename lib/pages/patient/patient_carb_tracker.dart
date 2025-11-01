import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/pages/patient/patient_home.dart';
import 'package:myapp/pages/patient/patient_profile.dart';
import 'package:myapp/services/user_service.dart'; 
import 'package:myapp/services/shared_prefs_service.dart';

class CarbsPagePatient extends StatefulWidget {
  @override
  _CarbsPagePatientState createState() => _CarbsPagePatientState();
}

class _CarbsPagePatientState extends State<CarbsPagePatient> {
  TextEditingController _carbController = TextEditingController();
  bool isLoading = true;
  Map<String, int> carbHistory = {}; // To store carbs for the last 10 days

  final UserService _userService = UserService(); // Your UserService instance

  @override
  void initState() {
    super.initState();
    loadCarbsData(); // Load carbs data on page load
  }

  // Fetch the carb data for the last 10 days
  Future<void> loadCarbsData() async {
    String? uid = await getUserIdFromPrefs();
    if (uid != null) {
      Map<String, int> fetchedData = await _userService.fetchCarbsLast10Days(uid);
      print("Fetched data: $fetchedData");

      // Get the last 10 days starting from today
      DateTime today = DateTime.now();
      List<String> last10Days = [];
      for (int i = 0; i < 10; i++) {
        DateTime day = today.subtract(Duration(days: i));
        String dayString = '${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';
        last10Days.add(dayString);
      }

      // Ensure all 10 days are in the result, even if no carbs data for a day
      Map<String, int> finalCarbHistory = {};
      for (var day in last10Days) {
        finalCarbHistory[day] = fetchedData[day] ?? 0; // Use 0 if no data for that day
      }

      setState(() {
        carbHistory = finalCarbHistory;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      appBar: AppBar(
        title: Text(
          'Carbohydrates Tracker',
          style: GoogleFonts.lato(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex:1,
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _carbController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Enter carbs (grams)',
                        hintStyle: GoogleFonts.lato(), // Hint text style
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      style: GoogleFonts.lato(fontSize: 16), // Input text style
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      int current = int.tryParse(_carbController.text) ?? 0;
                      _carbController.text = (current + 1).toString();
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(10),
                    ),
                    child: const Text('+'),
                  ),
                  const SizedBox(width: 5),
                  ElevatedButton(
                    onPressed: () {
                      int current = int.tryParse(_carbController.text) ?? 0;
                      if (current > 0) {
                        _carbController.text = (current - 1).toString();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(10),
                    ),
                    child: const Text('-'),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
  int amount = int.tryParse(_carbController.text) ?? 0;
  if (amount > 0) {
    String? uid = await getUserIdFromPrefs();
    if (uid != null) {
      await _userService.addCarbEntry(uid, amount);
      _carbController.clear();

      String todayString = '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}';
      setState(() {
        carbHistory[todayString] = (carbHistory[todayString] ?? 0) + amount;
      });

      // Delay refresh to avoid UI flicker
      Future.delayed(const Duration(seconds: 2), () {
        loadCarbsData();
      });
    }
  }
},

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    'Add Entry',
                    style: GoogleFonts.lato(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'History (Last 10 Days)',
                style: GoogleFonts.lato(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blue.shade50,
                  ),
                  child: isLoading
                      ? Center(child: CircularProgressIndicator())
                      : carbHistory.isEmpty
                          ? Center(
                              child: Text(
                                "No available data",
                                style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            )
                          : ListView.builder(
                              itemCount: carbHistory.length,
                              itemBuilder: (context, index) {
                                // Sort the dates from most recent to least recent
                                List<String> sortedDates = carbHistory.keys.toList()
                                  ..sort((a, b) => b.compareTo(a)); 

                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        sortedDates[index],
                                        style: GoogleFonts.lato(fontSize: 16),
                                      ),
                                      Text(
                                        '${carbHistory[sortedDates[index]]}g',
                                        style: GoogleFonts.lato(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
