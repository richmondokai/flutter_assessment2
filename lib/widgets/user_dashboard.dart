import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class UserDashboard extends StatelessWidget {
  const UserDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final users = userProvider.users;

    return users.isEmpty
        ? const Center(
          child: Text(
            'No users available. Add a new user!',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        )
        : ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage(user.avatarAsset),
                ),
                title: Text(user.name),
                subtitle: Text('${user.role} - ${user.department}'),
                trailing: Icon(
                  user.isActive ? Icons.check_circle : Icons.cancel,
                  color: user.isActive ? Colors.green : Colors.red,
                ),
                onTap: () {
                  // Handle user selection or navigation
                },
              ),
            );
          },
        );
  }
}
