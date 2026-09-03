import 'package:flutter/material.dart';

class TotalSection extends StatelessWidget {

  final int total;

  const TotalSection({
    super.key,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {

    return Row(

      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,

      children: [

        const Text(

          "Total",

          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),

        Text(

          "Rp $total",

          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFFD97706),
          ),
        ),
      ],
    );
  }
}