import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrisImageWidget extends StatelessWidget {
  final String qrUrl;

  const QrisImageWidget({super.key, required this.qrUrl});

  @override
  Widget build(BuildContext context) {
    return QrImageView(
      data: qrUrl,
      version: QrVersions.auto,
      size: 250,
      backgroundColor: Colors.white,
      errorStateBuilder: (context, error) => const Column(
        children: [
          Icon(Icons.error, color: Colors.red, size: 60),
          Text('Gagal membuat QR Code'),
        ],
      ),
    );
  }
}
