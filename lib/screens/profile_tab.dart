import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'edit_profile_screen.dart';
import 'apps_screen.dart';
import 'documents_screen.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  String username = '';
  String email = '';
  String phone = '';
  String bio = '';
  String instagram = '';
  String github = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    final data = doc.data();

    setState(() {
      email = user.email ?? data?['email'] ?? '';
      username = data?['username'] ?? 'No username';
      phone = data?['phone'] ?? '';
      bio = data?['bio'] ?? '';
      instagram = data?['instagram'] ?? '';
      github = data?['github'] ?? '';
      isLoading = false;
    });
  }

  Future<void> openEditProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EditProfileScreen(),
      ),
    );

    if (result == true) {
      setState(() {
        isLoading = true;
      });

      await loadProfile();
    }
  }

  Widget buildInfoRow(IconData icon, String text) {
    if (text.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.blue, size: 22),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 20),

          const CircleAvatar(
            radius: 60,
            backgroundImage: NetworkImage(
              'https://i.pravatar.cc/150?img=14',
            ),
          ),

          const SizedBox(height: 20),

          Text(
            username,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            email,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 20),

          buildInfoRow(Icons.phone, phone),
          buildInfoRow(Icons.info, bio),
          buildInfoRow(Icons.camera_alt, instagram),
          buildInfoRow(Icons.code, github),

          const SizedBox(height: 25),

          SizedBox(
            width: 250,
            height: 50,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onPressed: openEditProfile,
              icon: const Icon(Icons.edit, color: Colors.white),
              label: const Text(
                'Edit Profile',
                style: TextStyle(color: Colors.white, fontSize: 17),
              ),
            ),
          ),

          const SizedBox(height: 15),

          SizedBox(
            width: 250,
            height: 50,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DocumentsScreen(),
                  ),
                );
              },
              icon: const Icon(
                Icons.folder,
                color: Colors.white,
              ),
              label: const Text(
                'My Documents',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                ),
              ),
            ),
          ),

          const SizedBox(height: 15),

          SizedBox(
            width: 250,
            height: 50,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AppsScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.download, color: Colors.white),
              label: const Text(
                'Go to Apps',
                style: TextStyle(color: Colors.white, fontSize: 17),
              ),
            ),
          ),
        ],
      ),
    );
  }
}