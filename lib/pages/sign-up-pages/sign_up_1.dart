import 'package:flutter/material.dart';
import 'package:myapp/visuals/progress_provider.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'sign_up_2.dart';


class SignUp1 extends StatefulWidget {
  const SignUp1({super.key});

  @override
  _SignUp1State createState() => _SignUp1State();
}

class _SignUp1State extends State<SignUp1> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _emerNumber = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _emerNumber.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = Provider.of<ProgressProvider>(context).progress;

    return Scaffold(
      backgroundColor: Color(0xFFF4F7FC),
      appBar: AppBar(title: Text(
        'Account Information',
        style: GoogleFonts.lato(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      )),
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
                      const Color.fromARGB(255, 143, 135, 255)),
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
            _buildTextField('Email:', 'Enter your email', _email),
            SizedBox(height: 20.0),
            _buildTextField('Emergency phone number:', 'Start with +966', _emerNumber),
            SizedBox(height: 20.0),
            _buildTextField('Password', '8 characters long with a numbers', _password),
            SizedBox(height: 40.0),
             SizedBox(
              width: double.infinity,
              height: 45.0,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUp2()),
                 );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // Button background color
                  foregroundColor: Colors.white, // Button text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child:  Text(
                  'Next',
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

  Widget _buildTextField(String label, String hint, TextEditingController controller) {
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