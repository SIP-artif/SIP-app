import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/pages/InsulinPage.dart';
import 'package:myapp/pages/patient/carbs_patient.dart';
import 'package:myapp/pages/menu.dart';
import 'package:myapp/pages/patient/profile _page_ patient.dart';

class HomePage extends StatelessWidget {
  final double suggestedDose = 5.0; // Example value, should be fetched dynamically

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 
        Row(
          children: [
            Text('Diabetes Management', style: GoogleFonts.lato(
                fontSize: 24,
                fontWeight: FontWeight.bold, 
              )),
              const Menu(),
          ],
        )),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Current Blood Glucose: 280 mg/dL',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
          Container(
            height: 150,
            width: 300,
            color: Colors.grey[300],
            child: Center(child: Text('Graph Placeholder')),
          ),
          SizedBox(height: 20),
          Text('Suggested Dose: $suggestedDose Units',
              style: TextStyle(fontSize: 18)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  final modifiedDose = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ModifyDosePage(suggestedDose: suggestedDose),
                    ),
                  );
                  if (modifiedDose != null) {
                    _showConfirmationDialog(context, modifiedDose);
                  }
                },
                child: Text('Modify')
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () async {
                  final newDose = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewDosePage(),
                    ),
                  );
                  if (newDose != null) {
                    _showConfirmationDialog(context, newDose);
                  }
                },
                child: Text('Create New Dose'),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.fastfood), label: "Carbs"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        onTap: (index) {
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PatientProfilePage()),
            );
          }
           if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CarbsTrackerApp()),
            );
          }
        },
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context, double dose) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Are you sure?'),
        content: Text('$dose units of insulin will be injected'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$dose units injected!')),
              );
            },
            child: Text('Confirm'),
          ),
        ],
      ),
    );
  }
}

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
            child: Text('Confirm Modification'),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.fastfood), label: "Carbs"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

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
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.fastfood), label: "Carbs"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
