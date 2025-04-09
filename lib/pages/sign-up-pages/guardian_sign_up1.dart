import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/pages/guardian/guardian_home_page.dart';

// 1️⃣ Guardian Account Page
class GuardianAccountPage extends StatefulWidget {
  const GuardianAccountPage({super.key});

  @override
  _GuardianAccountPageState createState() => _GuardianAccountPageState();
}

class _GuardianAccountPageState extends State<GuardianAccountPage> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();
  final TextEditingController _name = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0xFFF4F7FC),
      appBar: AppBar(title: Text(
        'Account Information',
        style: GoogleFonts.lato(
          fontSize:24,
          fontWeight: FontWeight.bold,
        ))),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 60),
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
            _buildTextField('Email:', 'Enter your email', _email),
            SizedBox(height: 20.0),
            _buildTextField('Password', '8 characters long with a numbers', _password),
            SizedBox(height: 20.0),
             _buildTextField('Name:', 'Enter your name', _name),
            SizedBox(height: 20.0),
            _buildTextField('Phone number:', 'Start with +966', _phoneNumber),
            SizedBox(height: 40.0),
             SizedBox(
              width: double.infinity,
              height: 45.0,

              child: ElevatedButton(
                onPressed:() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GuardianHomePage(guardianId: 'fBlCBuQHY1Z26H1IanKl',)),
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
                  'Sign-Up',
                  style:GoogleFonts.lato(fontSize: 18.0, fontWeight: FontWeight.bold,),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.lato(fontSize: 17.0, color: Colors.black, letterSpacing: 1.0),
        ),
        SizedBox(height: 10.0),
        SizedBox(
          width: double.infinity,
          height: 40.0,
          child: TextField(
          controller: controller,
          obscureText: label.toLowerCase() == 'password', 
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