// lib/models/user_model.dart

import 'package:shared_preferences/shared_preferences.dart';

class UserModel {
  String firstName;
  String lastName;
  String username;
  String userType; // "owner" or "seeker"

  UserModel({
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.userType,
  });

  // Static variable to hold the current user
  static UserModel? _currentUser;

  // Getter for the current user
  static UserModel? get currentUser => _currentUser;

  // Setter to update the current user
  static void setUser(UserModel user) {
    _currentUser = user;
    _saveUserToPreferences(user);
  }

  // Method to clear the current user
  static void clearUser() {
    _currentUser = null;
    _clearUserFromPreferences();
  }

  // Save the current user data to SharedPreferences
  static Future<void> _saveUserToPreferences(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('firstName', user.firstName);
    prefs.setString('lastName', user.lastName);
    prefs.setString('username', user.username);
    prefs.setString('userType', user.userType);
  }

  // Clear the user data from SharedPreferences
  static Future<void> _clearUserFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('firstName');
    prefs.remove('lastName');
    prefs.remove('username');
    prefs.remove('userType');
  }

  // Load user data from SharedPreferences
  static Future<void> loadUserFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final firstName = prefs.getString('firstName') ?? '';
    final lastName = prefs.getString('lastName') ?? '';
    final username = prefs.getString('username') ?? '';
    final userType = prefs.getString('userType') ?? '';

    if (firstName.isNotEmpty && lastName.isNotEmpty && username.isNotEmpty && userType.isNotEmpty) {
      _currentUser = UserModel(
        firstName: firstName,
        lastName: lastName,
        username: username,
        userType: userType,
      );
    }
  }
}
