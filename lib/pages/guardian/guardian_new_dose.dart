import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/pages/guardian/guardian_carb_tracker.dart';
import 'package:myapp/pages/guardian/guardian_home.dart';
import 'package:myapp/pages/guardian/guardian_profile.dart';
import 'package:myapp/services/user_service.dart';

class NewDosePage extends StatefulWidget {
  final String userId;
  const NewDosePage({required this.userId, Key? key}) : super(key: key);

  @override
  _NewDosePageState createState() => _NewDosePageState();
}

class _NewDosePageState extends State<NewDosePage> {
  double newDose = 0.0;
  BluetoothCharacteristic? targetCharacteristic;
  BluetoothDevice? connectedDevice;

  @override
  void initState() {
    super.initState();
    connectToBluetooth();
  }

  Future<void> connectToBluetooth() async {
    FlutterBluePlus.startScan(timeout: Duration(seconds: 4));

    FlutterBluePlus.scanResults.listen((results) async {
      for (ScanResult r in results) {
        if (r.device.name == "HUAWEI MatePad") { // 🔁 Replace this with your actual Bluetooth name
          await FlutterBluePlus.stopScan();
          await r.device.connect();
          connectedDevice = r.device;

          List<BluetoothService> services = await r.device.discoverServices();
          for (BluetoothService service in services) {
            for (BluetoothCharacteristic c in service.characteristics) {
              if (c.properties.write) {
                targetCharacteristic = c;
                break;
              }
            }
          }
        }
      }
    });
  }

  Future<void> sendDoseMessage() async {
  if (targetCharacteristic != null) {
    // Send "1" to turn the light on
    await targetCharacteristic!.write([49]); // ASCII for '1'
    print("Sent '1' to turn on the light");

    // Wait for 3 seconds (adjust if needed)
    await Future.delayed(Duration(seconds:10));

    // Send "0" to turn the light off
    await targetCharacteristic!.write([48]); // ASCII for '0'
    print("Sent '0' to turn off the light");
  } else {
    print("No target characteristic available");
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create New Dose', style: GoogleFonts.lato(fontSize: 24, fontWeight: FontWeight.bold))),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Enter the Dose:', style: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.w500)),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(border: OutlineInputBorder()),
              onChanged: (value) {
                setState(() {
                  newDose = double.tryParse(value) ?? 0.0;
                });
              },
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFE85454),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: EdgeInsets.symmetric(horizontal: 26, vertical: 12),
            ),
            onPressed: () async {
  await UserService.saveNewInjectedDose(widget.userId, newDose);
  await sendDoseMessage();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Success!', style: GoogleFonts.lato(fontWeight: FontWeight.bold)),
        content: Text(
          'New insulin dose of ${newDose.toStringAsFixed(1)} units injected successfully.',
          style: GoogleFonts.lato(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pop(context);
            },
            child: Text('OK', style: GoogleFonts.lato(fontWeight: FontWeight.bold)),
          ),
        ],
      );
    },
  );
},

            child: Text('Confirm New Dose', style: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
  currentIndex: 0,
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
