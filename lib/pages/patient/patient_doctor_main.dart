import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/pages/patient/patient_doctor_call.dart';
import 'package:myapp/pages/patient/patient_carb_tracker.dart';
import 'package:myapp/pages/patient/patient_home.dart';
import 'package:myapp/pages/patient/patient_profile.dart';
import 'package:myapp/services/shared_prefs_service.dart';

class MyDoctorPagePatient extends StatefulWidget {
  const MyDoctorPagePatient({Key? key}) : super(key: key);

  @override
  State<MyDoctorPagePatient> createState() => _MyDoctorPageState();
}

class _MyDoctorPageState extends State<MyDoctorPagePatient> {
  String selectedButton = 'Chat'; 

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFFF4F7FC);
    const cardColor = Color(0xFFFBFCFF);
    const selectedColor = Color(0xFF297CC0);
    const borderColor = Color(0xFFCDD5DF);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        leading: const BackButton(color: Colors.black),
        title: Text(
          'My Doctor',
          style: GoogleFonts.lato(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/images/doctor_profile.png'),
            ),

            const SizedBox(height: 16),

            Card(
              elevation: 2,
              color: cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: borderColor),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 80.0),
                child: Column(
                  children: [
                    Text(
                      'Dr.Salwa Abdaluziz',
                      style: GoogleFonts.lato(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      'Family Medicine',
                      style: GoogleFonts.lato(fontSize: 16,color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSelectableButton(
                  label: 'Call',
                  icon: Icons.call,
                  isSelected: selectedButton == 'Call',
                  onTap: () {
                    setState(() => selectedButton = 'Call');
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => CallPage()),)
                      .then((_) {
                        setState(() => selectedButton = 'Chat');});
                  },
                ),
                _buildSelectableButton(
                  label: 'Chat',
                  icon: Icons.chat_bubble_outline,
                  isSelected: selectedButton == 'Chat',
                  onTap: () {
                    setState(() => selectedButton = 'Chat');
                    Navigator.push(context, MaterialPageRoute(builder: (_) => MyDoctorPagePatient()));
                  },
                ),
                _buildSelectableButton(
                  label: 'Chat History',
                  icon: Icons.history,
                  isSelected: selectedButton == 'Chat History',
                  onTap: () {
                    setState(() => selectedButton = 'Chat History');
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => MyDoctorPagePatient()), // Replace with actual ChatHistoryPage if needed
                      ).then((_) { setState(() => selectedButton = 'Chat');});
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),

            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: borderColor),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12), // optional spacing before input row
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(color: Color(0xFFCDD5DF)),
                          borderRadius: BorderRadius.circular(0),
                        ),

                        alignment: Alignment.center,
                        
                        child: Text(
                          "No messages yet.",
                          style: GoogleFonts.lato(color: Colors.grey),
                        ),
                      ),
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 40,
                            child: TextField(
                            style: GoogleFonts.lato(),
                            decoration: InputDecoration(
                              hintText: "Type a message...",
                              hintStyle: GoogleFonts.lato(color: Colors.grey, fontSize: 14,),
                              filled: true,
                              fillColor: Colors.transparent,
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: borderColor),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: borderColor),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),

                        SizedBox(
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),  
                              ),
                              backgroundColor: selectedColor,
                              foregroundColor: Colors.white,
                            ),
                            child: Text("Send", style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold,)),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
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

  Widget _buildSelectableButton({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    const selectedColor = Color(0xFF297CC0);
    const borderColor = Color(0xFFCDD5DF);

    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(
        icon,
        color: isSelected ? Colors.white : Colors.black,
      ),
      label: Text(
        label,
        style: GoogleFonts.lato(color: isSelected ? Colors.white : Colors.black, fontSize: 18, fontWeight: FontWeight.bold,),
      ),
      style: OutlinedButton.styleFrom(
        backgroundColor: isSelected ? selectedColor : Colors.white,
        side: const BorderSide(color: borderColor),
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),  
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }
}
