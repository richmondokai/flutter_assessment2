import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:component_assessment/providers/user_provider.dart';
import 'package:component_assessment/screens/home_page.dart';
import 'package:component_assessment/screens/dashboard.dart';
import 'package:component_assessment/models/user.dart';

void main() {
  testWidgets('App loads and displays dashboard', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<UserProvider>(
        create: (context) => UserProvider(),
        child: const MaterialApp(home: HomePage()),
      ),
    );

    // Verify Dashboard appears
    expect(find.byType(UserDashboard), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });

  testWidgets('Theme toggle works', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<UserProvider>(
        create: (context) => UserProvider(),
        child: MaterialApp(
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: ThemeMode.light, // Initial theme mode
          home: const HomePage(),
        ),
      ),
    );

    // Find and tap the theme toggle button (Assuming it's an IconButton)
    final themeToggleButton = find.byIcon(Icons.brightness_6);
    expect(themeToggleButton, findsOneWidget);

    await tester.tap(themeToggleButton);
    await tester.pump();

    // Verify that the theme has changed
    expect(
      Theme.of(tester.element(themeToggleButton)).brightness,
      Brightness.dark,
    );
  });

  testWidgets('User deletion shows confirmation dialog', (
    WidgetTester tester,
  ) async {
    final userProvider = UserProvider();
    userProvider.loadUsers([
      User(
        id: 1,
        name: "Test User",
        email: "test@example.com",
        avatarAsset: "assets/avatar.png",
        role: "Admin",
        department: "IT",
        location: "Remote",
        joinDate: DateTime(2024, 1, 1),
        isActive: true,
      ),
    ]);

    await tester.pumpWidget(
      ChangeNotifierProvider<UserProvider>.value(
        value: userProvider,
        child: MaterialApp(home: HomePage()),
      ),
    );

    // Find and tap the delete button
    final deleteButton = find.byIcon(Icons.delete);
    expect(deleteButton, findsOneWidget);

    await tester.tap(deleteButton);
    await tester.pump();

    // Expect the confirmation dialog to appear
    expect(find.text('Confirm Deletion'), findsOneWidget);
    expect(
      find.text('Are you sure you want to delete this user?'),
      findsOneWidget,
    );
  });
}
