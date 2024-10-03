import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thrive/components/drawer.dart';
import 'package:thrive/database/habit_database.dart';
import 'package:thrive/models/habit.dart';
import 'package:thrive/utils/habit_util.dart';

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

  // Text Controller
  final textController = TextEditingController();
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

                // cancel button
                MaterialButton(
                  onPressed: () {
                    // pop box
                    Navigator.pop(context);

                    // clear controller
                    textController.clear();
                  },
                  child: const Text("Cancel"),
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
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
        child: const Icon(Icons.add),
      ),
      body: _buildHabitList(),
    );
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
        itemBuilder: (context, index) {
          // get each individual habit
          final habit = currentHabits[index];

          // check if habit is completed or not
          bool isCompletedToday = isHabitCompletedToday(habit.completedDays);

          // return habit title to UI
          return ListTile(
            title: Text(habit.name),
          );
        });
  }
}
