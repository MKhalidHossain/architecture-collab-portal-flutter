import 'dart:ui';

import 'package:dana_bozzetto/moduls/project/interface/project_interface.dart';
import 'package:dana_bozzetto/moduls/project/model/task_submit_request_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const Color _accentColor = Color(0xFF0C7A7E);

class UploadDocumentScreen extends StatefulWidget {
  final String? initialStage;
  final String? initialTaskName;
  final String taskId;

  const UploadDocumentScreen({
    super.key,
    this.initialStage,
    this.initialTaskName,
    required this.taskId,
  });

  @override
  State<UploadDocumentScreen> createState() => _UploadDocumentScreenState();
}

class _UploadDocumentScreenState extends State<UploadDocumentScreen> {
  final TextEditingController _notesController = TextEditingController();
  String _selectedStage = 'Pre-Design';
  String _selectedType = 'PDF';
  bool _hasFile = false;
  bool _isSubmitting = false;
  PlatformFile? _pickedFile;

  final List<String> _stageOptions = [
    'Pre-Design',
    'Schematic Design',
    'Design Developed',
    'Construction Documents',
  ];

  final List<String> _typeOptions = const ['PDF', 'DWG', 'FPG', 'PNG'];

  @override
  void initState() {
    super.initState();
    final stage = widget.initialStage?.trim() ?? '';
    if (stage.isNotEmpty) {
      if (!_stageOptions.contains(stage)) {
        _stageOptions.insert(0, stage);
      }
      _selectedStage = stage;
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['pdf', 'dwg', 'fpg', 'png'],
      withData: true,
    );
    if (result == null || result.files.isEmpty) return;
    final file = result.files.first;
    setState(() {
      _pickedFile = file;
      _hasFile = true;
    });
  }

  Future<void> _submit() async {
    if (_isSubmitting) return;
    if (widget.taskId.trim().isEmpty) {
      _showMessage('Task ID is missing.');
      return;
    }
    if (_pickedFile == null) {
      _showMessage('Please select a file.');
      return;
    }
    setState(() => _isSubmitting = true);

    final param = TaskSubmitRequestModel(
      docName: _selectedStage,
      docType: _selectedType,
      notes: _notesController.text.trim(),
      fileName: _pickedFile!.name,
      filePath: _pickedFile!.path,
      fileBytes: _pickedFile!.bytes,
    );

    final result = await Get.find<ProjectInterface>().submitTask(
      taskId: widget.taskId,
      param: param,
    );

    if (!mounted) return;
    result.fold(
      (failure) {
        _showMessage(
          failure.uiMessage.isNotEmpty
              ? failure.uiMessage
              : failure.fullError,
        );
      },
      (success) {
        final message = success.data?.message.isNotEmpty == true
            ? success.data!.message
            : 'Document ready for approval.';
        _showMessage(message);
        Navigator.pop(context, true);
      },
    );

    if (mounted) {
      setState(() => _isSubmitting = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Image.asset(
            'assets/image/ab.png',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'Upload Document',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _searchBar(),
                  const SizedBox(height: 18),
                  _uploadCard(),
                  const SizedBox(height: 18),
                  _detailsCard(),
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
      child: const TextField(
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search, color: Colors.white70),
          hintText: 'Search Projects, Documents......',
          hintStyle: TextStyle(color: Colors.white70, fontSize: 13),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  Widget _uploadCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: InkWell(
          onTap: _pickFile,
          child: Container(
            height: 180,
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.25)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.upload_outlined,
                  color: Colors.white70,
                  size: 34,
                ),
                const SizedBox(height: 12),
                Text(
                  _hasFile
                      ? _pickedFile?.name ?? 'File ready to upload'
                      : 'Click to upload or drag and drop',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'PDF, DWG, FPG, PNG, (Max 50MB)',
                  style: TextStyle(color: Colors.white70, fontSize: 12.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _detailsCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 20),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Document Details',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Select Document Name',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 8),
              _dropdownField(
                value: _selectedStage,
                items: _stageOptions,
                onChanged: (value) {
                  if (value == null) return;
                  setState(() => _selectedStage = value);
                },
              ),
              const SizedBox(height: 14),
              const Text(
                'Document Type',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 8),
              _dropdownField(
                value: _selectedType,
                items: _typeOptions,
                onChanged: (value) {
                  if (value == null) return;
                  setState(() => _selectedType = value);
                },
              ),
              const SizedBox(height: 14),
              const Text(
                'Notes ( Optional )',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 8),
              _notesField(),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: _ghostButton(
                      label: 'Cancel',
                      onTap: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _primaryButton(
                      label: 'Send Approval',
                      onTap: _isSubmitting ? () {} : _submit,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dropdownField({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white70),
          dropdownColor: const Color(0xFF454545),
          style: const TextStyle(color: Colors.white, fontSize: 14.5),
          items: items
              .map((item) => DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _notesField() {
    return Container(
      height: 92,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: TextField(
        controller: _notesController,
        style: const TextStyle(color: Colors.white),
        maxLines: 3,
        decoration: const InputDecoration(
          hintText: 'Add any additional notes or comments...',
          hintStyle: TextStyle(color: Colors.white60, fontSize: 13),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _ghostButton({required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.18),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.28)),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _primaryButton({required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: _accentColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
