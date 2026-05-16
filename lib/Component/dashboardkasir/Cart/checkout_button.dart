import 'package:flutter/material.dart';

class CheckoutButton extends StatelessWidget {

  final bool isLoading;

  final VoidCallback onTap;

  const CheckoutButton({
    super.key,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return SizedBox(

      width: double.infinity,

      height: 50,

      child: ElevatedButton(

        onPressed: isLoading
            ? null
            : onTap,

        style:
            ElevatedButton.styleFrom(

          backgroundColor:
              const Color(0xFFD97706),

          shape:
              RoundedRectangleBorder(

            borderRadius:
                BorderRadius.circular(12),
          ),
        ),

        child: isLoading

            ? const SizedBox(

                width: 22,
                height: 22,

                child:
                    CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )

            : const Text(

                "Bayar",

                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}