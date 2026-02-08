import 'dart:io';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class InvoicePdfPreviewScreen extends StatelessWidget {
  final String filePath;
  final String title;

  const InvoicePdfPreviewScreen({
    super.key,
    required this.filePath,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final file = File(filePath);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: file.existsSync()
          ? SfPdfViewer.file(file)
          : const Center(
              child: Text(
                'PDF file not found.',
                style: TextStyle(color: Colors.white70),
              ),
            ),
    );
  }
}
