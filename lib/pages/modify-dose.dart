import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ModifyDosePage extends StatefulWidget {
  final double suggestedDose;
  
  ModifyDosePage({required this.suggestedDose});

  @override
  _ModifyDosePageState createState() => _ModifyDosePageState();
}

class _ModifyDosePageState extends State<ModifyDosePage> {
  late double modifiedDose;

  @override
  void initState() {
    super.initState();
    modifiedDose = widget.suggestedDose;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Modify Dose')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Suggested Dose: ${widget.suggestedDose.toStringAsFixed(1)} Units'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: () {
                  setState(() {
                    if (modifiedDose > 0) modifiedDose -= 0.5;
                  });
                },
              ),
              Text('${modifiedDose.toStringAsFixed(1)} Units',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    modifiedDose += 0.5;
                  });
                },
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, modifiedDose),
            child: Text('inject'),
          ),
        ],
      ),
    );
  }
}
