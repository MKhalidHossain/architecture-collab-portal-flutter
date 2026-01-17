import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';

class DocumentPreviewScreen extends StatefulWidget {
  final String url;
  final String title;

  const DocumentPreviewScreen({
    super.key,
    required this.url,
    required this.title,
  });

  @override
  State<DocumentPreviewScreen> createState() => _DocumentPreviewScreenState();
}

class _DocumentPreviewScreenState extends State<DocumentPreviewScreen> {
  bool _hasError = false;
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    final lowerUrl = widget.url.toLowerCase();
    final isImage = _isImageUrl(lowerUrl);
    final isPdf = lowerUrl.endsWith('.pdf');

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _hasError
          ? _errorView(context)
          : isPdf
              ? SfPdfViewer.network(
                  widget.url,
                  onDocumentLoaded: (_) {
                    if (_hasError) {
                      setState(() {
                        _hasError = false;
                        _errorMessage = '';
                      });
                    }
                  },
                  onDocumentLoadFailed: (details) {
                    setState(() {
                      _hasError = true;
                      _errorMessage = details.description;
                    });
                  },
                )
              : isImage
                  ? Center(
                      child: Image.network(
                        widget.url,
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) {
                            return child;
                          }
                          final total = progress.expectedTotalBytes ?? 0;
                          final value = total > 0
                              ? progress.cumulativeBytesLoaded / total
                              : null;
                          return CircularProgressIndicator(
                            value: value,
                            color: Colors.white70,
                          );
                        },
                        errorBuilder: (_, __, ___) {
                          return _errorInline(
                            'Failed to load image preview.',
                          );
                        },
                      ),
                    )
                  : _unsupportedPreview(context),
    );
  }

  bool _isImageUrl(String url) {
    return url.endsWith('.png') ||
        url.endsWith('.jpg') ||
        url.endsWith('.jpeg') ||
        url.endsWith('.webp') ||
        url.endsWith('.gif');
  }

  Widget _unsupportedPreview(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Preview is not available for this file type.',
            style: TextStyle(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => _openExternal(context),
            icon: const Icon(Icons.open_in_new),
            label: const Text('Open in external app'),
          ),
        ],
      ),
    );
  }

  Widget _errorInline(String message) {
    return Center(
      child: Text(
        message,
        style: const TextStyle(color: Colors.white70),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _errorView(BuildContext context) {
    final message = _errorMessage.trim().isEmpty
        ? 'Unable to load this document.'
        : _errorMessage;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            style: const TextStyle(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => _openExternal(context),
            icon: const Icon(Icons.open_in_new),
            label: const Text('Open in external app'),
          ),
        ],
      ),
    );
  }

  Future<void> _openExternal(BuildContext context) async {
    final uri = Uri.tryParse(widget.url);
    if (uri == null) {
      _showMessage(context, 'Invalid file URL.');
      return;
    }
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched) {
      _showMessage(context, 'Unable to open this file.');
    }
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
