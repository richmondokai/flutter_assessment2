import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../providers/theme_provider.dart'; // Import ThemeProvider
import 'dashboard.dart';
import '../models/user.dart';
import '../widgets/user_form.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final themeProvider = Provider.of<ThemeProvider>(
      context,
      listen: false,
    ); // Access ThemeProvider

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (userProvider.users.isEmpty) {
        final initialUsers = [
          User(
            id: 1,
            name: 'John Doe',
            email: 'john@example.com',
            avatarAsset: 'assets/image1.jpg',
            role: 'Admin',
            department: 'IT',
            location: 'New York',
            joinDate: DateTime(2020, 1, 15),
            isActive: true,
          ),
          User(
            id: 2,
            name: 'Jane Smith',
            email: 'jane@example.com',
            avatarAsset: 'assets/image3.jpg',
            role: 'Editor',
            department: 'Content',
            location: 'Los Angeles',
            joinDate: DateTime(2021, 3, 20),
            isActive: true,
          ),
          User(
            id: 3,
            name: 'Bob Johnson',
            email: 'bob@example.com',
            avatarAsset: 'assets/image2.jpg',
            role: 'Viewer',
            department: 'Marketing',
            location: 'Chicago',
            joinDate: DateTime(2019, 11, 5),
            isActive: false,
          ),
          User(
            id: 4,
            name: 'Sara Williams',
            email: 'sara@example.com',
            avatarAsset: 'assets/image4.jpg',
            role: 'Editor',
            department: 'Design',
            location: 'Seattle',
            joinDate: DateTime(2022, 5, 10),
            isActive: true,
          ),
          User(
            id: 5,
            name: 'Mike Brown',
            email: 'mike@example.com',
            avatarAsset: 'assets/image5.jpg',
            role: 'Viewer',
            department: 'Sales',
            location: 'Boston',
            joinDate: DateTime(2021, 8, 15),
            isActive: false,
          ),
        ];
        userProvider.loadUsers(initialUsers);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Dashboard'),
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.themeMode == ThemeMode.dark
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
      body: const UserDashboard(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddUserForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddUserForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder:
          (context) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: UserForm(
              onSubmit: (user) {
                Provider.of<UserProvider>(context, listen: false).addUser(user);
                Navigator.pop(context);
              },
              onCancel: () => Navigator.pop(context),
            ),
          ),
    );
  }
}
