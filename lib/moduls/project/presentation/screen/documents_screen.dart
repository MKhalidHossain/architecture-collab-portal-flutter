import 'dart:ui';
import 'package:dana_bozzetto/moduls/project/model/documents_model.dart';
import 'package:flutter/material.dart';

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({super.key});

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  String selectedTab = "All";

  final List<DocumentModel> documents = [
    DocumentModel(
      subtitle: "Modern Villa Design",
      size: "2.1 MB",
      date: "11/10/2025",
      category: '',
      type: '',
    ),
    DocumentModel(
      subtitle: "Modern Villa Design",
      size: "2.1 MB",
      date: "11/10/2025",
      category: '',
      type: '',
    ),
    DocumentModel(
      subtitle: "Modern Villa Design",
      size: "2.1 MB",
      date: "11/10/2025",
      category: '',
      type: '',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/image/ab.png",
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _appBar(),
                _searchBar(),
                _tabs(),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: documents.length,
                    itemBuilder: (_, i) =>
                        _DocumentCard(document: documents[i]),
                  ),
                ),
              ],
            ),
          ),
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
          const Icon(Icons.arrow_back_ios, color: Colors.white),
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

  /// ---------------- SEARCH ----------------
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
            child: const Row(
              children: [
                Icon(Icons.search, color: Colors.white54),
                SizedBox(width: 8),
                Text(
                  "Search Projects, Documents....",
                  style: TextStyle(color: Colors.white54),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ---------------- TABS ----------------
  Widget _tabs() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          _tab("All (24)", true),
          const SizedBox(width: 10),
          _tab("Pre-Design (3)", false),
          const SizedBox(width: 10),
          _tab("Schematic", false),
        ],
      ),
    );
  }

  Widget _tab(String text, bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: active ? const Color(0xFF006B6F) : Colors.white.withOpacity(.2),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white)),
    );
  }
}

class _DocumentCard extends StatelessWidget {
  final DocumentModel document;

  const _DocumentCard({required this.document});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF006B6F),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.description, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            document.type,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            document.subtitle,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _meta(document.size),
                    _dot(),
                    _meta(document.date),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    _action(Icons.remove_red_eye, "View"),
                    const SizedBox(width: 12),
                    _action(Icons.download, "Download"),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _meta(String text) =>
      Text(text, style: const TextStyle(color: Colors.white60, fontSize: 12));

  Widget _dot() => const Padding(
    padding: EdgeInsets.symmetric(horizontal: 8),
    child: Text("|", style: TextStyle(color: Colors.white54)),
  );

  Widget _action(IconData icon, String text) {
    return Expanded(
      child: Container(
        height: 42,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white38),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 6),
            Text(text, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
