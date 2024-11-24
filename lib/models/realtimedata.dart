// ignore_for_file: library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_email_auth/models/database_helper.dart';
import 'package:firebase_email_auth/views/game_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class UploadDataScreen extends StatefulWidget {
  const UploadDataScreen({super.key});

  @override
  _UploadDataScreenState createState() => _UploadDataScreenState();
}

class _UploadDataScreenState extends State<UploadDataScreen> {
  /*final List<Map<String, dynamic>> data = [
    {'id': 1, 'top': 3, 'bottom': 3},
    {'id': 2, 'top': 2, 'bottom': 3},
    {'id': 3, 'top': 1, 'bottom': 2},
    {'id': 4, 'top': 3, 'bottom': 1},
    {'id': 5, 'top': 1, 'bottom': 1},
    {'id': 6, 'top': 2, 'bottom': 2},
    {'id': 7, 'top': 1, 'bottom': 2},
    {'id': 8, 'top': 1, 'bottom': 1},
  ];*/
  List<Map<String, dynamic>> data = []; // Initialize data as an empty list

  @override
  void initState() {
    super.initState();
    fetchDataFromDatabase();
  }

  Future<void> fetchDataFromDatabase() async {
    List<Map<String, dynamic>> gameState =
        await DatabaseHelper().getGameState();

    setState(() {
      data = gameState; // Assign the fetched data to the data variable
    });

    // Now you can upload data to Firestore or perform other actions with the data
    uploadDataToFirestore(data);
  }

  Future<void> uploadDataToFirestore(List<Map<String, dynamic>> data) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference collection = firestore
        .collection('my_firebase_db'); // Replace with your collection name

    for (var item in data) {
      await collection.add(item);
    }

    if (kDebugMode) {
      print('Data uploaded to Firestore.');
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const GameApplication()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Data to Firestore'),
      ),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
