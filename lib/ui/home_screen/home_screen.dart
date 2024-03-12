// ignore_for_file: unused_field, unused_element, non_constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../ui_export.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    Text("Home Screen"),
    Text("Inbox Screen"),
    Text("Payment Wallet Screen"),
    Text("Settings Screen"),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get the current user's information
    User? user = FirebaseAuth.instance.currentUser;

    // Check if the user is logged in
    if (user == null) {
      return const Scaffold(
          body: Center(
        child: Text("Welcome Screen"),
      ));
    }

    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: kGray.withOpacity(0.15),
            ),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: kTransparent,
          showUnselectedLabels: true,
          showSelectedLabels: true,
          elevation: 0.0,
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            const BottomNavigationBarItem(
              icon: Icon(Icons.home, color: kBottomNavigationBarFgColor),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.inbox, color: kBottomNavigationBarFgColor),
              label: 'Inbox',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  color: kGray.withOpacity(0.2),
                  border: Border.all(color: kGray.withOpacity(0.2), width: 1.0),
                  borderRadius: BorderRadius.circular(100.0),
                ),
                child: const Icon(
                  Icons.wallet,
                  size: 27,
                  color: kWhite,
                ),
              ),
              label: '', // No label
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.settings, color: kBottomNavigationBarFgColor),
              label: 'Settings',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person, color: kBottomNavigationBarFgColor),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          iconSize: 22.0,
          unselectedFontSize: 12.0,
          onTap: _onItemTapped,
        ),
      ),
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
    );
  }
}
