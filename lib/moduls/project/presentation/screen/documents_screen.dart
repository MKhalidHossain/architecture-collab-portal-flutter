import 'dart:ui';
import 'package:dana_bozzetto/moduls/project/controller/project_details_controller.dart';
import 'package:dana_bozzetto/moduls/project/model/documents_model.dart';
import 'package:dana_bozzetto/moduls/project/presentation/screen/project_based_documents.dart';
// import 'package:dana_bozzetto/moduls/project/presentation/widget/project_all_documents_widget.dart';
import 'package:flutter/material.dart';

import '../widget/project_all_documents_widget.dart';

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({super.key});

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
    _controller.getClientDocuments();
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
        final documents = _controller.documents
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
              ),
            )
            .toList();

        /// 🔹 TAB + SEARCH FILTER
        final filteredDocs = documents.where((doc) {
          final matchesTab = selectedTab == "All" || doc.category == selectedTab;

          final query = searchQuery.toLowerCase().trim();
          if (query.isEmpty) {
            return matchesTab;
          }

          final matchesSearch =
              doc.category.toLowerCase().contains(query) ||
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
                                onRetry: _controller.getClientDocuments,
                              )
                            : filteredDocs.isEmpty
                                ? const Center(
                                    child: Text(
                                      "No documents found",
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                  )
                                : ListView.builder(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
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
                                            builder: (_) =>
                                                ProjectBasedDocuments(),
                                          ),
                                        );
                                      },
                                      onDownload: () {},
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
            TextButton(
              onPressed: onRetry,
              child: const Text("Retry"),
            ),
          ],
        ],
      ),
    );
  }

  String _resolveCategory(String? milestoneName, String? projectName) {
    final milestone = milestoneName?.trim() ?? '';
    if (milestone.isNotEmpty) {
      return milestone;
    }
    final project = projectName?.trim() ?? '';
    return project.isNotEmpty ? project : "Unknown";
  }

  String _formatBytes(int? size) {
    if (size == null || size <= 0) {
      return "-";
    }
    const kilo = 1024;
    const mega = kilo * 1024;
    if (size >= mega) {
      final value = size / mega;
      return "${value.toStringAsFixed(1)} MB";
    }
    if (size >= kilo) {
      final value = size / kilo;
      return "${value.toStringAsFixed(1)} KB";
    }
    return "$size B";
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
