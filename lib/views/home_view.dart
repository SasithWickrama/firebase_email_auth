// home_view.dart
import 'package:flutter/material.dart';
import 'package:firebase_email_auth/controllers/auth_controller.dart';

class HomeView extends StatelessWidget {
  final AuthController _auth = AuthController();

  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _auth.signOut();
              // Navigate back to the login screen
              // Use Navigator.pushReplacement() or similar methods
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('Welcome to the Home Screen!'),
      ),
    );
  }
}
