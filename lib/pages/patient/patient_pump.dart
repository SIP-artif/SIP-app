import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/pages/patient/patient_carb_tracker.dart';
import 'package:myapp/pages/patient/patient_home.dart';
import 'package:myapp/pages/patient/patient_profile.dart';
import 'package:myapp/services/shared_prefs_service.dart';

class InsulinPumpPage extends StatefulWidget {
  @override
  _InsulinPumpPageState createState() => _InsulinPumpPageState();
}

class _InsulinPumpPageState extends State<InsulinPumpPage> {
  bool _alertsEnabled = true;   
  bool _autoReconnect = false;  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.chevron_left_rounded),
          iconSize: 34.0,
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'My Insulin Pump',
          style: GoogleFonts.lato(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 4),
              Center(
                child: Text(
                  "Connected",
                  style: GoogleFonts.lato(
                    fontSize: 20,
                    color: Color(0xFF47C559),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20),
              _buildInfoCard(),
              SizedBox(height: 20),
              _buildSettingsCard(),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Add your reconnect pump logic here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2C7BBC),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Text(
                    "Reconnect Pump",
                    style: GoogleFonts.lato(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
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

  Widget _buildInfoCard() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Battery Level", style: GoogleFonts.lato(fontWeight: FontWeight.bold, fontSize: 18)),
          SizedBox(height: 4),
          LinearProgressIndicator(
            value: 0.8,
            color: Color(0xFF47C559),
            backgroundColor: Colors.grey[300],
          ),
          SizedBox(height: 8),
          Text("80%", style: GoogleFonts.lato(fontSize: 16)),
          SizedBox(height: 16),
          Text("Insulin Level", style: GoogleFonts.lato(fontWeight: FontWeight.bold, fontSize: 18)),
          SizedBox(height: 4),
          LinearProgressIndicator(
            value: 0.6,
            color: Color(0xFF2C7BBC),
            backgroundColor: Colors.grey[300],
          ),
          SizedBox(height: 8),
          Text("120 units", style: GoogleFonts.lato(fontSize: 16)),
          SizedBox(height: 16),
          Text("Battery Change in: 10 days", style: GoogleFonts.lato(color: Colors.grey[700])),
          Text("Insulin Refill in: 5 days", style: GoogleFonts.lato(color: Colors.grey[700])),
        ],
      ),
    );
  }

  Widget _buildSettingsCard() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Pump Settings", style: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 12),
          SwitchListTile(
            title: Text("Enable Alerts Notifications", style: GoogleFonts.lato(fontSize: 16)),
            value: _alertsEnabled,
            onChanged: (bool value) {
              setState(() {
                _alertsEnabled = value;
              });
            },
          ),
          SwitchListTile(
            title: Text("Auto Reconnect", style: GoogleFonts.lato(fontSize: 16)),
            value: _autoReconnect,
            onChanged: (bool value) {
              setState(() {
                _autoReconnect = value;
              });
            },
          ),
        ],
      ),
    );
  }
}

