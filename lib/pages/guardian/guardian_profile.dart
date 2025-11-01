import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/pages/guardian/guardian_doctor_main.dart';
import 'package:myapp/pages/guardian/guardian_family.dart';
import 'package:myapp/pages/guardian/guardian_carb_tracker.dart';
import 'package:myapp/pages/guardian/guardian_home.dart';
import 'package:myapp/pages/guardian/guardian_history.dart';
import 'package:myapp/pages/guardian/guardian_devices.dart';
import 'package:myapp/pages/guardian/guardian_personal_info.dart';
import 'package:myapp/pages/guardian/guardian_tutorial.dart';
import 'package:myapp/services/user_service.dart';

class ProfilePageGuardian extends StatefulWidget {
  @override
  _ProfilePageGuardianState createState() => _ProfilePageGuardianState();
}

class _ProfilePageGuardianState extends State<ProfilePageGuardian> {
  final Color backgroundColor = const Color(0xFFF4F7FC);
  final Color blackColor = const Color(0xFF000000);

  String? selectedMemberId; // 👈 This will store the selected member ID
  String? selectedMemberName; // 👈 This will store the selected member's name

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: Text(
          selectedMemberName != null ? 'Profile of $selectedMemberName' : 'My Profile', // Display member's name if selected
          style: GoogleFonts.lato(color: blackColor, fontSize: 24, fontWeight: FontWeight.bold),
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => GuardianHomePage()),
              );
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CarbTrackingPage()),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ProfilePageGuardian()),
              );
              break;
          }
        },
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<List<Map<String, dynamic>>>( 
              future: UserService.fetchFamilyMembers(FirebaseAuth.instance.currentUser!.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('No family members found');
                }

                return _MemberDropdown(
                  members: snapshot.data!,
                  onMemberSelected: (id, name) {
                    setState(() {
                      selectedMemberId = id;
                      selectedMemberName = name; // Set the selected member's name
                    });
                  },
                );
              },
            ),
             SizedBox(height: 24),

      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: ListTile(
          leading: Icon(Icons.info_outline, color: blackColor),
          title: Text('Personal Information', style: GoogleFonts.lato(color: blackColor, fontSize: 18)),
          trailing: Icon(Icons.keyboard_arrow_down, color: blackColor),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PersonalInfoPage()),
            );
          },
        ),
      ),
      SizedBox(height: 24),
      Text(
        'Overview',
        style: GoogleFonts.lato(
          color: blackColor,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
            const SizedBox(height: 24),      
            _buildOverviewItem(Icons.groups, 'My Family', onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => MyFamilyPage()));
            }),
            _buildOverviewItem(Icons.devices, 'My Devices', onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => MyDevicesPage()));
            }),
            _buildOverviewItem(Icons.medical_services, 'My Doctor', onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => MyDoctorPageGuardian()));
            }),
            _buildOverviewItem(Icons.history, 'History', onTap: () {
              if (selectedMemberId != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => HistoryPageGuardian(userId: selectedMemberId!), // Passed here
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please select a family member first.')),
                );
              }
            }),
            _buildOverviewItem(Icons.play_circle_outline, 'Get Started', onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => TutorialPageGuardian()));
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewItem(IconData icon, String title, {VoidCallback? onTap}) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: blackColor),
        title: Text(title, style: GoogleFonts.lato(color: blackColor, fontSize: 18)),
        trailing: Icon(Icons.arrow_forward_ios, color: blackColor, size: 16),
        onTap: onTap,
      ),
    );
  }
}

class _MemberDropdown extends StatefulWidget {
  final List<Map<String, dynamic>> members;
  final void Function(String?, String?) onMemberSelected;

  const _MemberDropdown({required this.members, required this.onMemberSelected});
  
  @override
  State<_MemberDropdown> createState() => _MemberDropdownState();
}

class _MemberDropdownState extends State<_MemberDropdown> {
  String? selectedMemberId;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        primaryColor: Color(0xFF297CC0), // Sets border/focus color
        colorScheme: Theme.of(context).colorScheme.copyWith(
          primary: Color(0xFF297CC0), // Affects the focused border and label
        ),
      ),
      child: DropdownButtonFormField<String>(
        dropdownColor: const Color(0xFFF4F7FC),
        decoration: InputDecoration(
          labelText: 'Select Member',
          labelStyle: GoogleFonts.lato(color: Colors.black, fontSize: 18),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.black),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.black26),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        value: selectedMemberId,
        items: widget.members.map((member) {
          return DropdownMenuItem<String>(
            value: member['id'],
            child: Text(
              member['name'],
              style: GoogleFonts.lato(fontSize: 18, color: Colors.black),
            ),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedMemberId = value;
          });
          final selectedMember = widget.members.firstWhere((member) => member['id'] == value);
          widget.onMemberSelected(value, selectedMember['name']); // notify parent with id and name
        },
      ),
    );
  }
}

