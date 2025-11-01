import 'package:flutter/material.dart';
import 'package:myapp/pages/sign-up-pages/SignUpData.dart';
import 'package:myapp/visuals/progress_provider.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'patient_sign_up_2.dart';

class SignUp1 extends StatefulWidget {
  const SignUp1({super.key});

  @override
  _SignUp1State createState() => _SignUp1State();
}

class _SignUp1State extends State<SignUp1> {
  final _formKey = GlobalKey<FormState>();
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.all(20.0),
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
                    valueColor: const AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 143, 135, 255)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
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
      margin: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField('Email:', 'Enter your email', _email,
                validator: (value) => value != null && value.contains('@') ? null : 'Invalid email'),
            const SizedBox(height: 20.0),
            _buildTextField('Emergency phone number:', 'Start with +966', _emerNumber,
                validator: (value) => value != null && value.startsWith('+966') ? null : 'Must start with +966'),
            const SizedBox(height: 20.0),
            _buildTextField('Password', '8 characters long with a number', _password,
                obscure: true,
                validator: (value) => value != null && value.length >= 8 ? null : 'At least 8 characters'),
            const SizedBox(height: 40.0),
            SizedBox(
              width: double.infinity,
              height: 45.0,
              child: ElevatedButton(
onPressed: () {
  if (_formKey.currentState!.validate()) {
    // Create SignUpData and pass it to SignUp2
    SignUpData signUpData = SignUpData(
      email: _email.text,
      emergencyPhone: _emerNumber.text,
      password: _password.text,
      firstName: '',  // Placeholder for first name, to be filled in SignUp2
      lastName: '',   // Placeholder for last name, to be filled in SignUp2
      birthDate: '',  // Placeholder for birth date, to be filled in SignUp2
      gender: '',     // Placeholder for gender, to be filled in SignUp2
      a1c: null,      // Placeholder for A1C value, to be filled in SignUp3
      averageGlucose: null,  // Placeholder for Average Glucose value, to be filled in SignUp3
      shortActingDose: null, // Placeholder for Short-Acting Dose, to be filled in SignUp3
      longActingDose: null,  // Placeholder for Long-Acting Dose, to be filled in SignUp3
    );

    // Navigate to SignUp2 and pass the signUpData object
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SignUp2(signUpData: signUpData),
      ),
    );
  }
},

  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.black,
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
  ),
  child: Text(
    'Next',
    style: GoogleFonts.lato(
      fontSize: 18.0, fontWeight: FontWeight.w600),
  ),
),

            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint, TextEditingController controller,
      {bool obscure = false, String? Function(String?)? validator}) {
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
          height: 40.0,
          child: TextFormField(
            controller: controller,
            obscureText: obscure,
            validator: validator,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: Colors.grey),
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
