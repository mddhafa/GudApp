import 'package:flutter/material.dart';

class DetailGambarScreen extends StatelessWidget {
  final String imageUrl;

  const DetailGambarScreen({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: InteractiveViewer(
          child: Image.network(
            imageUrl,
            fit: BoxFit.contain,
            errorBuilder:
                (_, __, ___) => const Icon(
                  Icons.broken_image,
                  size: 100,
                  color: Colors.white,
                ),
          ),
        ),
      ),
    );
  }
}
