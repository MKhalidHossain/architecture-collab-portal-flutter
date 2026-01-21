import 'dart:ui';
import 'package:dana_bozzetto/moduls/project/controller/project_documents_controller.dart';
import 'package:dana_bozzetto/moduls/project/model/documents_model.dart';
import 'package:dana_bozzetto/moduls/project/model/project_documents_response_model.dart';
import 'package:dana_bozzetto/moduls/project/presentation/widget/project_all_documents_widget.dart';
import 'package:flutter/material.dart';

class ProjectBasedDocuments extends StatefulWidget {
  final String projectId;

  const ProjectBasedDocuments({
    super.key,
    required this.projectId,
  });

  @override
  State<ProjectBasedDocuments> createState() => _ProjectBasedDocumentsState();
}

class _ProjectBasedDocumentsState extends State<ProjectBasedDocuments> {
  int _selectedTab = 0;
  late final ProjectDocumentsController _controller;

  final titles = [
    "All",
    "Pre-Design",
    "Schematic Design",
    "Design Development",
    "Construction Design",
  ];

  @override
  void initState() {
    super.initState();
    _controller = ProjectDocumentsController();
    _controller.fetchProjectDocuments(widget.projectId);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final documents = _buildDocuments(_controller.documents);
        final hasData = documents.isNotEmpty;
        final showLoading = _controller.isLoading && !hasData;
        final showError = _controller.errorMessage.isNotEmpty && !hasData;

        return Scaffold(
          body: Column(
            children: [
              _header(context),
              Expanded(
                child: Stack(
                  children: [
                    Image.asset(
                      'assets/image/ab.png',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                    if (showLoading)
                      const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white70,
                        ),
                      )
                    else if (showError)
                      _buildMessage(
                        _controller.errorMessage,
                        onRetry: () =>
                            _controller.fetchProjectDocuments(widget.projectId),
                      )
                    else
                      SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: AllTab(
                          selectedCategory: titles[_selectedTab],
                          documents: documents,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _header(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          'assets/image/aa.png',
          width: double.infinity,
          height: 320,
          fit: BoxFit.cover,
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(
            height: 320,
            padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
            color: Colors.black.withOpacity(0.45),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text(
                      "Documents",
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ],
                ),
                Text(
                  "Moderman Villa Design",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Smith Residence",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFF01676C),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "Active",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 16),

                /// Tabs
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(titles.length, (index) {
                      final isActive = _selectedTab == index;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedTab = index),
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: isActive
                                ? const Color(0xFF01676C)
                                : Colors.white.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            titles[index],
                            style: TextStyle(
                              color: isActive ? Colors.white : Colors.black,
                              fontWeight: isActive
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMessage(String message, {VoidCallback? onRetry}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message.isNotEmpty ? message : 'Failed to load documents.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 12),
              TextButton(
                onPressed: onRetry,
                child: const Text(
                  'Retry',
                  style: TextStyle(color: Color(0xFF00D4AA)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  List<DocumentModel> _buildDocuments(
    List<ProjectDocumentsResponseModel> documents,
  ) {
    return documents
        .map(
          (doc) => DocumentModel(
            category: _resolveCategory(doc.type),
            subtitle: doc.name?.trim().isNotEmpty == true ? doc.name : '-',
            size: _formatBytes(doc.file?.size),
            date: _formatDate(doc.createdAt),
            type: doc.type?.trim().isNotEmpty == true
                ? doc.type!.trim()
                : (doc.file?.format ?? 'Document'),
            status: doc.status,
            uploadedBy: doc.uploadedBy?.name,
            commentsCount: doc.comments.length,
            url: doc.file?.url,
          ),
        )
        .toList();
  }

  String _resolveCategory(String? type) {
    final value = type?.trim() ?? '';
    return value.isNotEmpty ? value : "Document";
  }

  String _formatBytes(Object? size) {
    if (size == null) {
      return "-";
    }
    if (size is String) {
      final value = size.trim();
      return value.isEmpty ? "-" : value;
    }
    if (size is! num) {
      return "-";
    }
    final bytes = size.toInt();
    if (bytes <= 0) {
      return "-";
    }
    const kilo = 1024;
    const mega = kilo * 1024;
    if (bytes >= mega) {
      final value = bytes / mega;
      return "${value.toStringAsFixed(1)} MB";
    }
    if (bytes >= kilo) {
      final value = bytes / kilo;
      return "${value.toStringAsFixed(1)} KB";
    }
    return "$bytes B";
  }

  String _formatDate(DateTime? date) {
    if (date == null) {
      return "-";
    }
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return "$day/$month/${date.year}";
  }
}
