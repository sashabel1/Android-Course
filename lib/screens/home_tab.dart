import 'package:flutter/material.dart';

import 'service_detail_screen.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  final List<Map<String, dynamic>> services = const [
    {
      'title': 'Cleaning',
      'icon': Icons.cleaning_services,
      'color': Colors.lightBlue,
    },
    {
      'title': 'Plumber',
      'icon': Icons.plumbing,
      'color': Colors.redAccent,
    },
    {
      'title': 'Electrician',
      'icon': Icons.electrical_services,
      'color': Colors.orange,
    },
    {
      'title': 'Painter',
      'icon': Icons.format_paint,
      'color': Colors.blue,
    },
    {
      'title': 'Carpenter',
      'icon': Icons.carpenter,
      'color': Colors.amber,
    },
    {
      'title': 'Gardener',
      'icon': Icons.local_florist,
      'color': Colors.green,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 25),

          const Text(
            'Which service\ndo you need?',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              height: 1.1,
            ),
          ),

          const SizedBox(height: 35),

          Expanded(
            child: GridView.builder(
              itemCount: services.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                final service = services[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ServiceDetailScreen(
                          serviceName: service['title'],
                          serviceIcon: service['icon'],
                          serviceColor: service['color'],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F4F4),
                      borderRadius: BorderRadius.circular(16),
                      border: index == 0
                          ? Border.all(color: Colors.blue, width: 2)
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          service['icon'],
                          size: 55,
                          color: service['color'],
                        ),
                        const SizedBox(height: 14),
                        Text(
                          service['title'],
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}