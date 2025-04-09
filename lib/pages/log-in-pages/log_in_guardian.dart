import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:myapp/pages/guardian/guardian_home_page.dart';

class LoginPageGuardian extends StatefulWidget {
  const LoginPageGuardian({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPageGuardian> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true; // To toggle password visibility

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      appBar: AppBar(title: Text(
        'Log-in',
         style: GoogleFonts.lato(
          fontSize: 24,
          fontWeight: FontWeight.bold,
         ))),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            _buildInputCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputCard() {
    return Card(
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.grey, width: 1.0),
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField('Email:', 'Enter your email', _emailController),
            const SizedBox(height: 20.0),
            _buildPasswordField('Password:', 'Enter your password', _passwordController),
            const SizedBox(height: 40.0),
            // Log In Button inside the box
            SizedBox(
              width: double.infinity,
              height: 45.0,
              child: ElevatedButton(
                onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GuardianHomePage(guardianId: 'fBlCBuQHY1Z26H1IanKl')),
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
                  'Log In',
                  style: GoogleFonts.lato(fontSize: 17.0),
                ),
              ),
            ),
            
            const SizedBox(height: 10.0),
            // Forgot Password? TextButton
            TextButton(
              onPressed: () {
                // Navigate to forgot password page
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero, // Remove default padding
                alignment: Alignment.centerLeft, // Align left
              ),
              child: Text(
                'Forgot Password?',
                style: GoogleFonts.lato(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  decoration: TextDecoration.underline,
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
        const SizedBox(height: 10.0),
        SizedBox(
          width: double.infinity,
          height: 50.0,
          child: TextFormField(
            controller: controller,
            obscureText: label.toLowerCase() == 'password' ? _obscureText : false,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              hintText: hint,
              hintStyle: GoogleFonts.lato(color: Colors.grey, fontSize: 14.0),
              suffixIcon: label.toLowerCase() == 'password'
                  ? IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    )
                  : null,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a value';
              }
              if (label.toLowerCase() == 'email' && !value.contains('@')) {
                return 'Please enter a valid email';
              }
              if (label.toLowerCase() == 'password' && value.length < 8) {
                return 'Password must be at least 8 characters long';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField(String label, String hint, TextEditingController controller) {
    return _buildTextField(label, hint, controller);
  }
}