import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'dart:typed_data';

class BluetoothInjectPage extends StatefulWidget {
  @override
  _BluetoothInjectPageState createState() => _BluetoothInjectPageState();
}

class _BluetoothInjectPageState extends State<BluetoothInjectPage> {
  BluetoothConnection? connection;
  bool isConnected = false;
  bool isConnecting = false;
  String statusMessage = "Not connected";

  void connectToESP32() async {
    setState(() {
      isConnecting = true;
      statusMessage = "Connecting...";
    });

    try {
      List<BluetoothDevice> devices =
          await FlutterBluetoothSerial.instance.getBondedDevices();

      BluetoothDevice? esp32 = devices.firstWhere(
        (d) => d.name == "ESP32_BT_Device",
        orElse: () => throw Exception("ESP32 not paired"),
      );

      connection = await BluetoothConnection.toAddress(esp32.address);
      setState(() {
        isConnected = true;
        isConnecting = false;
        statusMessage = "Connected to ESP32";
      });
    } catch (e) {
      setState(() {
        isConnected = false;
        isConnecting = false;
        statusMessage = "Connection failed: $e";
      });
    }
  }

  void sendCommand(String command) {
    if (connection != null && connection!.isConnected) {
      connection!.output.add(Uint8List.fromList(command.codeUnits));
      connection!.output.allSent;
      print("Sent: $command");
    }
  }

  @override
  void dispose() {
    connection?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Inject Insulin")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(statusMessage, style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isConnecting ? null : connectToESP32,
              child: Text("Connect to ESP32"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isConnected ? () => sendCommand("1") : null,
              child: Text("Inject"),
            ),
          ],
        ),
      ),
    );
  }
}
