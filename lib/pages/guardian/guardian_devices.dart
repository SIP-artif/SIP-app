import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/pages/guardian/guardian_carb_tracker.dart';
import 'package:myapp/pages/guardian/guardian_home.dart';
import 'package:myapp/pages/guardian/guardian_profile.dart';
import 'package:myapp/pages/guardian/guardian_pump.dart';

class MyDevicesPage extends StatelessWidget {
  const MyDevicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: Text(
          'My Devices',
          style: GoogleFonts.lato(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            DeviceCard(
              deviceName: 'Insulin Pump',
              status: 'Connected',
              statusColor: Color(0xFF47C559),
              battery: '60%',
              insulin: '120 units',
              buttonLabel: 'Manage',
            ),
            const SizedBox(height: 16),
            DeviceCard(
              deviceName: 'Smart Watch',
              status: 'Disconnected',
              statusColor: Colors.red,
              battery: '40%',
              buttonLabel: 'Reconnect',
            ),
          ],
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

class DeviceCard extends StatelessWidget {
  final String deviceName;
  final String status;
  final Color statusColor;
  final String battery;
  final String? insulin;
  final String buttonLabel;

  const DeviceCard({
    super.key,
    required this.deviceName,
    required this.status,
    required this.statusColor,
    required this.battery,
    this.insulin,
    required this.buttonLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(10),
  boxShadow: [
    BoxShadow(
      color: Colors.grey.withOpacity(0.1),
      blurRadius: 10,
      offset: const Offset(0, 5),
    )
  ],
  border: Border.all(
    color: Colors.grey, 
    width: 1.0,         
  ),
),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                deviceName,
                style: GoogleFonts.lato(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  Icon(Icons.circle, color: statusColor, size: 14),
                  const SizedBox(width: 5),
                  Text(
                    status,
                    style: GoogleFonts.lato(color: statusColor, fontSize: 16),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.battery_full, size: 20, color: Colors.black54),
              const SizedBox(width: 6),
              Text(
                'Battery: $battery',
                style: GoogleFonts.lato(fontSize: 18),
              ),
            ],
          ),
          if (insulin != null) ...[
            const SizedBox(height:10),
            Row(
              children: [
                const Icon(Icons.warning, size: 20, color: Colors.black54),
                const SizedBox(width: 6),
                Text(
                  'Insulin: $insulin',
                  style: GoogleFonts.lato(fontSize: 18),
                ),
              ],
            ),
          ],
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFFE6EFF8),
                foregroundColor: const Color(0xFF2C7BBC),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8), 
    ),
              ),
              onPressed: () {
                Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => InsulinPumpPage()),
            );
              },
              child: Text(
                buttonLabel,
                style: GoogleFonts.lato(fontWeight: FontWeight.bold, fontSize:16),
              ),
            ),
          )
        ],
      ),
    );
  }
}
