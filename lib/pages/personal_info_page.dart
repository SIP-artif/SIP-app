import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class PersonalInfoPage extends StatelessWidget {
  final String userId = 'CUqTKrYC5xzpdtBZI0S0';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4F7FC), 
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.chevron_left_rounded),
          iconSize: 34.0, 
          onPressed: () {
            Navigator.pop(context); 
          },
        ),

        title: Text(
          'Personal information',
          style: GoogleFonts.lato(fontSize: 22,fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.black),
            onPressed: () {
              // Navigate to edit screen
            },
          ),
        ],
      ),


      body: StreamBuilder<DocumentSnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('Users')
                .doc(userId)
                .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          return ListView(
            padding: EdgeInsets.symmetric(horizontal: 20),
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
                  side: BorderSide(
                    color: Color(0xFFABABAB), 
                    width: 1, 
                  ),
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

                      Divider(
                        color: Color(0xFFABABAB),
                        height: 0,  
                      ),

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
                                    data['age'] != null ? data['age'].toString() : '',
                                    style: GoogleFonts.lato(
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        
                                VerticalDivider(
                                  thickness: 1.5, 
                                  color: Color(0xFFABABAB), 
                                ),
                        
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Gender:   ",
                                  style: GoogleFonts.lato(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      )),
                                  Text(data['gender'],
                                  style: GoogleFonts.lato(
                                      fontSize: 18
                                      )),
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
                  side: BorderSide(
                    color: Color(0xFFABABAB), 
                    width: 1, 
                  ),
                ),
                child: Column(
                  children: [
                    InfoRow(
                      icon: Icons.phone_iphone,
                      label: "Phone Number: ",
                      value: data['phone_number'].toString(),
                    ),
                    Divider(),
                    InfoRow(
                      icon: Icons.phone_outlined,
                      label: "Emergency Phone Number:",
                      value: data['emergency_phone'].toString(),
                    ),
                    Divider(),
                    InfoRow(
                      icon: Icons.medical_services,
                      label: "Pump ID:",
                      value: data['pump_id'],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.fastfood), label: "Carbs"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
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
      leading: Icon(
        icon,
        size: 28,
        color: Color(0xFF297CC0),
      ),
      title: Text(
        label,
        style: GoogleFonts.lato(
          fontSize: 18,
          fontWeight: FontWeight.w600),),
      subtitle: Text(
        value ?? '',
        style: GoogleFonts.lato(
          fontSize: 16,
          fontWeight: FontWeight.w500),
      ),
    );
  }
}
