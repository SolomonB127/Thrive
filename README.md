# Documentation: Thrive Habit Tracker Application
## Overview

The **Thrive Habit Tracker** application is a Flutter-based app that allows users to manage their daily habits using a local database **(Isar)** for persistence and state management using **Provider**. The app includes a dynamic UI with light and dark themes, habit tracking with completion status, and a heatmap to visualize habit completion over time.

This documentation provides a comprehensive breakdown of the application's components, structure, and functionality.

## Table of Contents
1. **Getting Started**
2. **Project Structure**
3. **Main Application Flow**
4. **Theme Management**
5. **Habit Management**
6. **Home Page**
7. **Drawer and Settings**
8. **Habit Tile**
9. **Heatmap Overview**
10. **Database Operations**
11. **Helper Functions**
12. **Demo Video and Screenshots**
13. **Contributing**
14. **Conclusions**
15. **License**

## Getting Started

### Prerequisites

- Flutter SDK
- Dart
- Android Studio or Visual Studio Code

# Installation
```
git clone https://github.com/SolomonB127/Thrive.git
cd Thrive
flutter pub get
flutter run
```

# Project Structure
```
lib
│
├── components/                         # Reusable UI components
│   ├── drawer.dart                     # Drawer UI for navigation
│   ├── drawer_tile.dart              # Drawer tile component
│   ├── habit_tile.dart                 # Habit tile UI component
│   └── heat_map.dart                 # Habit heatmap UI component
│
├── models/                                 # Data models
│   ├── habit.dart                        # Habit model schema
│   └── app_settings.dart           # App settings schema (for first launch date)
│
├── pages/                                  # Application pages
│   ├── home_page.dart              # Main home page for habit management
│   └── settings_page.dart        # Settings page for theme toggle
│
├── theme/                                # Theme management
│   ├── dark_mode.dart            # Dark mode theme settings
│   ├── light_mode.dart           # Light mode theme settings
│   └── theme_provider.dart  # Provider to manage theme toggling
│
├── database/                        # Database operations (Isar)
│   └── habit_database.dart # Database handler for habits and app settings
│ 
│
├── utils/                             # Helper Function
│   └── habit_util.dart        # Function handler for habits completion status
│
└── main.dart                     # Main entry point of the application
```

## Main Application Flow

1,  **Main Entry Point** -  `main.dart`

The main.dart file initializes the application, including the **Isar database** and providers for both **habit management** and **theme management**. The app runs the MainApp which sets up the MaterialApp with the current theme and loads the HomePage.

Key operations in main.dart:

-**Database Initialization**: The Isar database is initialized using HabitDatabase.initialize().

-**First Launch**: The first launch date of the app is recorded in the database using firstLaunch().

-**MultiProvider Setup:**: The MultiProvider widget wraps the app, providing instances of HabitDatabase and ThemeProvider to the widget tree.

# Theme Management
### `ThemeProvider`
The ThemeProvider class handles the toggling between **light mode** and **dark mode**. It uses a ChangeNotifier to notify listeners about theme changes, which allows dynamic theme switching across the app.

- **Current Theme:** The current theme is stored in _themeData. The default theme is **lightMode**.

- **Toggle Theme:** The toggleTheme() method switches between lightMode and darkMode.
```dart
class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = lightMode;

  ThemeData get themeData => _themeData;
  bool get isDarkMode => _themeData == darkMode;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    themeData = isDarkMode ? lightMode : darkMode;
  }
}
```
# Habit Management
### `HabitDatabase`
The HabitDatabase class manages all the operations related to habits using the **Isar** database. It includes **CRUD** operations for creating, reading, updating, and deleting habits, as well as managing the app's first launch date for the heatmap.

- **Initialization:** The database is initialized with the HabitSchema and AppSettingsSchema.

- **CRUD Operations:**
    - **Add New Habit**: Adds a habit to the database using the addNewHabit() method.
    - **Read Habits**: Fetches all habits from the database with readHabits().
    - **Update Habit Completion**: Toggles the habit's completion status for the day using updateHabitCompletion().
    - **Update Habit Name**: Edits the habit name using updateHabitName().
    - **Delete Habit**: Deletes a habit from the database using deleteHabit().

# Home Page
### `HomePage`
The HomePage is the central screen of the application. It displays a list of habits and a **heatmap** to track habit completion over time. Users can create, edit, and delete habits via dialogs.

- **Habit List:** TThe list of current habits is displayed using ListView.builder(). Each habit is represented by a HabitTile widget.

- **Heatmap:** The heatmap visualization is built using the HabitHeatMap widget, which takes the habit completion data and displays it in a heatmap format.

# Drawer and Settings
### `MyDrawer`
The MyDrawer widget provides navigation for the user. It includes links to the home page and the settings page where users can toggle **dark mode**.
```dart
class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: Theme.of(context).colorScheme.surface,
        child: Column(
          children: <Widget>[
            const DrawerHeader(child: Icon(Icons.upgrade)),
            ...[
              DrawerTile(
                  title: "Tracks",
                  leading: const Icon(Icons.home),
                  onTap: () => Navigator.pop(context)),
              DrawerTile(
                  title: "Settings",
                  leading: const Icon(Icons.settings),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const SettingsPage()));
                  })
            ]
          ],
        ));
  }
}
```
### `SettingsPage`
The SettingsPage allows users to toggle between **light mode** and **dark mode** using a CupertinoSwitch.
```dart
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text("Dark Mode", style: TextStyle(fontWeight: FontWeight.bold)),
              CupertinoSwitch(
                  value: Provider.of<ThemeProvider>(context).isDarkMode,
                  onChanged: (value) =>
                      Provider.of<ThemeProvider>(context, listen: false).toggleTheme())
            ]),
      ),
    );
  }
}
```
# Habit Tile
### `HabitTile`
The HabitTile widget represents an individual habit in the list. It allows the user to:

- **Mark the habit as completed** for the day using a checkbox.
- **Edit** the habit name.
- **Delete** the habit.

The Slidable widget is used to provide swipe-based actions for editing and deleting.

# Heatmap Overview
### `HabitHeatMap`
The HabitHeatMap widget displays a heatmap of habit completion over time, using the flutter_heatmap_calendar package. The heatmap is a visual representation of how consistently the user has completed their habits.


# Database Operations
### `Habit Model`
The Habit model defines the schema for habits stored in the Isar database.

```dart
@Collection()
class Habit {
  Id id = Isar.autoIncrement;
  late String name;
  List<DateTime> completedDays = [];
}
```
### `App Settings Model`
The AppSettings model stores app-specific settings, such as the first launch date, which is used for generating the heatmap.
```dart
@Collection()
class AppSettings {
  Id id = Isar.autoIncrement;
  DateTime? firstLaunchDate;
}
```

# Helper Functions
### `isHabitCompletedToday`
This function checks if a habit has been completed today. It takes a list of completed days and compares them to the current date.
```dart
/*
  given a habit list of completed days -> is the habit completed today
*/


import '../models/habit.dart';

bool isHabitCompletedToday(List<DateTime> completedDays) {
  final today = DateTime.now();
  return completedDays.any((date) =>
      date.year == today.year &&
      date.month == today.month &&
      date.day == today.day);
}

// Prepare heatmap data set
Map<DateTime, int> prepareHeatMapData(List<Habit> habits) {
  Map<DateTime, int> dataSet = {};

  for (var habit in habits) {
    for (var date in habit.completedDays) {
      // normalize data to avoid time mismatch
      final dateTimeFormat = DateTime(date.year, date.month, date.day);

      // if date already exist in dataset, increment count
      if (dataSet.containsKey(dateTimeFormat)) {
        dataSet[dateTimeFormat] = dataSet[dateTimeFormat]! + 1;
      } else {
        // else initialize with a count of 1
        dataSet[dateTimeFormat] = 1;
      }
    }
  }
  return dataSet;
}
```

# Demo Video and Screenshots

- **Demo Video:** A walkthrough of the app showcasing navigation and features. 
[Watch the demo video](assets/video/Thrive_demo_vid.mp4)

## Light Mode
- **Screenshots:**

Home Page,

![Home Page](/assets/screenshots/Homepage.png)

  *Screenshot showing the Home Page*

Side Bar, 

![Side Bar](/assets/screenshots/Side_bar.png)

  *Screenshot showing the Side Menu*

Side panel,

![Side Panel](/assets/screenshots/Sidepanel.png)

  *Screenshot showing the Sidepanel*


![Dialog](/assets/screenshots/Create_Dialog.png)

  *Screenshot showing  the Dialog Textfield*

## Dark Mode
Note Page,

![Home Page](/assets/screenshots/Darkmode_Home.png)

  *Screenshot showing the Home Page*

Side Bar, 

![Side Bar](/assets/screenshots/Darkmode_Sidebar.png)

  *Screenshot showing the Side Menu*

Side Panel,

![Side-Panel](/assets/screenshots/Darkmode_sidepanel.png)

  *Screenshot showing the Pop-up*


![Dialog](/assets/screenshots/Darkmode_create_dialog.png)

  *Screenshot showing  the Dialog Textfield*


## Contributing
Contributions are welcome! Please follow these steps:

1. Fork the repository.
2. Create a new branch.
3. Make your changes.
4. Submit a pull request.

## Conclusion
The **Thrive Habit Tracker** application is a well-structured habit-tracking tool using Flutter. The combination of **Isar** for local persistence and **Provider** for state management ensures a smooth user experience. With features like habit tracking, heatmap visualizations, and dynamic theming, the app provides a robust platform for users to build and maintain their habits.

## License
This project is licensed under the MIT License. See the LICENSE file for details.