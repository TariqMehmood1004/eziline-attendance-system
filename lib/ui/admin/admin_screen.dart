import 'package:android_attendance_system/ui/admin/admin.accepted.leaves.dart';
import 'package:android_attendance_system/ui/admin/admin.generate.report.dart';
import 'package:android_attendance_system/ui/admin/admin.pending.dart';
import 'package:android_attendance_system/ui/admin/admin.profile.dart';
import 'package:android_attendance_system/ui/admin/home.admin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../constants/constant_export.dart';
import '../../services/firebase/firebase_services.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    AdminHomeScreenWidget(),
    AdminAcceptedLeavesScreen(),
    AdminPendingScreen(),
    AdminGenerateReportScreen(),
    AdminProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get the current user's information
    User? user = FirebaseService.currentUser;

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
                  Icons.report,
                  size: 27,
                  color: kWhite,
                ),
              ),
              label: '', // No label
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.report, color: kBottomNavigationBarFgColor),
              label: 'Report',
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
