import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/user_list.dart';
import '../widgets/user_profile.dart';
import '../providers/user_provider.dart';
import '../models/user.dart';
import '../widgets/user_form.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  User? _selectedUser;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500), // Smooth transition
      transitionBuilder: (widget, animation) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(scale: animation, child: widget),
        );
      },
      child:
          _selectedUser == null
              ? UserList(
                key: const ValueKey('user_list'),
                onSelectUser: (user) => setState(() => _selectedUser = user),
              )
              : UserProfile(
                user: _selectedUser!,
                onEdit: () => _handleEditUser(context, _selectedUser!),
                onBack: () => setState(() => _selectedUser = null),
              ),
    );
  }

  void _handleEditUser(BuildContext context, User user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder:
          (context) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: UserForm(
              initialData: user,
              onSubmit: (updatedUser) {
                Provider.of<UserProvider>(
                  context,
                  listen: false,
                ).updateUser(updatedUser);
                setState(() => _selectedUser = updatedUser);
                Navigator.pop(context);
              },
              onCancel: () => Navigator.pop(context),
            ),
          ),
    );
  }
}
