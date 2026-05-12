import 'package:flutter/material.dart';

class PaymentButton extends StatelessWidget {

  final String title;

  final bool selected;

  final VoidCallback onTap;

  const PaymentButton({
    super.key,
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return Expanded(

      child: GestureDetector(

        onTap: onTap,

        child: Container(

          padding: const EdgeInsets.symmetric(
            vertical: 12,
          ),

          decoration: BoxDecoration(

            color: selected
                ? const Color(0xFFD97706)
                    .withOpacity(0.1)
                : Colors.white,

            borderRadius:
                BorderRadius.circular(10),

            border: Border.all(

              color: selected
                  ? const Color(0xFFD97706)
                  : Colors.grey.shade300,
            ),
          ),

          child: Center(

            child: Text(

              title,

              style: TextStyle(

                fontWeight: FontWeight.bold,

                color: selected
                    ? const Color(0xFFD97706)
                    : Colors.black54,
              ),
            ),
          ),
        ),
      ),
    );
  }
}