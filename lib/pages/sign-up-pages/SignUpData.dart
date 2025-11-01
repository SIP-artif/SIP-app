class SignUpData {
   String email;
   String emergencyPhone;
   String password;
   String firstName;
   String lastName;
   String birthDate;
   String gender;
   double? a1c;
   double? averageGlucose;
   double? shortActingDose;
   double? longActingDose;

  SignUpData({
    required this.email,
    required this.emergencyPhone,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    required this.gender,
    this.a1c,
    this.averageGlucose,
    this.shortActingDose,
    this.longActingDose,
  });
}

