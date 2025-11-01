import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/pages/patient/patient_carb_tracker.dart';
import 'package:myapp/pages/patient/patient_home.dart';
import 'package:myapp/pages/patient/patient_profile.dart';
import 'package:myapp/services/user_service.dart';
import 'package:myapp/services/shared_prefs_service.dart';

class PersonalInfoPage extends StatefulWidget {
  @override
  _PersonalInfoPageState createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> with SingleTickerProviderStateMixin {
  late Future<Map<String, dynamic>?> _userDataFuture;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _userDataFuture = _getUserData();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>?> _getUserData() async {
  final uid = await getUserIdFromPrefs();
  if (uid == null) return null;

  final userData = await UserService().getUserData(uid);
  if (userData == null) return null;

  // Calculate age from birthdate (saved as day/month/year)
  if (userData.containsKey('birthDate')) {
    try {
      List<String> parts = userData['birthDate'].split('/');
      int day = int.parse(parts[0]);
      int month = int.parse(parts[1]);
      int year = int.parse(parts[2]);
      DateTime birthDate = DateTime(year, month, day);

      int age = DateTime.now().year - birthDate.year;
      if (DateTime.now().month < birthDate.month ||
          (DateTime.now().month == birthDate.month &&
              DateTime.now().day < birthDate.day)) {
        age--;
      }
      userData['age'] = age;
    } catch (e) {
      print('Error parsing birthDate: $e');
    }
  }

  // Combine name if firstName and lastName exist
  if (userData.containsKey('firstName') && userData.containsKey('lastName')) {
    userData['name'] = '${userData['firstName']} ${userData['lastName']}';
  }
  return userData;
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4F7FC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.chevron_left_rounded),
          iconSize: 34.0,
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Personal information',
          style: GoogleFonts.lato(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.black),
            onPressed: () {
              // TODO: Navigate to edit screen
            },
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _userDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),);
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No user data found.'));
          }

          final data = snapshot.data!;
          _animationController.forward(); // Start the fade animation once data is loaded

          return FadeTransition(
            opacity: _fadeAnimation,
            child: ListView(
              padding: EdgeInsets.all(20),
              children: [
                SizedBox(height: 20),
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('assets/images/default_profile.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Card(
                  color: Color(0xFFFFFFFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Color(0xFFABABAB), width: 1),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: SizedBox(
                          child: Text(
                            data['name'] ?? '',
                            style: GoogleFonts.lato(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Divider(color: Color(0xFFABABAB), height: 0),
                      SizedBox(
                        height: 65,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Age:   ",
                                    style: GoogleFonts.lato(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    data['age'].toString(),
                                    style: GoogleFonts.lato(fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                            VerticalDivider(thickness: 1.5, color: Color(0xFFABABAB)),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("Gender:   ",
                                      style: GoogleFonts.lato(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600)),
                                  Text(data['gender'] ?? '',
                                      style: GoogleFonts.lato(fontSize: 18)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 25),
                Card(
                  color: Color(0xFFFFFFFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Color(0xFFABABAB), width: 1),
                  ),
                  child: Column(
                    children: [
                      InfoRow(
                        icon: Icons.email,
                        label: "Email:",
                        value: data['email'],
                      ),
                      Divider(),
                      InfoRow(
                        icon: Icons.phone_outlined,
                        label: "Emergency Phone Number:",
                        value: data['emergencyPhone'],
                      ),
                      Divider(),
                      InfoRow(
                        icon: Icons.medical_services,
                        label: "Pump ID:",
                        value: data['PumpID'],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32),
              ],
            ),
          );
        },
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
}

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;

  const InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, size: 28, color: Color(0xFF297CC0)),
      title: Text(label,
          style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.w600)),
      subtitle: Text(value ?? '',
          style: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.w500)),
    );
  }
}
