import 'package:flutter/material.dart';

class Analisispage extends StatelessWidget {
  const Analisispage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard'), backgroundColor: Colors.white, elevation: 1),
      body: const Center(child: Text('Halaman Dashboard')),
    );
  }
}