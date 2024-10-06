import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:thrive/components/drawer.dart';
import 'package:thrive/components/habit_tile.dart';
import 'package:thrive/database/habit_database.dart';
import 'package:thrive/models/habit.dart';
import 'package:thrive/utils/habit_util.dart';

import '../components/heat_map.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // read existing habit on app startup
    Provider.of<HabitDatabase>(context, listen: false).readHabits();
    super.initState();
  }

// check habit on/off if isCompleted
  void checkHabit(bool? value, Habit habit) {
    // update habit completion status
    if (value != null) {
      context.read<HabitDatabase>().updateHabitCompletion(habit.id, value);
    }
  }

  // Text Controller
  final TextEditingController textController = TextEditingController();
  // new habit method
  void createNewHabit() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: TextField(
                controller: textController,
                decoration:
                    const InputDecoration(hintText: "Create a new habit"),
              ),
              actions: <Widget>[
                // cancel button
                MaterialButton(
                  onPressed: () {
                    // pop box
                    Navigator.pop(context);

                    // clear controller
                    textController.clear();
                  },
                  child: const Text("Cancel"),
                ),

                // save button
                MaterialButton(
                  onPressed: () {
                    // get the new habit name
                    String newHabitName = textController.text;

                    // save to db
                    context.read<HabitDatabase>().addNewHabit(newHabitName);

                    // pop box
                    Navigator.pop(context);

                    // clear controller
                    textController.clear();
                  },
                  child: const Text("Save"),
                ),
              ],
            ));
  }

  // edit habit dialog
  void editHabit(Habit habit) {
    // set controllers text to habits current name
    textController.text = habit.name;

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: TextField(
                controller: textController,
              ),
              actions: <Widget>[
                // cancel button
                MaterialButton(
                  onPressed: () {
                    // pop box
                    Navigator.pop(context);

                    // clear controller
                    textController.clear();
                  },
                  child: const Text("Cancel"),
                ),

                // save button
                MaterialButton(
                  onPressed: () {
                    // get the new habit new name
                    String newHabitName = textController.text;

                    // save to db
                    context
                        .read<HabitDatabase>()
                        .updateHabitName(habit.id, newHabitName);

                    // pop box
                    Navigator.pop(context);

                    // clear controller
                    textController.clear();
                  },
                  child: const Text("Edit"),
                ),
              ],
            ));
  }

  // delete habit dialog
  void deleteHabit(Habit habit) {
    // set controllers text to habits current name
    textController.text = habit.name;

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Are you sure you want to delete"),
              actions: <Widget>[
                // cancel button
                MaterialButton(
                  onPressed: () {
                    // pop box
                    Navigator.pop(context);

                    // clear controller
                    textController.clear();
                  },
                  child: const Text("Cancel"),
                ),
                // save button
                MaterialButton(
                  onPressed: () {
                    // delete habit
                    context.read<HabitDatabase>().deleteHabit(habit.id);

                    // pop box
                    Navigator.pop(context);

                    // clear controller
                    textController.clear();
                  },
                  child: const Text("Delete"),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: Builder(builder: (context) {
          return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(Icons.menu));
        }),
      ),
      drawer: const MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewHabit,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
      body: ListView(
        children: <Widget>[
          // HEAT MAP
          _buildHeatMap(),
          // HABIT  LIST
          _buildHabitList(),
        ],
      ),
    );
  }

  // Heat map
  Widget _buildHeatMap() {
    // habit database
    final habitDb = context.watch<HabitDatabase>();

    // current habits
    List<Habit> currentHabit = habitDb.currentHabit;

    // return heatmap UI
    return FutureBuilder<DateTime?>(
        future: habitDb.getFirstLaunch(),
        builder: (context, snapshot) {
          // once date is available -> build heatma
          if (snapshot.hasData) {
            return HabitHeatMap(
                startDate: snapshot.data!,
                datasets: prepareHeatMapData(currentHabit));
          }
          // if no date is returned?
          else {
            return Container();
          }
        });
  }

  // Habit List
  Widget _buildHabitList() {
    // habit db
    final habitDb = context.watch<HabitDatabase>();

    // current habits
    List<Habit> currentHabits = habitDb.currentHabit;

    // return list of habits to UI
    return ListView.builder(
        itemCount: currentHabits.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          // get each individual habit
          final habit = currentHabits[index];

          // check if habit is completed or not
          bool isCompletedToday = isHabitCompletedToday(habit.completedDays);

          // return habit title to UI
          return HabitTile(
            isCompleted: isCompletedToday,
            text: habit.name,
            onChanged: (value) => checkHabit(value, habit),
            onEdit: (context) => editHabit(habit),
            onDelete: (context) => deleteHabit(habit),
          );
        });
  }
}
