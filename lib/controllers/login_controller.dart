// lib/controllers/login_controller.dart
import 'package:flutter/material.dart';

class LoginController with ChangeNotifier {
  bool isAuthenticated = false;

  void login(String username, String password) {
    // Implement your authentication logic here
    // For demonstration, any username and password combination is accepted
    isAuthenticated = true;
    notifyListeners();
  }

  void logout() {
    isAuthenticated = false;
    notifyListeners();
  }
}
