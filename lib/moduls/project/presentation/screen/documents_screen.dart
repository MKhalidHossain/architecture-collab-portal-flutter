import 'dart:ui';
import 'package:dana_bozzetto/core/helpers/file_downloader.dart';
import 'package:dana_bozzetto/moduls/project/controller/project_details_controller.dart';
import 'package:dana_bozzetto/moduls/project/model/documents_model.dart';
import 'package:dana_bozzetto/core/utils/helpers/auth_role.dart';
// import 'package:dana_bozzetto/moduls/project/presentation/widget/project_all_documents_widget.dart';
import 'package:flutter/material.dart';

import '../widget/project_all_documents_widget.dart';
import 'view_documents.dart';

class DocumentsScreen extends StatefulWidget {
  final String initialQuery;

  const DocumentsScreen({
    super.key,
    this.initialQuery = '',
  });

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  String selectedTab = "All";
  String searchQuery = "";

  late final ProjectDetailsController _controller;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = ProjectDetailsController();
    _controller.getDocuments();
    if (widget.initialQuery.trim().isNotEmpty) {
      searchQuery = widget.initialQuery.trim();
      searchController.text = searchQuery;
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final isTeamMember = _controller.authRole == AuthRole.teamMember;
        final documents = isTeamMember
            ? _controller.teamMemberDocuments
                  .map(
                    (doc) => DocumentModel(
                      category: _resolveCategory(doc.name, doc.project?.name),
                      subtitle: doc.name?.trim().isNotEmpty == true
                          ? doc.name
                          : (doc.project?.name ?? '-'),
                      size: _formatBytes(doc.file?.size),
                      date: _formatDate(doc.createdAt),
                      type: doc.type?.trim().isNotEmpty == true
                          ? doc.type!
                          : (doc.file?.format ?? 'Document'),
                      status: doc.status,
                      uploadedBy: doc.uploadedBy?.name,
                      commentsCount: doc.comments.length,
                      url: doc.file?.url,
                    ),
                  )
                  .toList()
            : _controller.clientDocuments
                  .map(
                    (doc) => DocumentModel(
                      category: _resolveCategory(
                        doc.milestoneName,
                        doc.projectName,
                      ),
                      subtitle: doc.name?.trim().isNotEmpty == true
                          ? doc.name
                          : (doc.projectName ?? '-'),
                      size: _formatBytes(doc.size),
                      date: _formatDate(doc.uploadedDate),
                      type: doc.type?.trim().isNotEmpty == true
                          ? doc.type!
                          : 'Document',
                      status: doc.status,
                      uploadedBy: doc.uploadedBy,
                      commentsCount: doc.commentsCount,
                      url: doc.url,
                    ),
                  )
                  .toList();

        /// 🔹 TAB + SEARCH FILTER
        final filteredDocs = documents.where((doc) {
          final matchesTab =
              selectedTab == "All" ||
              _matchesStageTab(doc.category, selectedTab);

          final query = searchQuery.toLowerCase().trim();
          if (query.isEmpty) {
            return matchesTab;
          }

          final matchesSearch =
              doc.category.toLowerCase().contains(query) ||
              (doc.title ?? "").toLowerCase().contains(query) ||
              (doc.subtitle ?? "").toLowerCase().contains(query) ||
              doc.type.toLowerCase().contains(query);

          return matchesTab && matchesSearch;
        }).toList();

        final hasData = documents.isNotEmpty;
        final showLoading = _controller.isLoading && !hasData;
        final showError = _controller.errorMessage.isNotEmpty && !hasData;

        return Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              Positioned.fill(
                child: Image.asset("assets/image/ab.png", fit: BoxFit.cover),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _header(),
                  const SizedBox(height: 12),

                  /// ---------------- LIST ----------------
                  Expanded(
                    child: showLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white70,
                            ),
                          )
                        : showError
                        ? _buildMessage(
                            _controller.errorMessage,
                            onRetry: _controller.getDocuments,
                          )
                        : filteredDocs.isEmpty
                        ? const Center(
                            child: Text(
                              "No documents found",
                              style: TextStyle(color: Colors.white70),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: filteredDocs.length,
                            itemBuilder: (_, i) => DocumentPreviewCard(
                              title: filteredDocs[i].category,
                              subtitle: filteredDocs[i].subtitle ?? "",
                              size: filteredDocs[i].size,
                              date: filteredDocs[i].date,
                              type: filteredDocs[i].type,
                              onView: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => DocumentDetailScreen(
                                      document: filteredDocs[i],
                                    ),
                                  ),
                                );
                              },
                              onDownload: () =>
                                  _handleDownload(context, filteredDocs[i]),
                            ),
                          ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  /// ---------------- HEADER ----------------
  Widget _header() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4F504C), Color(0xFF7E7E7B)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const SizedBox(height: 50),
          _appBar(),
          _searchBar(),
          _tabs(),
        ],
      ),
    );
  }

  /// ---------------- APP BAR ----------------
  Widget _appBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          ),
          const SizedBox(width: 8),
          const Text(
            "Documents",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// ---------------- SEARCH BAR (ACTIVE) ----------------
  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: TextField(
              controller: searchController,
              style: const TextStyle(color: Colors.white),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: const InputDecoration(
                border: InputBorder.none,
                icon: Icon(Icons.search, color: Colors.white54),
                hintText: "Search Projects, Documents....",
                hintStyle: TextStyle(color: Colors.white54),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _tabs() {
    final tabs = [
      "All",
      "Pre-Design",
      "Schematic Design",
      "Design Development",
      "Construction Design",
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: tabs.map((tab) {
            final active = selectedTab == tab;
            return Padding(
              padding: const EdgeInsets.only(right: 10),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedTab = tab;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: active
                        ? const Color(0xFF006B6F)
                        : Colors.white.withOpacity(.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    tab,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildMessage(String message, {VoidCallback? onRetry}) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 12),
            TextButton(onPressed: onRetry, child: const Text("Retry")),
          ],
        ],
      ),
    );
  }

  String _resolveCategory(String? milestoneName, String? projectName) {
    final milestone = milestoneName?.trim() ?? '';
    if (milestone.isNotEmpty) {
      final stage = _stageLabel(milestone);
      return stage.isNotEmpty ? stage : milestone;
    }
    final project = projectName?.trim() ?? '';
    return project.isNotEmpty ? project : "Unknown";
  }

  bool _matchesStageTab(String category, String tab) {
    if (tab == "All") return true;
    final categoryKey = _stageKey(category);
    final tabKey = _stageKey(tab);
    if (categoryKey.isEmpty || tabKey.isEmpty) {
      return category.trim() == tab.trim();
    }
    return categoryKey == tabKey;
  }

  String _stageLabel(String value) {
    final key = _stageKey(value);
    switch (key) {
      case 'pre_design':
        return "Pre-Design";
      case 'schematic_design':
        return "Schematic Design";
      case 'design_development':
        return "Design Development";
      case 'construction_design':
        return "Construction Design";
    }
    return '';
  }

  String _stageKey(String value) {
    final raw = value.toLowerCase().trim();
    if (raw.isEmpty) return '';
    final compact = raw.replaceAll(RegExp(r'[^a-z]'), '');
    if (compact.contains('predesign') || compact.contains('predesigns')) {
      return 'pre_design';
    }
    if (compact.contains('schematic')) {
      return 'schematic_design';
    }
    if (compact.contains('designdevelopment') ||
        compact == 'dd' ||
        compact.contains('develop')) {
      return 'design_development';
    }
    if (compact.contains('construction') || compact == 'cd') {
      return 'construction_design';
    }
    return '';
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

  Future<void> _handleDownload(
    BuildContext context,
    DocumentModel document,
  ) async {
    final url = document.url?.trim() ?? '';
    final title = (document.subtitle ?? document.title ?? '').trim();
    if (url.isEmpty) {
      _showMessage(context, "No file URL found.");
      return;
    }
    try {
      final filePath = await FileDownloader.download(
        url: url,
        filenameHint: title.isNotEmpty ? title : document.category,
      );
      if (!context.mounted) {
        return;
      }
      _showMessage(context, "Saved to $filePath");
    } catch (_) {
      if (!context.mounted) {
        return;
      }
      _showMessage(context, "Download failed. Please try again.");
    }
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
