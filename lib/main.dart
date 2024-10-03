import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thrive/database/habit_database.dart';
import 'package:thrive/theme/theme_provider.dart';

import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // initialize database
  await HabitDatabase.initialize();
  await HabitDatabase().firstLaunch();
  runApp(
    MultiProvider(
      providers: [
        // habit provider
        ChangeNotifierProvider(create: (context) => HabitDatabase()),
        // theme provider
        ChangeNotifierProvider(create: (context) => ThemeProvider())
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
