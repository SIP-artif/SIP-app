import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/pages/patient/carbs_patient.dart';
import 'package:myapp/pages/guardian/guardian_home_page.dart';
import 'package:myapp/pages/guardian/guardian_profile_page.dart';
import 'package:myapp/pages/patient/profile%20_page_%20patient.dart';
import 'package:myapp/pages/personal_info_page.dart';
import 'package:myapp/pages/welcome.dart';
import 'package:myapp/predicted_events.dart';
import 'services/firebase_options.dart';
import 'package:myapp/pages/patient/home page patient.dart';
import 'package:myapp/visuals/progress_provider.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/pages/guardian/My_Family_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Make sure Firebase is initialized!
  runApp(
    ChangeNotifierProvider(
      create: (_) => ProgressProvider(),
      child: MaterialApp(
        theme: ThemeData(textTheme: GoogleFonts.latoTextTheme()),
        //initialRoute: '/',
        //routes: {
         // '/': (context) => WelcomePage(),
          //'/home_patient': (context) => MyApp(),
        home:WelcomePage()
        ,
      ),
    ),
  );
}
