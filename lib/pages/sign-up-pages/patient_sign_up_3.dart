import 'package:flutter/material.dart';
import 'package:myapp/pages/patient/patient_home.dart';
import 'package:myapp/pages/sign-up-pages/SignUpData.dart';
import 'package:myapp/services/user_service.dart';
import 'package:myapp/visuals/progress_provider.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/services/shared_prefs_service.dart';

class SignUp3 extends StatefulWidget {
  final SignUpData signUpData;
  const SignUp3({super.key, required this.signUpData});

  @override
  _SignUp3State createState() => _SignUp3State();
}

class _SignUp3State extends State<SignUp3> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _CurrentA1CController = TextEditingController();
  final TextEditingController _AverageGlucoseController = TextEditingController();
  final TextEditingController _ShortActingController = TextEditingController();
  final TextEditingController _LongActingController = TextEditingController();

  @override
  void dispose() {
    _CurrentA1CController.dispose();
    _AverageGlucoseController.dispose();
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
      backgroundColor: const Color(0xFFF4F7FC),
      appBar: AppBar(
        title: Text(
          'Health Information',
          style: GoogleFonts.lato(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Provider.of<ProgressProvider>(context, listen: false).decreaseProgress();
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
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
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color.fromARGB(255, 143, 135, 255),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildInputCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputCard() {
    return Form(
      key: _formKey,
      child: Card(
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
              _buildTextField(
                'Current A1C:',
                'Percent',
                _CurrentA1CController,
                (value) {
                  if (value == null || value.isEmpty) return 'This field is required';
                  if (double.tryParse(value) == null) return 'Enter a valid number';
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              _buildTextField(
                'Average Glucose Level:',
                'mg/dL',
                _AverageGlucoseController,
                (value) {
                  if (value == null || value.isEmpty) return 'This field is required';
                  if (double.tryParse(value) == null) return 'Enter a valid number';
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              _buildTextField(
                'Short-Acting insulin dose:',
                'Units',
                _ShortActingController,
                (value) {
                  if (value == null || value.isEmpty) return 'This field is required';
                  if (double.tryParse(value) == null) return 'Enter a valid number';
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              _buildTextField(
                'Long-Acting insulin dose:',
                'Units',
                _LongActingController,
                (value) {
                  if (value == null || value.isEmpty) return 'This field is required';
                  if (double.tryParse(value) == null) return 'Enter a valid number';
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              SizedBox(
                width: double.infinity,
                height: 45.0,
                child: ElevatedButton(
                  onPressed: () async {
  if (_formKey.currentState!.validate()) {
    // Update SignUpData with the final form values
    widget.signUpData.a1c = double.parse(_CurrentA1CController.text);
    widget.signUpData.averageGlucose = double.parse(_AverageGlucoseController.text);
    widget.signUpData.shortActingDose = double.parse(_ShortActingController.text);
    widget.signUpData.longActingDose = double.parse(_LongActingController.text);

    String? result = await UserService().addUser(widget.signUpData);
    if (result == null) {
      // If no error, proceed to home page
      String? uid = await getUserIdFromPrefs();
      if (uid != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UserHomePage(userId: uid)),
        );
      }
    } else {
      // Handle error (e.g. show a dialog with the error message)
      print('Error: $result');
    }
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
                    'Sign Up',
                    style: GoogleFonts.lato(fontSize: 18.0, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    String hint,
    TextEditingController controller,
    String? Function(String?) validator,
  ) {
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
