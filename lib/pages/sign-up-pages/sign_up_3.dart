import 'package:flutter/material.dart';
import 'package:myapp/pages/patient/home%20page%20patient.dart';
import 'package:myapp/visuals/progress_provider.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';


class SignUp3 extends StatefulWidget {
  const SignUp3({super.key});

  @override
  _SignUp3State createState() => _SignUp3State();
}

class _SignUp3State extends State<SignUp3> {
  final TextEditingController _Current_A1C_Controller = TextEditingController();
  final TextEditingController _AverageGlucoseLevelController = TextEditingController();
  final TextEditingController _ShortActingController = TextEditingController();
  final TextEditingController _LongActingController = TextEditingController();

  @override
  void dispose() {
    _Current_A1C_Controller.dispose();
    _AverageGlucoseLevelController.dispose();
    _ShortActingController.dispose();
    _LongActingController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<ProgressProvider>(context, listen: false).increaseProgress();
    });
  }

  @override
  Widget build(BuildContext context) {
    final progress = Provider.of<ProgressProvider>(context).progress;

    return Scaffold(
      backgroundColor: Color(0xFFF4F7FC),
      appBar: AppBar(
        title: Text('Health Information',
        style: GoogleFonts.lato(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Back arrow
          onPressed: () {
            Provider.of<ProgressProvider>(
              context,
              listen: false,
            ).decreaseProgress();
            Navigator.pop(context); // Go back to SignUp1
          },
        ),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                height: 10,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey[300],
                ),
                child: LinearProgressIndicator(
                  value: progress / 100,
                  minHeight: 10,
                  backgroundColor: const Color.fromARGB(115, 255, 255, 255),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    const Color.fromARGB(255, 143, 135, 255),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            _buildInputCard(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInputCard() {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey, width: 1.0),
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(
              'Current A1C:',
              'Percent',
              _Current_A1C_Controller,
            ),
            SizedBox(height: 20.0),
            _buildTextField(
              'Average Glucose Level:',
              'mg/dL',
              _AverageGlucoseLevelController,
            ),
            SizedBox(height: 20.0),
            _buildTextField(
              'Short-Acting insulin dose:',
              'Units',
              _ShortActingController,
            ),
            SizedBox(height: 20.0),
            _buildTextField(
              'Long-Acting insulin does',
              'Units',
             _LongActingController,
            ),
            SizedBox(height: 20.0),
             SizedBox(
              width: double.infinity,
              height: 45.0,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()), 
                );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // Button background color
                  foregroundColor: Colors.white, // Button text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  'Sign Up',
                  style: GoogleFonts.lato(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    String hint,
    TextEditingController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.lato(fontSize: 18.0, color: Colors.black, letterSpacing: 1.0),
        ),
        SizedBox(height: 10.0),
        SizedBox(
          width: double.infinity,
          height: 40.0,
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: Colors.grey),
              ),
              hintText: hint,
              hintStyle: GoogleFonts.lato(color: Colors.grey, fontSize: 14.0),
            ),
          ),
        ),
      ],
    );
  }
}