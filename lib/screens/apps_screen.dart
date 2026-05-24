import 'package:flutter/material.dart';

class AppsScreen extends StatefulWidget {
  const AppsScreen({super.key});

  @override
  State<AppsScreen> createState() => _AppsScreenState();
}

class _AppsScreenState extends State<AppsScreen> {
  int? downloadingIndex;

  final List<String> apps = [
    'App 1',
    'App 2',
    'App 3',
    'App 4',
    'App 5',
    'App 6',
  ];

  void startDummyDownload(int index) {
    setState(() {
      downloadingIndex = index;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      setState(() {
        downloadingIndex = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${apps[index]} dummy download finished'),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text(
          'Apps',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.separated(
        itemCount: apps.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final bool isDownloading = downloadingIndex == index;

          return Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: const LinearGradient(
                      colors: [
                        Colors.redAccent,
                        Colors.blue,
                      ],
                    ),
                  ),
                  child: const Icon(
                    Icons.ac_unit,
                    color: Colors.white,
                    size: 28,
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        apps[index],
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black87,
                        ),
                      ),
                      const Text(
                        'Lorem ipsum ...',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

                isDownloading
                    ? SizedBox(
                  width: 45,
                  height: 45,
                  child: Stack(
                    alignment: Alignment.center,
                    children: const [
                      CircularProgressIndicator(
                        strokeWidth: 3,
                        color: Colors.blue,
                      ),
                      Icon(
                        Icons.stop,
                        color: Colors.blue,
                        size: 18,
                      ),
                    ],
                  ),
                )
                    : SizedBox(
                  width: 95,
                  height: 36,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE8E8EE),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    onPressed: () => startDummyDownload(index),
                    child: Text(
                      index == 0 ? 'OPEN' : 'GET',
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}