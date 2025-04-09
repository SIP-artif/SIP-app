import 'package:flutter/material.dart';
import 'package:myapp/pages/log-in-pages/log_in_guardian.dart';
import 'package:myapp/pages/sign-up-pages/sign_up_1.dart';
import 'package:myapp/pages/sign-up-pages/guardian_sign_up1.dart';
import 'package:myapp/pages/log-in-pages/log_in_patient.dart';
import 'package:google_fonts/google_fonts.dart';


class WelcomePage extends StatelessWidget {
const WelcomePage({super.key});

@override
Widget build(BuildContext context) {
 return Scaffold(
   body: Center(
     child: Column(
       mainAxisAlignment: MainAxisAlignment.center,
       children: [
          Text(
            'Welcome to SIP!',
            style: GoogleFonts.lato(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Get started by choosing your account type:',
            textAlign: TextAlign.center,
            style: GoogleFonts.lato(
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 40),
         _buildSignUpCard(
          context: context,
           title: "I'm a User",
           backgroundColor: Colors.black,
           buttonColor: Colors.grey[300]!,
           textColor: Colors.white,
           signUpColor: Colors.black,
         ),
         const SizedBox(height: 40),
         _buildSignUpCard(
           context: context,
           title: "I'm a Guardian",
           backgroundColor: Colors.white,
           buttonColor: Colors.blue,
           textColor: Colors.black,
           signUpColor: Colors.white,
           border: true,
         ),
       ],
     ),
   ),
 ); 
}

Widget _buildSignUpCard({
  required BuildContext context, 
  required String title,
  required Color backgroundColor,
  required Color buttonColor,
  required Color textColor,
  required Color signUpColor,
  bool border = false,
}){
 return Container(
   width: 300,
   padding: const EdgeInsets.all(20),
   decoration: BoxDecoration(
     color: backgroundColor,
     borderRadius: BorderRadius.circular(10),
     border: border ? Border.all(color: Colors.grey) : null,
   ),
   child: Column(
     children: [
       Text(
         title,
         style: GoogleFonts.lato(
           fontSize: 22,
           fontWeight: FontWeight.bold,
           color: textColor,
         ),
       ),
       const SizedBox(height: 10),
       ElevatedButton(
         style: ElevatedButton.styleFrom(
           backgroundColor: buttonColor,
           foregroundColor: Colors.white,
           minimumSize: const Size(double.maxFinite, 45),
           shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.circular(5),
           ),
         ),
         onPressed: () {
          if (title == "I'm a User") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignUp1()),
              );
              
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => GuardianAccountPage()),
              );
          }
         },
         child: Text(
          "Sign up",
          style: GoogleFonts.lato(
            color: signUpColor, 
            fontSize: 18,
            fontWeight: FontWeight.w600,),
         ),
       ),
       const SizedBox(height: 10),
       Text(
         "already have an account?",
         style: GoogleFonts.lato(color: textColor, fontSize: 14),
       ),
       InkWell(
        onTap: () {
          if (title == "I'm a User") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()), 
            );
          
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPageGuardian()), 
              );
          }
        },
        child: Text(
          "log in",
          style: GoogleFonts.lato(
            color: Colors.blue,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
            decorationColor: Colors.blue,
          ),
        ),
      ),
     ],
   ),
 );
}
}