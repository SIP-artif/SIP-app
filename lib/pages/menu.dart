import 'package:flutter/material.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  void _handleMenuSelection(String value) {
    if (value == "Settings") {
      Navigator.pushNamed(context, '/settings'); // Navigate to settings
    } else if (value == "Logout") {
      Navigator.pushReplacementNamed(context, '/login'); // Logout logic
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: _handleMenuSelection,
      itemBuilder: (BuildContext context) => [
        const PopupMenuItem(value: "Settings", child: Text("Settings")),
        const PopupMenuItem(value: "Logout", child: Text("Logout")),
      ],
    );
  }
}
