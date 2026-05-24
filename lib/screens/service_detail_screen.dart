import 'package:flutter/material.dart';

class ServiceDetailScreen extends StatelessWidget {
  final String serviceName;
  final IconData serviceIcon;
  final Color serviceColor;

  const ServiceDetailScreen({
    super.key,
    required this.serviceName,
    required this.serviceIcon,
    required this.serviceColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: Text(serviceName),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            CircleAvatar(
              radius: 55,
              backgroundColor: serviceColor.withOpacity(0.15),
              child: Icon(
                serviceIcon,
                size: 60,
                color: serviceColor,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              '$serviceName Expert',
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Available service provider near you',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 25),

            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F4F4),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.person, color: Colors.blue),
                      SizedBox(width: 12),
                      Text(
                        'Contact: Alex Johnson',
                        style: TextStyle(fontSize: 17),
                      ),
                    ],
                  ),

                  SizedBox(height: 15),

                  Row(
                    children: [
                      Icon(Icons.phone, color: Colors.green),
                      SizedBox(width: 12),
                      Text(
                        'Phone: 050-123-4567',
                        style: TextStyle(fontSize: 17),
                      ),
                    ],
                  ),

                  SizedBox(height: 15),

                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber),
                      SizedBox(width: 12),
                      Text(
                        'Rating: 4.8 / 5',
                        style: TextStyle(fontSize: 17),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'This is a temporary service details screen. Later you can connect it to Firebase and show real service providers from the database.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.black54,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}