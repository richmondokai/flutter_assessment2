import 'package:flutter/material.dart';
import '../models/user.dart';

class UserCard extends StatelessWidget {
  final User user;
  final VoidCallback onViewProfile;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const UserCard({
    super.key,
    required this.user,
    required this.onViewProfile,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: _getAvatarImage(user.avatarAsset),
                  onBackgroundImageError:
                      (_, __) => const AssetImage('assets/background.jpg'),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        user.email,
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Chip(
                            label: Text(user.role),
                            backgroundColor: Colors.blue[50],
                          ),
                          const SizedBox(width: 8),
                          Chip(
                            label: Text(user.isActive ? 'Active' : 'Inactive'),
                            backgroundColor:
                                user.isActive
                                    ? Colors.green[50]
                                    : Colors.grey[200],
                            labelStyle: TextStyle(
                              color:
                                  user.isActive
                                      ? Colors.green[700]
                                      : Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: onDelete,
                  tooltip: 'Delete User',
                ),
                OutlinedButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit'),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: onViewProfile,
                  icon: const Icon(Icons.person),
                  label: const Text('Profile'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  ImageProvider _getAvatarImage(String avatarAsset) {
    if (avatarAsset.isNotEmpty) {
      return AssetImage(avatarAsset);
    }
    return const AssetImage('assets/background.jpg');
  }
}
