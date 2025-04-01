import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';

class UserProfile extends StatelessWidget {
  final User user;
  final VoidCallback onEdit;
  final VoidCallback onBack;

  const UserProfile({
    super.key,
    required this.user,
    required this.onEdit,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
        ),
        title: Text(user.name),
        actions: [
          IconButton(icon: const Icon(Icons.edit), onPressed: onEdit),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage(user.avatarAsset),
              ),
            ),
            const SizedBox(height: 24),
            _buildProfileItem(context, 'Name', user.name),
            _buildProfileItem(context, 'Email', user.email),
            _buildProfileItem(context, 'Role', user.role),
            _buildProfileItem(context, 'Department', user.department),
            _buildProfileItem(context, 'Location', user.location),
            _buildProfileItem(context, 'Join Date', _formatDate(user.joinDate)),
            _buildProfileItem(
              context,
              'Status',
              user.isActive ? 'Active' : 'Inactive',
              isActive: user.isActive,
            ),
          ],
        ),
      ),
    );
  }

  /// Formats the date for display
  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  /// Builds profile items with dynamic theming
  Widget _buildProfileItem(
    BuildContext context,
    String label,
    String value, {
    bool? isActive,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: theme.textTheme.bodySmall?.color ?? Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          isActive != null
              ? Chip(
                label: Text(value),
                backgroundColor: isActive ? Colors.green[50] : theme.cardColor,
                labelStyle: TextStyle(
                  color:
                      isActive
                          ? Colors.green
                          : theme.textTheme.bodyLarge?.color,
                ),
              )
              : Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
        ],
      ),
    );
  }

  /// Shows a confirmation dialog before deleting a user
  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirm Deletion'),
            content: const Text('Are you sure you want to delete this user?'),
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
                  onBack(); // Go back after deletion
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
