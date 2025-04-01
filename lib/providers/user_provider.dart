import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user.dart';

class UserProvider with ChangeNotifier {
  List<User> _users = [];
  String _searchQuery = '';
  String _filterStatus = 'All';

  List<User> get users => _filteredUsers;
  String get searchQuery => _searchQuery;
  String get filterStatus => _filterStatus;

  List<User> get _filteredUsers {
    return _users.where((user) {
      final matchesSearch =
          user.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          user.email.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesStatus =
          _filterStatus == 'All' ||
          (_filterStatus == 'Active' && user.isActive) ||
          (_filterStatus == 'Inactive' && !user.isActive);

      return matchesSearch && matchesStatus;
    }).toList();
  }

  /// Loads users from memory or API
  void loadUsers(List<User> users) {
    _users = users;
    saveUsersToPrefs();
    notifyListeners();
  }

  /// Loads users from Shared Preferences
  Future<void> loadUsersFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final String? storedUsers = prefs.getString('users');
    if (storedUsers != null) {
      final List<dynamic> userList = json.decode(storedUsers);
      _users = userList.map((userMap) => User.fromMap(userMap)).toList();
      notifyListeners();
    }
  }

  /// Saves users to Shared Preferences
  Future<void> saveUsersToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final String usersJson = json.encode(
      _users.map((user) => user.toMap()).toList(),
    );
    await prefs.setString('users', usersJson);
  }

  /// Adds a new user and ensures unique ID
  void addUser(User user) {
    final newId =
        _users.isEmpty
            ? 1
            : (_users.map((u) => u.id).reduce((a, b) => a > b ? a : b) + 1);
    _users.add(user.copyWith(id: newId));
    saveUsersToPrefs();
    notifyListeners();
  }

  /// Updates an existing user
  void updateUser(User updatedUser) {
    final index = _users.indexWhere((u) => u.id == updatedUser.id);
    if (index != -1) {
      _users[index] = updatedUser;
      saveUsersToPrefs();
      notifyListeners();
    }
  }

  /// Deletes a user after confirmation
  void deleteUser(int userId) {
    _users.removeWhere((user) => user.id == userId);
    saveUsersToPrefs();
    notifyListeners();
  }

  /// Sets the search query
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  /// Sets the user filter status
  void setFilterStatus(String status) {
    _filterStatus = status;
    notifyListeners();
  }
}
