import 'package:flutter/material.dart';

class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  bool notifications = true;
  bool darkMode = false;
  bool locationAccess = true;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 20),

        const Text(
          'Settings',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 25),

        SwitchListTile(
          title: const Text('Notifications'),
          subtitle: const Text('Dummy toggle button'),
          value: notifications,
          onChanged: (value) {
            setState(() {
              notifications = value;
            });
          },
        ),

        SwitchListTile(
          title: const Text('Dark Mode'),
          subtitle: const Text('Dummy toggle button'),
          value: darkMode,
          onChanged: (value) {
            setState(() {
              darkMode = value;
            });
          },
        ),

        SwitchListTile(
          title: const Text('Location Access'),
          subtitle: const Text('Dummy toggle button'),
          value: locationAccess,
          onChanged: (value) {
            setState(() {
              locationAccess = value;
            });
          },
        ),
      ],
    );
  }
}