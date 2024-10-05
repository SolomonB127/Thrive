import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thrive/theme/theme_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Container(
        decoration: BoxDecoration(
            color: Colors.grey[800], borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
        margin: const EdgeInsets.only(top: 10),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text(
                "Dark Mode",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              CupertinoSwitch(
                  value: Provider.of<ThemeProvider>(context).isDarkMode,
                  onChanged: (value) =>
                      Provider.of<ThemeProvider>(context, listen: false)
                          .toggleTheme())
            ]),
      ),
    );
  }
}
