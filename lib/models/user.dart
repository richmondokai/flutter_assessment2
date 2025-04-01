import 'dart:convert';
import 'package:equatable/equatable.dart';

/// Represents a user in the system with relevant details.
class User extends Equatable {
  final int id;
  final String name;
  final String email;
  final String avatarAsset;
  final String role;
  final String department;
  final String location;
  final DateTime joinDate;
  final bool isActive;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.avatarAsset,
    required this.role,
    required this.department,
    required this.location,
    required this.joinDate,
    required this.isActive,
  });

  /// Creates a copy of the user with optional modified fields.
  User copyWith({
    int? id,
    String? name,
    String? email,
    String? avatarAsset,
    String? role,
    String? department,
    String? location,
    DateTime? joinDate,
    bool? isActive,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarAsset: avatarAsset ?? this.avatarAsset,
      role: role ?? this.role,
      department: department ?? this.department,
      location: location ?? this.location,
      joinDate: joinDate ?? this.joinDate,
      isActive: isActive ?? this.isActive,
    );
  }

  /// Converts a Map into a User object.
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id:
          map['id'] is int
              ? map['id']
              : int.tryParse(map['id'].toString()) ?? 0,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      avatarAsset: map['avatarAsset'] ?? map['avatar'] ?? '',
      role: map['role'] ?? 'Viewer',
      department: map['department'] ?? '',
      location: map['location'] ?? '',
      joinDate:
          map['joinDate'] != null
              ? DateTime.tryParse(map['joinDate'].toString()) ??
                  DateTime(2000, 1, 1)
              : DateTime(2000, 1, 1),
      isActive:
          map['isActive'] is bool
              ? map['isActive']
              : (map['isActive'].toString().toLowerCase() == 'true'),
    );
  }

  /// Converts a User object into a Map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatarAsset': avatarAsset,
      'role': role,
      'department': department,
      'location': location,
      'joinDate': joinDate.toIso8601String(),
      'isActive': isActive,
    };
  }

  /// Converts a JSON string into a User object.
  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  /// Converts a User object into a JSON string.
  String toJson() => json.encode(toMap());

  /// Required for Equatable (simplifies object comparison).
  @override
  List<Object?> get props => [
    id,
    name,
    email,
    avatarAsset,
    role,
    department,
    location,
    joinDate,
    isActive,
  ];
}
