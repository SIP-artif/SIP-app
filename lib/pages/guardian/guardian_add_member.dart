import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/pages/guardian/guardian_carb_tracker.dart';
import 'package:myapp/pages/guardian/guardian_home.dart';
import 'package:myapp/pages/guardian/guardian_profile.dart';
import 'package:myapp/services/user_service.dart';

class AddMemberPage extends StatefulWidget {
  const AddMemberPage({Key? key}) : super(key: key);

  @override
  State<AddMemberPage> createState() => _AddMemberPageState();
}

class _AddMemberPageState extends State<AddMemberPage> {
  final _formKey = GlobalKey<FormState>();

  int selectedGender = 0;
  int selectedRelationship = 0;

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final birthDateController = TextEditingController();
  final emergencyPhoneController = TextEditingController();
  final pumpIdController = TextEditingController();
  final a1cController = TextEditingController();
  final tirController = TextEditingController();
  final avgGlucoseController = TextEditingController();
  final longDoseController = TextEditingController();
  final shortDoseController = TextEditingController();

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    birthDateController.dispose();
    emergencyPhoneController.dispose();
    pumpIdController.dispose();
    a1cController.dispose();
    tirController.dispose();
    avgGlucoseController.dispose();
    longDoseController.dispose();
    shortDoseController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final userData = {
      'firstName': firstNameController.text.trim(),
      'lastName': lastNameController.text.trim(),
      'gender': selectedGender == 0 ? 'F' : 'M',
      'birthDate': birthDateController.text.trim(),
      'emergencyPhone': emergencyPhoneController.text.trim(),
      'relationship': _relationshipText(selectedRelationship),
      'PumpID': pumpIdController.text.trim(),
      'A1C': double.tryParse(a1cController.text) ?? 0,
      'TIR': double.tryParse(tirController.text) ?? 0,
      'averageGlucose': double.tryParse(avgGlucoseController.text) ?? 0,
      'longActingDose': double.tryParse(longDoseController.text) ?? 0,
      'shortActingDose': double.tryParse(shortDoseController.text) ?? 0,
    };

    try {
      await UserService().addMember(userData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Member added successfully')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add member: $e')),
      );
    }
  }

  String _relationshipText(int index) {
    return ['Parent', 'Child', 'Sibling', 'Other'][index];
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    String hint, {
    TextInputType keyboardType = TextInputType.text,
    bool isRequired = true,
    bool isNumeric = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: GoogleFonts.lato(fontSize: 18),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.lato(fontSize: 18, color: Colors.grey[700]),
        hintText: hint,
        hintStyle: GoogleFonts.lato(fontSize: 16, color: Colors.grey[500]),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey), // Default color
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF2C7BBC)), // Change color when focused
      ),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) {
        if (isRequired && (value == null || value.trim().isEmpty)) {
          return '$label is required';
        }
        if (isNumeric && double.tryParse(value!) == null) {
          return 'Enter a valid number';
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      bottomNavigationBar: BottomNavigationBar(
  currentIndex: 2,
  backgroundColor: Color(0xFFFFFFFF),
  selectedItemColor: Color(0xFF215F90),
  unselectedItemColor: Color(0xFF215F90).withOpacity(0.6),
  showUnselectedLabels: true,
  selectedLabelStyle: GoogleFonts.lato(
    fontWeight: FontWeight.w500,
    fontSize: 13,
  ),
  unselectedLabelStyle: GoogleFonts.lato(
    fontWeight: FontWeight.w300,
    fontSize: 12,
  ),
  items: const [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: "Home",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.fastfood),
      label: "Carbs",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: "Profile",
    ),
  ],
  onTap: (index) {
    switch (index) {
      case 0:
        Navigator.push(context, MaterialPageRoute(
          builder: (_) => GuardianHomePage(),
        ));
        break;
      case 1:
        Navigator.push(context, MaterialPageRoute(
          builder: (_) => CarbTrackingPage(),
        ));
        break;
      case 2:
        Navigator.push(context, MaterialPageRoute(
          builder: (_) => ProfilePageGuardian(),
        ));
        break;
    }
  },
),
      backgroundColor: const Color(0xFFF4F7FC),
      appBar: AppBar(
        leading: BackButton(),
        title: Text('Add Member', style: GoogleFonts.lato(color: Colors.black, fontSize:24, fontWeight: FontWeight.bold )),
        backgroundColor: const Color(0xFFF4F7FC),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(firstNameController, 'First Name', ''),
              const SizedBox(height: 14),
              _buildTextField(lastNameController, 'Last Name', ''),
              const SizedBox(height: 14),
              _buildTextField(birthDateController, 'Birth Date', 'DD/MM/YYYY'),
              const SizedBox(height: 14),
              _buildGenderSelector(),
              const SizedBox(height: 14),
              _buildTextField(emergencyPhoneController, 'Emergency Phone', 'starts with +966', keyboardType: TextInputType.phone),
              const SizedBox(height: 14),
              _buildTextField(pumpIdController, 'Pump ID', ''),
              const SizedBox(height: 14),
              _buildTextField(a1cController, 'A1C (%)', '', keyboardType: TextInputType.number, isNumeric: true),
              const SizedBox(height: 14),
              _buildTextField(tirController, 'TIR (%)', '', keyboardType: TextInputType.number, isNumeric: true),
              const SizedBox(height: 14),
              _buildTextField(avgGlucoseController, 'Average Glucose (mg/dL)', '', keyboardType: TextInputType.number, isNumeric: true),
              const SizedBox(height: 14),
              _buildTextField(longDoseController, 'Long Acting Dose', '', keyboardType: TextInputType.number, isNumeric: true),
              const SizedBox(height: 14),
              _buildTextField(shortDoseController, 'Short Acting Dose', '', keyboardType: TextInputType.number, isNumeric: true),
              const SizedBox(height: 14),
              _buildRelationshipSelector(),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2C7BBC),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('Add Member', style: GoogleFonts.lato(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenderSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Gender:", style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Row(
          children: [
            _buildGenderButton(0, 'Female'),
            const SizedBox(width: 8),
            _buildGenderButton(1, 'Male'),
          ],
        )
      ],
    );
  }

  Widget _buildGenderButton(int value, String label) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () => setState(() => selectedGender = value),
        style: ElevatedButton.styleFrom(
          backgroundColor: selectedGender == value ? const Color(0xFF2C7BBC) : Colors.white,
          foregroundColor: selectedGender == value ? Colors.white : Colors.black,
          side: const BorderSide(color: Color(0xFF2C7BBC)),
          padding: const EdgeInsets.symmetric(vertical: 10),
        ),
        child: Text(label, style: GoogleFonts.lato(fontSize: 16)),
      ),
    );
  }

  Widget _buildRelationshipSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text("Relationship:", style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.w600)),
        Wrap(
          spacing: 16,
          children: List.generate(4, (index) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Radio<int>(
                  value: index,
                  groupValue: selectedRelationship,
                  onChanged: (val) => setState(() => selectedRelationship = val!),
                  activeColor: const Color(0xFF2C7BBC),
                ),
                Text(_relationshipText(index), style: GoogleFonts.lato(fontSize: 16)),
              ],
            );
          }),
        )
      ],
    );
  }
}