import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NewDosePage extends StatefulWidget {
  @override
  _NewDosePageState createState() => _NewDosePageState();
}

class _NewDosePageState extends State<NewDosePage> {
  double newDose = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create New Dose')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Enter the Dose:', style: TextStyle(fontSize: 18)),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
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
            onPressed: () => Navigator.pop(context, newDose),
            child: Text('Confirm New Dose'),
          ),
        ],
      ),
    );
  }
}
