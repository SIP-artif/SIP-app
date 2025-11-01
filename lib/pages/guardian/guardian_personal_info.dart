import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/pages/guardian/guardian_carb_tracker.dart';
import 'package:myapp/pages/guardian/guardian_home.dart';
import 'package:myapp/pages/guardian/guardian_profile.dart';
import 'package:myapp/services/shared_prefs_service.dart';
import 'package:myapp/services/user_service.dart';

class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({super.key});

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  Map<String, dynamic>? guardianData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadDataFromPrefs();
  }

  Future<void> loadDataFromPrefs() async {
    final uid = await getUserIdFromPrefs();
    if (uid == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    final userData = await UserService().getGuardianData(uid);
    if (mounted) {
      setState(() {
        guardianData = userData;
        isLoading = false;
      });
    }
  }

  Widget _buildInfoCard(IconData icon, String title, String value) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Color(0xFFCDD5DF)),
      ),
      color: Colors.white,
      child: ListTile(
        leading: Icon(icon, color: Colors.blueGrey),
        title: Text(
          title,
          style: GoogleFonts.lato(fontSize: 16, color: Colors.grey[700]),
        ),
        subtitle: Text(
          value,
          style: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      appBar: AppBar(
        title: Text(
          'Personal Information',
          style: GoogleFonts.lato(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : guardianData == null
                ? Text(
                    'No user data found.',
                    style: GoogleFonts.lato(fontSize: 18),
                  )
                : Card(
                    color: const Color(0xFFFBFCFF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(color: Color(0xFFCDD5DF)),
                    ),
                    margin: const EdgeInsets.all(20),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Guardian Information',
                            style: GoogleFonts.lato(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildInfoCard(Icons.person, 'Name:', guardianData!['name'] ?? 'N/A'),
                          const SizedBox(height: 12),
                          _buildInfoCard(Icons.email, 'Email:', guardianData!['email'] ?? 'N/A'),
                          const SizedBox(height: 12),
                          _buildInfoCard(Icons.phone, 'Phone Number:', guardianData!['phone'] ?? 'N/A'),
                        ],
                      ),
                    ),
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
}

