import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/user_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/home_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: Builder(
        builder: (context) => const MyApp(),
      ), // ✅ Safe context usage
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'User Management Dashboard',
          themeMode: themeProvider.themeMode, // ✅ Dynamic theme
          theme: ThemeData.light().copyWith(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            appBarTheme: const AppBarTheme(centerTitle: true, elevation: 2),
            cardTheme: CardTheme(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            ),
          ),
          darkTheme: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            appBarTheme: const AppBarTheme(centerTitle: true, elevation: 2),
          ),
          home: const HomePage(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
