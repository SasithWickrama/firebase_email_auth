import 'dart:math';
import 'package:flutter/foundation.dart';

enum GameResult { NotStarted, Win, TryAgain }

class GameController extends ChangeNotifier {
  int top = 1;
  int bottom = 2;
  GameResult gameResult = GameResult.NotStarted;

  void startGame() {
    top = Random().nextInt(3) + 1;
    if (kDebugMode) {
      print("top : $top");
    }
    bottom = Random().nextInt(3) + 1;
    if (kDebugMode) {
      print("bottom : $bottom");
    }
    if (isWinning()) {
      gameResult = GameResult.Win;
    } else {
      gameResult = GameResult.TryAgain;
    }

    notifyListeners(); // Notify listeners when the game state changes
  }

  bool isWinning() {
    if ((top == 1 && bottom == 1)||(top == 2 && bottom == 2)||(top == 3 && bottom == 3)) {
    return true;  
    }
    return false;
  }
}
