import 'dart:ui';

import 'package:dana_bozzetto/moduls/project/presentation/screen/document_preview_screen.dart';
import 'package:dana_bozzetto/moduls/project/presentation/screen/project_details.dart';
import 'package:dana_bozzetto/moduls/search/interface/search_interface.dart';
import 'package:dana_bozzetto/moduls/search/model/search_response_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchScreen extends StatefulWidget {
  final bool isTeamMember;
  final String initialQuery;

  const SearchScreen({
    super.key,
    required this.isTeamMember,
    required this.initialQuery,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final TextEditingController _controller;
  Future<SearchResponse>? _searchFuture;
  String _lastQuery = '';

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery);
    final initial = widget.initialQuery.trim();
    if (initial.isNotEmpty) {
      _lastQuery = initial;
      _searchFuture = _performSearch(initial);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<SearchResponse> _performSearch(String query) async {
    final searchInterface = Get.find<SearchInterface>();
    final result = widget.isTeamMember
        ? await searchInterface.searchTeam(query: query)
        : await searchInterface.searchClient(query: query);

    return result.fold((failure) {
      final message = failure.uiMessage.isNotEmpty
          ? failure.uiMessage
          : failure.fullError;
      throw Exception(message.isNotEmpty ? message : 'Search failed');
    }, (success) => success.data ?? SearchResponse.empty());
  }

  void _submitSearch(String value) {
    final query = value.trim();
    if (query.isEmpty) {
      setState(() {
        _lastQuery = '';
        _searchFuture = null;
      });
      return;
    }
    setState(() {
      _lastQuery = query;
      _searchFuture = _performSearch(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Search'),
      ),
      body: Stack(
        children: [
          _background(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _searchBar(),
                  const SizedBox(height: 16),
                  Expanded(child: _buildResults()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchBar() {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: TextField(
        controller: _controller,
        style: const TextStyle(color: Colors.white),
        textInputAction: TextInputAction.search,
        onSubmitted: _submitSearch,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 14),
          prefixIcon: Icon(Icons.search, color: Colors.white70),
          hintText: 'Search Projects, Documents, Invoices...',
          hintStyle: TextStyle(color: Colors.white70, fontSize: 13),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildResults() {
    if (_searchFuture == null) {
      return _emptyHint('Type to search for projects and documents.');
    }

    return FutureBuilder<SearchResponse>(
      future: _searchFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }
        if (snapshot.hasError) {
          return _emptyHint('Search failed. Please try again.');
        }
        final data = snapshot.data ?? SearchResponse.empty();
        if (data.isEmpty) {
          return _emptyHint('No results for "$_lastQuery".');
        }

        return ListView(
          children: [
            if (data.projects.isNotEmpty)
                  _section(
                title: 'Projects',
                children: data.projects
                    .map(
                      (item) => _resultTile(
                        title: item.name,
                        subtitle:
                            item.status.isNotEmpty ? item.status : 'Project',
                        icon: Icons.folder_open,
                        onTap: () => _openProject(item.id),
                      ),
                    )
                    .toList(),
              ),
            if (data.documents.isNotEmpty) ...[
              const SizedBox(height: 12),
              _section(
                title: 'Documents',
                children: data.documents
                    .map(
                      (item) => _resultTile(
                        title: item.name,
                        subtitle: item.type.isNotEmpty
                            ? item.type
                            : 'Document',
                        icon: Icons.description_outlined,
                        onTap: () => _openDocument(item.name, item.fileUrl),
                      ),
                    )
                    .toList(),
              ),
            ],
            if (data.invoices.isNotEmpty) ...[
              const SizedBox(height: 12),
              _section(
                title: 'Invoices',
                children: data.invoices
                    .map(
                      (item) => _resultTile(
                        title: item.title.isNotEmpty ? item.title : 'Invoice',
                        subtitle:
                            item.status.isNotEmpty ? item.status : 'Invoice',
                        icon: Icons.receipt_long_outlined,
                      ),
                    )
                    .toList(),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _section({required String title, required List<Widget> children}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.35),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              ...children,
            ],
          ),
        ),
      ),
    );
  }

  Widget _resultTile({
    required String title,
    required String subtitle,
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              height: 38,
              width: 38,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white70, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.white60, fontSize: 12),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              const Icon(
                Icons.chevron_right,
                color: Colors.white54,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  void _openProject(String projectId) {
    if (projectId.trim().isEmpty) {
      _showSnack('Project id not found.');
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProjectDetailScreen(
          projectId: projectId,
          isClient: !widget.isTeamMember,
        ),
      ),
    );
  }

  void _openDocument(String title, String url) {
    if (url.trim().isEmpty) {
      _showSnack('Document link not available.');
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DocumentPreviewScreen(
          url: url,
          title: title.isNotEmpty ? title : 'Document',
        ),
      ),
    );
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Widget _emptyHint(String message) {
    return Center(
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white70, fontSize: 14),
      ),
    );
  }

  Widget _background() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/image/ab.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
