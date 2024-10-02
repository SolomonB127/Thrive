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

  // Create - add a new habit

  // Read - read saved habit from the db

  // Update - check habit on/off

  // Update - update habit name

  // Delete - delete selected habit
}
