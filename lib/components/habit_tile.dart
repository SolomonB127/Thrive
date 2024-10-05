import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HabitTile extends StatelessWidget {
  final bool isCompleted;
  final String text;
  final void Function(bool?)? onChanged;
  final void Function(BuildContext)? onEdit;
  final void Function(BuildContext)? onDelete;
  const HabitTile(
      {super.key,
      required this.isCompleted,
      required this.text,
      required this.onChanged,
      required this.onEdit,
      required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 25.0),
      child: Slidable(
        endActionPane:
            ActionPane(motion: const StretchMotion(), children: <Widget>[
          // edit option
          SlidableAction(
            onPressed: onEdit,
            backgroundColor: Colors.grey.shade600,
            icon: Icons.settings,
            borderRadius: BorderRadius.circular(8),
          ),

          // delete option
          SlidableAction(
            onPressed: onDelete,
            backgroundColor: Colors.red,
            icon: Icons.delete,
            borderRadius: BorderRadius.circular(8),
          ),
        ]),
        child: GestureDetector(
          onTap: () {
            // toggle completion status
            if (onChanged != null) {
              onChanged!(!isCompleted);
            }
          },
          // habit tile
          child: Container(
            decoration: BoxDecoration(
                color: isCompleted
                    ? Colors.green
                    : Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.all(12),
            child: ListTile(
              // habit text
              title: Text(
                text,
                style: TextStyle(
                    color: isCompleted
                        ? Colors.white
                        : Theme.of(context).colorScheme.inversePrimary),
              ),
              leading: Checkbox(
                value: isCompleted,
                onChanged: onChanged,
                activeColor: Colors.green[600],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
