import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart'; // Add this package to pubspec.yaml

class FullScreenImageViewer extends StatelessWidget {
  final String imagePath; // asset or network path
  final bool isAsset; // true = asset, false = network

  const FullScreenImageViewer({
    super.key,
    required this.imagePath,
    this.isAsset = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.white, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download_rounded, color: Colors.white, size: 26),
            onPressed: () {
              // TODO: Implement actual image download logic
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Download started...")),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          PhotoView(
            imageProvider: isAsset
                ? AssetImage(imagePath)
                : NetworkImage(imagePath),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 4.0,
            initialScale: PhotoViewComputedScale.contained,
            backgroundDecoration: const BoxDecoration(color: Colors.black),
            loadingBuilder: (context, event) => const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF01676C),
              ),
            ),
          ),
          // Optional: subtle gradient overlay at bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 120,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}