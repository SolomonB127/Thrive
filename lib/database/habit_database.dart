import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:thrive/models/app_settings.dart';
import 'package:thrive/models/habit.dart';

class HabitDatabase extends ChangeNotifier {
  static late Isar isar;

  /*
  SETUP
  -------------------------------------------------------------------
  */

  // Initialize Database
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar =
        await Isar.open([HabitSchema, AppSettingsSchema], directory: dir.path);
  }

  // Save first date of app startup - for heatmap
  Future<void> firstLaunch() async {
    final existingSettings = await isar.appSettings.where().findFirst();
    if (existingSettings == null) {
      final settings = AppSettings()..firstLaunchDate = DateTime.now();
      await isar.writeTxn(() => isar.appSettings.put(settings));
    }
  }

  // Get first date of app startup - for heatmap
  Future<DateTime?> getFirstLaunch() async {
    final getSettings = await isar.appSettings.where().findFirst();
    return getSettings?.firstLaunchDate;
  }

  /*
  CRUD X Operations
  -------------------------------------------------------------------
  */
  // List of Habits
  final List<Habit> currentHabit = [];

  // Create - add a new habit
  Future<void> addNewHabit(String habitName) async {
    // create new habit
    final newHabit = Habit()..name = habitName;

    // save to db
    await isar.writeTxn(() => isar.habits.put(newHabit));

    // re-read from db
    readHabits();
  }

  // Read - read saved habit from the db
  Future<void> readHabits() async {
    // fetch all habits from db
    List<Habit> fetchedHabits = await isar.habits.where().findAll();

    // give to current habit
    currentHabit.clear();
    currentHabit.addAll(fetchedHabits);

    // update UI

    notifyListeners();
  }

  // Update - check habit on/off
  Future<void> updateHabitCompletion(int id, bool isCompleted) async {
    // find specified  habit
    final habit = await isar.habits.get(id);

    // update completion status
    if (habit != null) {
      await isar.writeTxn(() async {
        // if habit is completed -> add current date to Completed days list
        if (isCompleted && !habit.completedDays.contains(DateTime.now())) {
          final today = DateTime.now();

          // add to completed days, if not already there
          habit.completedDays.add(DateTime(today.year, today.month, today.day));
        }
        // else: remove current date from list
        else {
          // remove current date if habit is marked as completed
          habit.completedDays.removeWhere((date) =>
              date.year == DateTime.now().year &&
              date.month == DateTime.now().month &&
              date.day == DateTime.now().day);
        }
        // save updated habits back to db
        await isar.habits.put(habit);
      });
    }
    // re-read from db
    readHabits();
  }

  // Update - update habit name
  Future<void> updateHabitName(int id, String newName) async {
    // find specific habit
    final habit = await isar.habits.get(id);

    // update habit name
    if (habit != null) {
      await isar.writeTxn(() async {
        habit.name = newName;

        // save updated name to db
        await isar.habits.put(habit);
      });
    }
    // re-read from db
    readHabits();
  }

  // Delete - delete selected habit
  Future<void> deleteHabit(int id) async {
    // delete habit
    await isar.writeTxn(() async {
      await isar.habits.delete(id);
    });

    // re-read from db
    readHabits();
  }
}
