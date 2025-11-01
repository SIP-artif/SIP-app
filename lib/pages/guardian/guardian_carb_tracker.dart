import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/pages/guardian/guardian_home.dart';
import 'package:myapp/pages/guardian/guardian_profile.dart';
import 'package:myapp/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CarbTrackingPage extends StatefulWidget {
  @override
  _CarbTrackingPageState createState() => _CarbTrackingPageState();
}

class _CarbTrackingPageState extends State<CarbTrackingPage> {
  final TextEditingController _carbController = TextEditingController();
  Map<String, int> carbHistory = {};
  String? selectedUserId;
  List<Map<String, dynamic>> familyMembers = [];
  String? guardianId;

  @override
  void initState() {
    super.initState();
    initializeGuardian();
  }

  Future<void> initializeGuardian() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    guardianId = prefs.getString('userId');
    if (guardianId != null) {
      familyMembers = await UserService.fetchFamilyMembers(guardianId!);
      if (familyMembers.isNotEmpty) {
        selectedUserId = familyMembers.first['user_id'];
        await loadCarbsData();
      }
      setState(() {});
    }
  }

  Future<void> loadCarbsData() async {
    if (selectedUserId == null) return;
    carbHistory = await UserService().fetchCarbsLast10Days(selectedUserId!);
    setState(() {});
  }

  Future<void> addCarbs() async {
    if (selectedUserId == null) return;
    final text = _carbController.text.trim();
    if (text.isEmpty) return;
    final int carbs = int.tryParse(text) ?? 0;
    await UserService().addCarbEntry(selectedUserId!, carbs);
    _carbController.clear();
    await loadCarbsData();
  }

  @override
  void dispose() {
    _carbController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> sortedDates = carbHistory.keys.toList()..sort((a, b) => b.compareTo(a));

    return Scaffold(
      backgroundColor: Color(0xFFF4F7FC),
      appBar: AppBar(
        backgroundColor: Color(0xFFF4F7FC),
        elevation: 0,
        title: Text(
          'Carbohydrates Tracker',
          style: GoogleFonts.lato(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            if (familyMembers.isNotEmpty)
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFF4F7FC),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedUserId,
                    isExpanded: true,
                    dropdownColor: Color(0xFFF4F7FC),
                    items: familyMembers
                        .map((member) => DropdownMenuItem<String>(
                              value: member['id'],
                              child: Text(member['name'],
                                  style: GoogleFonts.lato(fontSize: 18)),
                            ))
                        .toList(),
                    onChanged: (value) async {
                      setState(() {
                        selectedUserId = value;
                      });
                      await loadCarbsData();
                    },
                  ),
                ),
              ),
            SizedBox(height: 20),
            TextField(
              controller: _carbController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter carbs (grams)',
                labelStyle: GoogleFonts.lato(color: Colors.black,fontWeight: FontWeight.w500),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF297CC0), width: 2.0),
                ),
              ),
              cursorColor: Color(0xFF297CC0),
              style: GoogleFonts.lato(fontSize: 16),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF297CC0),
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: addCarbs,
                child: Text('Add', style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: carbHistory.isEmpty
                  ? Center(
                      child: Text(
                        'No Data Available',
                        style: GoogleFonts.lato(fontSize: 18),
                      ),
                    )
                  : ListView.builder(
                      itemCount: sortedDates.length,
                      itemBuilder: (context, index) {
                        final date = sortedDates[index];
                        final carbs = carbHistory[date];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(date, style: GoogleFonts.lato(fontSize: 18)),
                              Text('${carbs}g', style: GoogleFonts.lato(fontSize: 18)),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
  currentIndex: 1,
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
