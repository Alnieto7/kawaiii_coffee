import 'package:flutter/material.dart';

class SettingTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final Widget? suffixIcon;
  final int maxLines;

  const SettingTextField({
    super.key,
    required this.label,
    required this.controller,
    this.obscureText = false,
    this.suffixIcon,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.5),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            maxLines: maxLines,
            style: const TextStyle(fontSize: 13, color: Color(0xFF374151)),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              suffixIcon: suffixIcon,
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}