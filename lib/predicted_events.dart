import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PredictedEventsPage extends StatelessWidget {
  const PredictedEventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Predicted Events'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.black),
            onPressed: () {
              // Navigate to edit screen
            },
          ),
        ],
      ),
      
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            SizedBox(height: 24),
            Text('Upcoming Events: ', style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
                
            // Timeline List
            Expanded(
              child: ListView(
                children: List.generate(2, (index) {
                  final times = ['4:30 PM', '6:00 PM'];
                  final values = ['68 mg/dL', '95 mg/dL'];
                  final types = ['Possible Hypoglycemia', 'Possible Hyperglycemia'];
                  final risks = [const Color(0xFFF6CE30),const Color(0xFFE85454),];

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: Color(0xFFABABAB), 
                        width: 1, 
                      ),
                      ),
                    child: ListTile(
                      leading: Icon(Icons.access_time, color: risks[index]),
                      title: Text('${times[index]} — ${values[index]}', style: GoogleFonts.lato(fontSize:17, fontWeight: FontWeight.w700),),
                      subtitle: Text(types[index], style: GoogleFonts.lato(fontSize:14,),),
                      trailing: Chip(label: Text(index == 0 ? 'Low' : index == 1 ? 'High':'', 
                      style: GoogleFonts.lato(fontSize:16,fontWeight: FontWeight.w800, color: Colors.white,),), backgroundColor: risks[index]),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
