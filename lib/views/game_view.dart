import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:firebase_email_auth/controllers/auth_controller.dart';
import 'package:firebase_email_auth/models/database_helper.dart';
import 'package:firebase_email_auth/models/realtimedata.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class GameApplication extends StatefulWidget {
  const GameApplication({Key? key}) : super(key: key);

  @override
  State<GameApplication> createState() => _GameApplicationState();
}

class _GameApplicationState extends State<GameApplication> {
  final AuthController _auth = AuthController();
  CameraController? _controller;
  List<CameraDescription> cameras = [];
  //final CameraController _auth_cam = CameraController(description, resolutionPreset);
  int top = 1;
  int bottom = 1;
  String gameStatus = '';
  String image1 = '';
  String image2 = '';
  File? _img;

  @override
  void initState() {
    super.initState();
    loadGameState();
    // Initialize the camera
    availableCameras().then((availableCameras) {
      cameras = availableCameras;

      if (cameras.isNotEmpty) {
        _controller = CameraController(cameras[0], ResolutionPreset.medium);
        _controller!.initialize().then((_) {
          if (!mounted) {
            return;
          }
          setState(() {});
        });
      }
    });
  }

  Future<void> loadGameState() async {
    final db = DatabaseHelper();
    final gameState = await db.getGameStateinit();
    setState(() {
      top = gameState['top'];
      bottom = gameState['bottom'];
      updateGameStatus(); // Update the game status when loading
    });
  }

  Future<void> saveGameState() async {
    final db = DatabaseHelper();
    await db.saveGameState(top, bottom);
  }

  void updateGameStatus() {
    if ((top == 1 && bottom == 1) ||
        (top == 2 && bottom == 2) ||
        (top == 3 && bottom == 3)) {
      gameStatus = 'You Win!';
    } else {
      gameStatus = 'Try Again!';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'vazir'),
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Rock   Paper   Scissors',
            style: TextStyle(
              color: Colors.white,
              //fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          backgroundColor: Colors.blue,
          actions: [
            IconButton(
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
              onPressed: () async {
                await _auth.signOut();
              },
            ),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //Image.asset('images/$top.png'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipOval(
                        child: SizedBox.fromSize(
                            size: const Size.fromRadius(48), // Image radius
                            child: _img == null
                                ? Image.asset('images/cam.png',
                                    fit: BoxFit.cover)
                                : Image.file(_img!, fit: BoxFit.cover))),
                    Container(
                      width: 200,
                      height: 200,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Image.asset('images/$top.png'),
                      /*child: CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('images/$top.png'),
                        backgroundColor: Colors.white,
                      ),*/
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 29, 88, 136),
                        borderRadius:
                            BorderRadius.circular(10.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 8.0),
                      child: const Text(
                        'Player-1',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      top = Random().nextInt(3) + 1;
                      bottom = Random().nextInt(3) + 1;
                      saveGameState(); // Save the game state to the database
                      updateGameStatus();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    onPrimary: Colors.white,
                    elevation: 5, // Add a shadow
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Start Game',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Text(
                  gameStatus, // Display the game status
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: gameStatus == 'You Win!'
                        ? const Color.fromARGB(255, 25, 209, 31)
                        : const Color.fromARGB(255, 228, 22, 7),
                  ),
                ),
                //Image.asset('images/$bottom.png'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 50, // Adjust the size as needed
                      backgroundImage: AssetImage('images/user1.png'),
                      backgroundColor: Colors.white,
                    ),
                    const SizedBox(width: 8), // Add some spacing
                    Container(
                      width: 200,
                      height: 200,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Image.asset('images/$bottom.png'),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 29, 88, 136),
                        borderRadius:
                            BorderRadius.circular(10.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 8.0),
                      child: const Text(
                        'Player-2',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    LayoutBuilder(
                      builder: (context, constraints) {
                        if (constraints.maxWidth < 600) {
                          // For small screens, display buttons vertically
                          return Column(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  // Navigate to the DatabaseStatusPage
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const DatabaseStatusPage(),
                                    ),
                                  );
                                },
                                child: const Text("Old Records"),
                              ),

                              const SizedBox(width: 5),

// Capture Image Button
                              ElevatedButton(
                                onPressed: () async {
                                  if (_controller != null &&
                                      _controller!.value.isInitialized) {
                                    _img = File(
                                        (await _controller!.takePicture())
                                            .path);
                                    setState(() {});
                                    if (_img != null) {
                                      if (kDebugMode) {
                                        print('Captured the photo 1');
                                      }
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.blue,
                                  onPrimary: Colors.white,
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  'Capture Image',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                              const SizedBox(width: 5),

                              ElevatedButton(
                                onPressed: () {
                                  // Navigate to the UploadDataScreen
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const UploadDataScreen(),
                                    ),
                                  );
                                },
                                child: const Text("Save Online"),
                              ),
                            ],
                          );
                        } else {
                          // For larger screens, display buttons horizontally
                          return Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  // Navigate to the DatabaseStatusPage
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const DatabaseStatusPage(),
                                    ),
                                  );
                                },
                                child: const Text("Old Records"),
                              ),

                              const SizedBox(width: 5),
// Capture Image Button
                              ElevatedButton(
                                onPressed: () async {
                                  if (_controller != null &&
                                      _controller!.value.isInitialized) {
                                    _img = File(
                                        (await _controller!.takePicture())
                                            .path);
                                    setState(() {});
                                    if (_img != null) {
                                      if (kDebugMode) {
                                        print('Captured the photo 1');
                                      }
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.blue,
                                  onPrimary: Colors.white,
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  'Capture Image',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                              const SizedBox(width: 5),
// Save Online Button to send ofline data to firebase
                              ElevatedButton(
                                onPressed: () {
                                  // Navigate to the UploadDataScreen
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const UploadDataScreen(),
                                    ),
                                  );
                                },
                                child: const Text("Save Online"),
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// SQLite DB retriveing the data and display screen.

class DatabaseStatusPage extends StatelessWidget {
  const DatabaseStatusPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Database Status"),
        ),
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: DatabaseHelper().getGameState(), // Modify this line
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else {
              final gameStates = snapshot.data!;
              return ListView.builder(
                itemCount: gameStates.length,
                itemBuilder: (context, index) {
                  final gameState = gameStates[index];
                  return ListTile(
                    title: Text("ID: ${gameState['id']}"),
                    subtitle: Text(
                        "Top: ${gameState['top']}, Bottom: ${gameState['bottom']}"),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
