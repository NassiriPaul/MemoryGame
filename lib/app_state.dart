import 'package:flutter/material.dart';
class AppState with ChangeNotifier {
  bool _isLocked = true;

  bool get isLocked => _isLocked;

  void unlock() {
    _isLocked = false;
    notifyListeners();
  }

  void lock() {
    _isLocked = true;
    notifyListeners();
  }
}