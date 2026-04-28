import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final bool isActive;
  final String duration;

  const InfoCard({super.key, required this.isActive, required this.duration});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const CircleAvatar(radius: 5, backgroundColor: Colors.green),
              const SizedBox(width: 8),
              Text(isActive ? 'AKTIF' : 'NONAKTIF'),
            ],
          ),
          Text(duration, style: const TextStyle(color: Colors.orange)),
        ],
      ),
    );
  }
}