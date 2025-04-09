import 'package:flutter/material.dart';
import 'package:myapp/visuals/progress_provider.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'sign_up_3.dart';

class SignUp2 extends StatefulWidget {
  const SignUp2({super.key});

  @override
  _SignUp2State createState() => _SignUp2State();
}

class _SignUp2State extends State<SignUp2> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _birthDateController.dispose();
    _genderController.dispose();
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
        title: Text(
          'Personal Information',
          style: GoogleFonts.lato(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),),
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

      body: SafeArea(
  child: SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 40),
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
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color.fromARGB(255, 143, 135, 255),
              ),
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
              'First Name:',
              'Enter your first name',
              _firstNameController,
            ),
            SizedBox(height: 20.0),
            _buildTextField(
              'Last Name:',
              'Enter your last name',
              _lastNameController,
            ),
            SizedBox(height: 20.0),
            _buildTextField('Birth Date:', 'DD/MM/YY', _birthDateController),
            SizedBox(height: 20.0),
            _buildTextField('Gender:', 'F or M', _genderController),
            SizedBox(height: 40.0),
             SizedBox(
              width: double.infinity,
              height: 45.0,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUp3()), //CHANGE
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
              hintStyle: TextStyle(color: Colors.grey, fontSize: 14.0),
            ),
          ),
        ),
      ],
    );
  }
}
