import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/pages/guardian/guardian_home.dart';
import 'package:myapp/services/user_service.dart';

// 1️⃣ Guardian Account Page
class GuardianSignupPage extends StatefulWidget {
  const GuardianSignupPage({super.key});

  @override
  _GuardianSignupPage createState() => _GuardianSignupPage();
}

class _GuardianSignupPage extends State<GuardianSignupPage> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();
  final TextEditingController _name = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _phoneNumber.dispose();
    _name.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final userService = UserService();

    final error = await userService.addGuardian(
      email: _email.text.trim(),
      password: _password.text.trim(),
      name: _name.text.trim(),
      phoneNumber: _phoneNumber.text.trim(),
    );

    setState(() => _isLoading = false);

    if (error == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => GuardianHomePage(),
        ),
      );
    } else {
      _showErrorDialog(error);
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Signup Failed'),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      appBar: AppBar(
        title: Text(
          'Account Information',
          style: GoogleFonts.lato(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.only(top: 60),
            shrinkWrap: true,
            children: [
              _buildInputCard(),
              const SizedBox(height: 20),
            ],
          ),
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
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField('Email', 'Enter your email', _email, (value) {
              if (value == null || !value.contains('@')) {
                return 'Please enter a valid email.';
              }
              return null;
            }),
            const SizedBox(height: 20.0),
            _buildTextField('Password', '8+ characters with a number', _password, (value) {
              if (value == null || value.length < 8 || !RegExp(r'\d').hasMatch(value)) {
                return 'Password must be 8+ characters and include a number.';
              }
              return null;
            }),
            const SizedBox(height: 20.0),
            _buildTextField('Name', 'Enter your name', _name, (value) {
              if (value == null || value.isEmpty) {
                return 'Name cannot be empty.';
              }
              return null;
            }),
            const SizedBox(height: 20.0),
            _buildTextField('Phone number', 'Start with +966', _phoneNumber, (value) {
              if (value == null || !value.startsWith('+966') || value.length < 10) {
                return 'Phone number must start with +966 and be valid.';
              }
              return null;
            }),
            const SizedBox(height: 40.0),
            SizedBox(
              width: double.infinity,
              height: 45.0,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleSignup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'Sign-Up',
                        style: GoogleFonts.lato(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
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
    String? Function(String?)? validator,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.lato(
            fontSize: 17.0,
            color: Colors.black,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 10.0),
        SizedBox(
          width: double.infinity,
          height: 40.0,
          child: TextFormField(
            controller: controller,
            obscureText: label.toLowerCase().contains('password'),
            validator: validator,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              hintText: hint,
              hintStyle: GoogleFonts.lato(
                color: Colors.grey,
                fontSize: 14.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
