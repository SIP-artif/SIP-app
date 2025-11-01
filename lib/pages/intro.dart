import 'package:flutter/material.dart';
import 'package:myapp/pages/welcome.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _taglineController;
  late Animation<double> _logoAnimation;
  late Animation<double> _taglineAnimation;


@override
void initState() {
  super.initState();

  _logoController = AnimationController(
    duration: Duration(seconds: 2),
    vsync: this,
  );

  _logoAnimation = CurvedAnimation(
    parent: _logoController,
    curve: Curves.easeInOut,
  );

  _taglineController = AnimationController(
    duration: Duration(seconds: 2),
    vsync: this,
  );

  _taglineAnimation = CurvedAnimation(
    parent: _taglineController,
    curve: Curves.easeIn,
  );

  _logoController.forward();

  _logoController.addStatusListener((status) {
    if (status == AnimationStatus.completed) {
      _taglineController.forward();

      // After a small delay, navigate to Welcome Page
      Future.delayed(Duration(seconds: 6), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => WelcomePage()),
        );
      });
    }
  });
}


  @override
  void dispose() {
    _logoController.dispose();
    _taglineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4F7FC),
      body: Stack(
        children: [
          // Background decoration
          Positioned(
            bottom: 0,
            left: 0,
            child: Image.asset(
              'assets/images/background_shapes.png', 
              width: 200,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FadeTransition(
                  opacity: _logoAnimation,
                  child: Image.asset(
              'assets/images/sip_logo.png', 
              width: 150,
            ),
                ),
                SizedBox(height: 20),
                FadeTransition(
                  opacity: _taglineAnimation,
                  child: Text(
                    "Seamless insulin management\nat your fingertips!",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      fontSize: 20,
                      color: Colors.blue.shade600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
