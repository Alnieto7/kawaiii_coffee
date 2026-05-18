import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:kawaiii_coffee/Component/app_colors.dart';

class QrisImageWidget extends StatelessWidget {
  final String qrUrl;

  const QrisImageWidget({
    super.key,
    required this.qrUrl,
  });

  @override
  Widget build(BuildContext context) {
    return QrImageView(
      data: qrUrl,
      version: QrVersions.auto,
      size: 250,
      backgroundColor: AppColors.backgroundWhite,
      errorStateBuilder: (context, error) => const Column(
        children: [
          Icon(
            Icons.error,
            color: AppColors.error,
            size: 60,
          ),
          Text('Gagal membuat QR Code'),
        ],
      ),
    );
  }
}