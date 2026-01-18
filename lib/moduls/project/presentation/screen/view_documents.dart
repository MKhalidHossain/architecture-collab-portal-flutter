import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:dana_bozzetto/moduls/project/model/documents_model.dart';
import 'package:dana_bozzetto/moduls/project/presentation/screen/document_preview_screen.dart';
import 'package:dana_bozzetto/moduls/project/presentation/widget/full_screen_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class DocumentDetailScreen extends StatefulWidget {
  final DocumentModel document;

  const DocumentDetailScreen({
    super.key,
    required this.document,
  });

  @override
  State<DocumentDetailScreen> createState() => _DocumentDetailScreenState();
}

class _DocumentDetailScreenState extends State<DocumentDetailScreen> {
  bool _isDownloading = false;
  double _downloadProgress = 0;

  @override
  Widget build(BuildContext context) {
    final document = widget.document;
    final title = document.category.trim().isNotEmpty
        ? document.category
        : "Document";
    final subtitle = (document.subtitle ?? document.title ?? '-').trim();
    final status = (document.status ?? '-').trim();
    final uploadedBy = (document.uploadedBy ?? '-').trim();
    final url = document.url?.trim() ?? '';
    final isImagePreview = _isImageUrl(url);
    final commentsCount = document.commentsCount ?? 0;

    return Scaffold(
      backgroundColor: Color(0xFF5C5C5A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: false,
        elevation: 0,
        toolbarHeight: 90,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle.isNotEmpty ? subtitle : '-',
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ],
        ),
      ),

      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Image.asset('assets/image/ab.png', fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.45)),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: Column(
                children: [
                  // Image Preview Card with Full Screen support
                  _glassCard(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: isImagePreview
                              ? () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          FullScreenImageViewer(
                                        imagePath: url,
                                        isAsset: false,
                                      ),
                                    ),
                                  );
                                }
                              : null,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: isImagePreview
                                ? Image.network(
                                    url,
                                    height: 220,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => _filePreview(
                                      context,
                                      title: title,
                                    ),
                                  )
                                : _filePreview(
                                    context,
                                    title: title,
                                  ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: _actionButton(
                                label:
                                    _isDownloading ? "Downloading" : "Download",
                                icon: Icons.download_rounded,
                                isPrimary: true,
                                onTap: () {
                                  if (_isDownloading) {
                                    return;
                                  }
                                  _handleDownload(
                                    context,
                                    url: url,
                                    title: subtitle.isNotEmpty ? subtitle : title,
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _actionButton(
                                label: "Preview",
                                icon: Icons.remove_red_eye_outlined,
                                isPrimary: false,
                                onTap: () {
                                  if (url.isEmpty) {
                                    _showMessage(context, "No file URL found.");
                                    return;
                                  }
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DocumentPreviewScreen(
                                        url: url,
                                        title: subtitle.isNotEmpty
                                            ? subtitle
                                            : title,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        _downloadProgressBar(),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // File Info Card - restored chip style for non-status fields
                  _glassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow(
                          label: "Status",
                          value: status.isNotEmpty ? status : '-',
                          isStatus: true,
                        ),
                        _buildDetailRow(
                          label: "Type",
                          value: document.type,
                        ),
                        _buildDetailRow(
                          label: "Size",
                          value: document.size,
                        ),
                        _buildDetailRow(
                          label: "Uploaded By",
                          value: uploadedBy.isNotEmpty ? uploadedBy : '-',
                        ),
                        _buildDetailRow(
                          label: "Uploaded Date",
                          value: document.date,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Comments Section
                  _glassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.messenger_outline,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(width: 14),
                          Text(
                            "Comments & Feedback ($commentsCount)",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                        const SizedBox(height: 20),

                        _buildCommentsMessage(commentsCount),

                        const SizedBox(height: 24),

                        // Comment Input
                        TextField(
                          style: const TextStyle(color: Colors.white),
                          maxLines: 3,
                          minLines: 1,
                          decoration: InputDecoration(
                            hintText: "Add your comment or feedback...",
                            hintStyle: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                            ),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.08),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF01676C),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            onPressed: () {},
                            child: const Text(
                              "Submit Comment",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isImageUrl(String url) {
    if (url.isEmpty) {
      return false;
    }
    final lower = url.toLowerCase();
    return lower.endsWith('.png') ||
        lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.webp') ||
        lower.endsWith('.gif');
  }

  Widget _buildCommentsMessage(int commentsCount) {
    final message = commentsCount == 0
        ? "No comments yet."
        : "Comments are not loaded in this view.";
    return Text(
      message,
      style: TextStyle(
        color: Colors.white.withOpacity(0.7),
        fontSize: 14,
      ),
    );
  }

  Future<void> _handleDownload(
    BuildContext context, {
    required String url,
    required String title,
  }) async {
    if (url.isEmpty) {
      _showMessage(context, "No file URL found.");
      return;
    }
    setState(() {
      _isDownloading = true;
      _downloadProgress = 0;
    });
    try {
      final dir = await getApplicationDocumentsDirectory();
      final fileName = _buildFileName(title, url);
      final filePath = '${dir.path}/$fileName';
      await Dio().download(
        url,
        filePath,
        onReceiveProgress: (received, total) {
          if (total <= 0) {
            return;
          }
          setState(() {
            _downloadProgress = received / total;
          });
        },
      );
      if (!mounted) {
        return;
      }
      _showMessage(context, "Saved to $filePath");
    } catch (e) {
      if (!mounted) {
        return;
      }
      _showMessage(context, "Download failed. Please try again.");
    } finally {
      if (mounted) {
        setState(() {
          _isDownloading = false;
          _downloadProgress = 0;
        });
      }
    }
  }

  String _buildFileName(String title, String url) {
    final uri = Uri.tryParse(url);
    final lastSegment = uri?.pathSegments.isNotEmpty == true
        ? uri!.pathSegments.last
        : '';
    if (lastSegment.isNotEmpty && lastSegment.contains('.')) {
      return lastSegment;
    }
    final cleaned = title.trim().isEmpty ? 'document' : title.trim();
    final safe = cleaned.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_');
    return '$safe.pdf';
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Widget _downloadProgressBar() {
    if (!_isDownloading || _downloadProgress <= 0) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: LinearProgressIndicator(
        value: _downloadProgress,
        color: const Color(0xFF01676C),
        backgroundColor: Colors.white.withOpacity(0.1),
      ),
    );
  }

  Widget _filePreview(BuildContext context, {required String title}) {
    return Container(
      height: 220,
      width: double.infinity,
      color: Colors.black.withOpacity(0.25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.insert_drive_file_rounded,
            color: Colors.white70,
            size: 46,
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Glass Card
  Widget _glassCard({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 25, 25, 25).withOpacity(0.09),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.12)),
          ),
          padding: const EdgeInsets.all(20),
          child: child,
        ),
      ),
    );
  }

  // Action Button (Download / Full Screen)
  Widget _actionButton({
    required String label,
    required IconData icon,
    required bool isPrimary,
    VoidCallback? onTap,
  }) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: isPrimary ? const Color(0xFF01676C) : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: isPrimary
            ? null
            : Border.all(color: Colors.white.withOpacity(0.25), width: 1.2),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap ?? () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Restored modern chip-based info row (UI preserved)
  Widget _buildDetailRow({
    required String label,
    required String value,
    bool isStatus = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.75),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (isStatus)
            _buildStatusChip(value)
          else
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case "review":
      case "pending":
        color = Colors.orange;
        break;
      case "approved":
        color = Colors.green;
        break;
      case "rejected":
        color = Colors.redAccent;
        break;
      default:
        color = Colors.blueAccent;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      decoration: BoxDecoration(
        color: color.withOpacity(0.18),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
