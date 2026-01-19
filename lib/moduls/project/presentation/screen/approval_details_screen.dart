import 'dart:ui';
import 'package:dana_bozzetto/core/notifiers/snackbar_notifier.dart';
import 'package:dana_bozzetto/moduls/project/interface/project_interface.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ApprovalDetailsScreen extends StatefulWidget {
  final String approvalId;

  const ApprovalDetailsScreen({
    super.key,
    required this.approvalId,
  });

  @override
  State<ApprovalDetailsScreen> createState() => _ApprovalDetailsScreenState();
}

class _ApprovalDetailsScreenState extends State<ApprovalDetailsScreen> {
  bool _isSubmitting = false;

  Future<void> _submitApproval(String status) async {
    if (_isSubmitting) {
      return;
    }
    if (widget.approvalId.trim().isEmpty) {
      SnackbarNotifier(context: context)
          .notifyError(message: 'Approval ID is missing.');
      return;
    }
    setState(() => _isSubmitting = true);
    final notifier = SnackbarNotifier(context: context);
    final result = await Get.find<ProjectInterface>().updateClientApproval(
      approvalId: widget.approvalId,
      status: status,
    );
    if (!mounted) {
      return;
    }
    result.fold(
      (failure) => notifier.notifyError(message: failure.uiMessage),
      (success) {
        notifier.notifySuccess(message: success.message);
        Navigator.pop(context);
      },
    );
    setState(() => _isSubmitting = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/image/ab.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.2),
                    Colors.black.withOpacity(0.55),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _header(context),
                  const SizedBox(height: 24),
                  _statusCard(),
                  const SizedBox(height: 20),
                  _feedbackCard(),
                  const SizedBox(height: 20),
                  _revisionButton(),
                  const SizedBox(height: 16),
                  _bottomActions(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Final Design Proposal',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        const Padding(
          padding: EdgeInsets.only(left: 32),
          child: Text(
            'Approval Request',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  Widget _statusCard() {
    return _glassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Status',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3E5C1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Pending',
                  style: TextStyle(
                    color: Color(0xFF0B6A62),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Description',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Please review and approve the final design proposal including all revisions discussed in our last meeting.',
            style: TextStyle(
              color: Colors.white70,
              height: 1.4,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: const [
              Icon(Icons.person_outline, size: 18, color: Colors.white70),
              SizedBox(width: 8),
              Text(
                'Requested by Admin',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _dateInfo(label: 'Requested', date: 'Dec 01, 2025'),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _dateInfo(label: 'Due', date: 'Dec 01, 2025'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _feedbackCard() {
    return _glassCard(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Feedback',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 160,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: const TextField(
              maxLines: null,
              minLines: 6,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                hintText:
                    'Give your Feedback if your request  for revision or reject approvals',
                hintStyle: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _revisionButton() {
    return Container(
      width: double.infinity,
      height: 54,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.25)),
      ),
      child: const Center(
        child: Text(
          'Revision Request',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _bottomActions() {
    return Row(
      children: [
        Expanded(
          child: _actionButton(
            label: 'Reject',
            icon: Icons.close,
            iconColor: const Color(0xFFFF4D2D),
            textColor: const Color(0xFFFF4D2D),
            background: Colors.white.withOpacity(0.08),
            borderColor: Colors.white.withOpacity(0.2),
            onTap: () => _submitApproval('Rejected'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _actionButton(
            label: 'Approve',
            icon: Icons.check,
            iconColor: Colors.white,
            textColor: Colors.white,
            background: const Color(0xFF0B6A62),
            borderColor: const Color(0xFF0B6A62),
            onTap: () => _submitApproval('Approved'),
          ),
        ),
      ],
    );
  }

  Widget _actionButton({
    required String label,
    required IconData icon,
    required Color iconColor,
    required Color textColor,
    required Color background,
    required Color borderColor,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: _isSubmitting ? null : onTap,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dateInfo({required String label, required String date}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            const Icon(
              Icons.calendar_today_outlined,
              size: 16,
              color: Colors.white70,
            ),
            const SizedBox(width: 6),
            Text(
              date,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _glassCard({
    required Widget child,
    EdgeInsetsGeometry padding = const EdgeInsets.all(18),
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: const Color(0xFF6E6A66).withOpacity(0.72),
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: Colors.white.withOpacity(0.18)),
          ),
          child: child,
        ),
      ),
    );
  }
}
