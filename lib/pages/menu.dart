import 'package:flutter/material.dart';
import 'package:myapp/pages/welcome.dart';
import 'package:myapp/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';


class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  void _handleMenuSelection(String value) {
    if (value == "Logout") {
      _showLogoutConfirmationDialog();
    }
  }

  Future<void> _showLogoutConfirmationDialog() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirm Logout", style: GoogleFonts.lato(fontSize: 18,)),
        content: Text("Are you sure you want to log out?", style: GoogleFonts.lato(fontSize: 18,fontWeight: FontWeight.bold)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text("Cancel", style: GoogleFonts.lato(fontSize: 18,)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text("Logout", style: GoogleFonts.lato(fontSize: 18,),),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      await _logout();
    }
  }

  Future<void> _logout() async {
    // Clear shared preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // Call UserService logout
    await UserService().logout();

    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const WelcomePage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: _handleMenuSelection,
      itemBuilder: (BuildContext context) => [
         PopupMenuItem(value: "Logout", child: Text("Logout", style: GoogleFonts.lato(fontSize: 18,))
        ),
      ],
    );
  }
}
