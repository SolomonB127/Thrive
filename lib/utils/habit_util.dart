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
