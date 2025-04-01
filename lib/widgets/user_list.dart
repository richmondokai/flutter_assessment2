import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import 'user_card.dart';
import '../widgets/user_form.dart';
import '../models/user.dart';

class UserList extends StatelessWidget {
  final Function(User) onSelectUser; // Added callback function

  const UserList({super.key, required this.onSelectUser});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Search users',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: userProvider.setSearchQuery,
                ),
              ),
              const SizedBox(width: 16),
              DropdownButton<String>(
                value: userProvider.filterStatus,
                items:
                    ['All', 'Active', 'Inactive'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                onChanged: (value) => userProvider.setFilterStatus(value!),
              ),
            ],
          ),
        ),
        Expanded(
          child:
              userProvider.users.isEmpty
                  ? const Center(
                    child: Text(
                      'No users found',
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                  : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 16),
                    itemCount: userProvider.users.length,
                    itemBuilder: (context, index) {
                      final user = userProvider.users[index];
                      return UserCard(
                        user: user,
                        onViewProfile:
                            () => onSelectUser(user), // Pass selected user
                        onEdit: () => _handleEditUser(context, user),
                        onDelete: () => _handleDeleteUser(context, user),
                      );
                    },
                  ),
        ),
      ],
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
                Navigator.pop(context);
              },
              onCancel: () => Navigator.pop(context),
            ),
          ),
    );
  }

  void _handleDeleteUser(BuildContext context, User user) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete User'),
            content: Text('Are you sure you want to delete ${user.name}?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Provider.of<UserProvider>(
                    context,
                    listen: false,
                  ).deleteUser(user.id);
                  Navigator.pop(context);
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }
}
