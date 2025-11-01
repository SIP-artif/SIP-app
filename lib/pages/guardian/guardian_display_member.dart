import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/pages/guardian/guardian_carb_tracker.dart';
import 'package:myapp/pages/guardian/guardian_home.dart';
import 'package:myapp/pages/guardian/guardian_profile.dart';
import 'package:myapp/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';


class FamilyMembersPage extends StatefulWidget {
  const FamilyMembersPage({super.key});

  @override
  _FamilyMembersPageState createState() => _FamilyMembersPageState();
}

class _FamilyMembersPageState extends State<FamilyMembersPage> {
  String? guardianId;

  @override
  void initState() {
    super.initState();
    _loadGuardianId();
  }

  // Load guardianId from SharedPreferences
  Future<void> _loadGuardianId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      guardianId = prefs.getString('userId');
    });
  }

  @override
  Widget build(BuildContext context) {
    if (guardianId == null) {
      return const Center(child: CircularProgressIndicator()); 
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF6FAFF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 80,
        title: Text(
          'My Family Members',
          style: GoogleFonts.lato( 
            fontSize: 24,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: UserService.fetchFamilyMembersWithRelationship(guardianId!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Center(child: Text('Error loading family members.'));
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No family members found.'));
            }

            final members = snapshot.data!;

            return ListView.builder(
              itemCount: members.length,
              itemBuilder: (context, index) {
                final member = members[index];
                return Card(
                  color: const Color(0xFFEAF3FB),
                  elevation: 4,
                  margin: const EdgeInsets.all(20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Column(
                      children: [
                        const Icon(Icons.account_circle, size: 80),
                        const SizedBox(height: 8),
                        Text(
                          member['name'],
                          style: GoogleFonts.lato( 
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        RichText(
                          text: TextSpan(
                            text: 'Relationship: ',
                            style: GoogleFonts.lato( 
                              color: Colors.black,
                              fontSize: 18,
                            ),
                            children: [
                              TextSpan(
                                text: member['relationship'],
                                style: GoogleFonts.lato( // Use GoogleFonts.lato for text style
                                  color: Colors.blueGrey,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
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

