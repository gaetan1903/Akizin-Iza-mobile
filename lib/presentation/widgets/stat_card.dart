import 'package:flutter/material.dart';
import '../../core/colors.dart';

class StatCard extends StatelessWidget {
  final IconData icon;
  final String number;
  final String title;
  final String text;
  final double? width;
  const StatCard({
    super.key,
    required this.icon,
    required this.number,
    required this.title,
    required this.text,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
        border: Border.all(color: const Color(0xFFF1F1F3)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(AppColors.primary), size: 30),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '$number\n$title',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(AppColors.dark),
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            text,
            style: const TextStyle(fontSize: 14, color: Color(AppColors.dark)),
          ),
        ],
      ),
    );
  }
}
