import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Authentication
import 'package:firebase_core/firebase_core.dart'; // Import Firebase
import 'package:firebase_email_auth/views/game_view.dart';
import 'package:firebase_email_auth/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  sqfliteFfiInit(); // Initialize sqflite_common_ffi
  databaseFactory = databaseFactoryFfi;
  WidgetsFlutterBinding.ensureInitialized();
  //FirebaseAuth.instance.setLanguageCode("en"); // Set the preferred language code
  //Firebase.initializeApp(options: DefaultFirebaseOptions.android);
  await Firebase.initializeApp(
    // Replace with actual values
    options: const FirebaseOptions(
      apiKey: "AIzaSyAj3Z6gkwxOUPsJZFz_L1T-QEWH80vyjks",
      appId: "1:276047653482:android:de27fd68b1c4abf8a73813",
      messagingSenderId: "276047653482",
      projectId: "authservice-55b52",
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Create an instance of FirebaseAuth
  final FirebaseAuth _auth = FirebaseAuth.instance;

   MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Email Auth Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Use a StreamBuilder to listen to the user authentication state
      home: StreamBuilder<User?>(
        stream: _auth.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final user = snapshot.data;
            // Determine which screen to show based on the user's authentication status
            if (user == null) {
              // User is not authenticated, show the login screen
              return const LoginView();
            } else {
              // User is authenticated, show the home screen
              //return HomeView();
              return const GameApplication();
            }
          } else {
            // Return a loading indicator while Firebase initializes
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
