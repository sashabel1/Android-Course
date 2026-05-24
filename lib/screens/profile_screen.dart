import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 60,
            backgroundImage: NetworkImage(
              'https://i.pravatar.cc/150?img=14',
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Daniel Chernov And Sasha Belkind',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const Text(
            'Android Developer',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.message),
                label: const Text('Message'),
              ),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.call),
                label: const Text('Call'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}