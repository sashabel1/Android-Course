import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({super.key});

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  bool isSaving = false;

  void showMessage(String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> uploadFromLink() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      showMessage('Error', 'No user is logged in.');
      return;
    }

    final TextEditingController nameController = TextEditingController();
    final TextEditingController linkController = TextEditingController();

    final bool? shouldSave = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Document'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Document name',
                  hintText: 'Example: My Resume.pdf',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: linkController,
                decoration: const InputDecoration(
                  labelText: 'Document link',
                  hintText: 'https://...',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (shouldSave != true) {
      return;
    }

    final String fileName = nameController.text.trim();
    final String downloadUrl = linkController.text.trim();

    if (fileName.isEmpty || downloadUrl.isEmpty) {
      showMessage('Missing Data', 'Please enter document name and link.');
      return;
    }

    try {
      setState(() {
        isSaving = true;
      });

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('documents')
          .add({
        'fileName': fileName,
        'downloadUrl': downloadUrl,
        'uploadedAt': FieldValue.serverTimestamp(),
      });

      setState(() {
        isSaving = false;
      });

      showMessage('Success', 'Document saved successfully.');
    } catch (e) {
      setState(() {
        isSaving = false;
      });

      showMessage('Error', e.toString());
    }
  }

  void uploadFromDeviceDummy() {
    showMessage(
      'Upload from Device',
      'This is a dummy button.\n\nReal file upload requires Firebase Storage and a Blaze plan.',
    );
  }

  Future<void> deleteDocument(String docId) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return;
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('documents')
        .doc(docId)
        .delete();
  }

  String formatDate(Timestamp? timestamp) {
    if (timestamp == null) {
      return 'Just now';
    }

    final date = timestamp.toDate();
    return '${date.day}/${date.month}/${date.year}';
  }

  IconData getIconByName(String fileName) {
    final lowerName = fileName.toLowerCase();

    if (lowerName.endsWith('.pdf')) {
      return Icons.picture_as_pdf;
    }

    if (lowerName.endsWith('.doc') || lowerName.endsWith('.docx')) {
      return Icons.description;
    }

    return Icons.insert_drive_file;
  }

  Color getIconColorByName(String fileName) {
    final lowerName = fileName.toLowerCase();

    if (lowerName.endsWith('.pdf')) {
      return Colors.red;
    }

    if (lowerName.endsWith('.doc') || lowerName.endsWith('.docx')) {
      return Colors.blue;
    }

    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text('No user is logged in'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resume'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: isSaving ? null : uploadFromLink,
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.pink),
            ),
          ),
        ],
      ),

      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .collection('documents')
                  .orderBy('uploadedAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;

                if (docs.isEmpty) {
                  return const Center(
                    child: Text(
                      'No documents yet',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final document = docs[index];
                    final data = document.data() as Map<String, dynamic>;

                    final String fileName = data['fileName'] ?? 'Document';
                    final String downloadUrl = data['downloadUrl'] ?? '';
                    final Timestamp? uploadedAt = data['uploadedAt'];

                    return Card(
                      elevation: 0,
                      color: Colors.white,
                      child: ListTile(
                        leading: Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: getIconColorByName(fileName).withOpacity(0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            getIconByName(fileName),
                            color: getIconColorByName(fileName),
                          ),
                        ),

                        title: Text(
                          fileName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        subtitle: Text(
                          '$downloadUrl\nUploaded: ${formatDate(uploadedAt)}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            deleteDocument(document.id);
                          },
                        ),

                        onTap: () {
                          showMessage('Document Link', downloadUrl);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: isSaving ? null : uploadFromLink,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text(
                      'Upload from Link',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: ElevatedButton(
                    onPressed: uploadFromDeviceDummy,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text(
                      'Upload from Device',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}