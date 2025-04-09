import 'package:flutter/material.dart';

class ProgressProvider with ChangeNotifier {
  double _progress = 0.0;

  double get progress => _progress;

  void increaseProgress() {
    if (_progress < 100) {
      _progress += 40;
      notifyListeners();
    }
  }

  void decreaseProgress() {
    if (_progress > 0) {
      _progress -= 40;
      notifyListeners();
    }
  }

  void resetProgress() {
    _progress = 40;
    notifyListeners();
  }
}