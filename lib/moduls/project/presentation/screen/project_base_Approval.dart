import 'dart:ui';
import 'package:dana_bozzetto/core/notifiers/snackbar_notifier.dart';
import 'package:dana_bozzetto/moduls/project/controller/project_approvals_controller.dart';
import 'package:dana_bozzetto/moduls/project/model/client_get_approvals_response_model.dart';
import 'package:dana_bozzetto/moduls/project/presentation/screen/approval_details_screen.dart';
import 'package:dana_bozzetto/moduls/project/model/team_portal_approvals_response_model.dart';
import 'package:flutter/material.dart';

const Color _accentColor = Color(0xFF0C7A7E);

class ProjectBaseApproval extends StatefulWidget {
  final bool isTeamMember;
  final String? projectId;
  final String? projectTitle;
  final String? projectSubtitle;
  final String? projectStatus;
  final String? coverImageUrl;

  const ProjectBaseApproval({
    super.key,
    this.isTeamMember = false,
    this.projectId,
    this.projectTitle,
    this.projectSubtitle,
    this.projectStatus,
    this.coverImageUrl,
  });

  @override
  State<ProjectBaseApproval> createState() => _ProjectBaseApprovalState();
}

class _ProjectBaseApprovalState extends State<ProjectBaseApproval> {
  int _selectedTab = 0;
  late final ProjectApprovalsController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ProjectApprovalsController();
    _controller.fetchApprovals();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final approvals =
              widget.isTeamMember ? _controller.teamApprovals : _controller.approvals;
          final teamScopedApprovals = widget.isTeamMember
              ? _scopeTeamApprovals(_controller.teamApprovals)
              : <TeamApprovalItem>[];
          final clientScopedApprovals = widget.isTeamMember
              ? <ClientGetApprovalsResponseModel>[]
              : _scopeApprovals(_controller.approvals);
          final counts = widget.isTeamMember
              ? _countTeamApprovals(teamScopedApprovals)
              : _countApprovals(clientScopedApprovals);
          final tabs = [
            "All (${counts.total})",
            "Pending (${counts.pending})",
            "Approved (${counts.approved})",
          ];
          final filteredApprovals = widget.isTeamMember
              ? _filterTeamApprovals(teamScopedApprovals)
              : _filterApprovals(clientScopedApprovals);
          final hasData = approvals.isNotEmpty;
          final showLoading = _controller.isLoading && !hasData;
          final showError = _controller.errorMessage.isNotEmpty && !hasData;

          return Column(
            children: [
              widget.isTeamMember
                  ? _buildTeamMemberHeader(
                      context,
                      tabs,
                      teamScopedApprovals,
                    )
                  : _buildHeader(context, tabs),
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        'assets/image/ab.png',
                        fit: BoxFit.cover,
                      ),
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
                        onRetry: _controller.fetchApprovals,
                      )
                    else if (filteredApprovals.isEmpty)
                      const Center(
                        child: Text(
                          "No approvals found",
                          style: TextStyle(color: Colors.white70),
                        ),
                      )
                    else
                      ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                        itemCount: filteredApprovals.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: widget.isTeamMember
                                ? _buildTeamMemberApprovalCard(
                                    filteredApprovals[index] as TeamApprovalItem,
                                  )
                                : _buildApprovalCard(
                                    filteredApprovals[index]
                                        as ClientGetApprovalsResponseModel,
                                  ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, List<String> tabs) {
    final headerTitle = _firstNonEmpty(
      widget.projectTitle,
      null,
      fallback: 'Approvals',
    );
    final headerSubtitle =
        _firstNonEmpty(widget.projectSubtitle, null, fallback: '');
    final headerStatus = _formatStatusLabel(widget.projectStatus);

    return Stack(
      children: [
        Image(
          image: _resolveImage(widget.coverImageUrl ?? ''),
          width: double.infinity,
          height: 300,
          fit: BoxFit.cover,
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            height: 320,
            padding: const EdgeInsets.fromLTRB(16, 56, 16, 16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.42),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Approvals",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  headerTitle,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (headerSubtitle.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    headerSubtitle,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
                if (headerStatus.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _accentColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      headerStatus,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(tabs.length, (i) {
                      final active = _selectedTab == i;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedTab = i),
                        child: Container(
                          margin: const EdgeInsets.only(right: 12),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: active
                                ? const Color(0xFF01676C)
                                : Colors.white.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(8),
                            border: active ? null : Border.all(color: Colors.white24),
                          ),
                          child: Text(
                            tabs[i],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: active ? FontWeight.w700 : FontWeight.w500,
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

  Widget _buildTeamMemberHeader(
    BuildContext context,
    List<String> tabs,
    List<TeamApprovalItem> approvals,
  ) {
    final headerTitle = _firstNonEmpty(
      widget.projectTitle,
      approvals.isNotEmpty ? approvals.first.projectName : null,
      fallback: 'Project',
    );
    final headerSubtitle =
        _firstNonEmpty(widget.projectSubtitle, null, fallback: '');
    final headerStatus = _formatStatusLabel(widget.projectStatus);

    return Stack(
      children: [
        Image(
          image: _resolveImage(widget.coverImageUrl ?? ''),
          width: double.infinity,
          height: 300,
          fit: BoxFit.cover,
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            height: 320,
            padding: const EdgeInsets.fromLTRB(16, 56, 16, 16),
            color: Colors.black.withOpacity(0.4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Approvals",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  headerTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (headerSubtitle.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    headerSubtitle,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _accentColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    headerStatus.isNotEmpty ? headerStatus : 'Active',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(tabs.length, (i) {
                      final active = _selectedTab == i;
                      final backgroundColor = active
                          ? _accentColor
                          : const Color(0xFFB0B0B0).withOpacity(0.6);
                      final textColor =
                          active ? Colors.white : const Color(0xFF2B2B2B);
                      return GestureDetector(
                        onTap: () => setState(() => _selectedTab = i),
                        child: Container(
                          margin: const EdgeInsets.only(right: 12),
                          width: 128,
                          height: 46,
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.35),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              tabs[i],
                              style: TextStyle(
                                color: textColor,
                                fontSize: 15,
                                fontWeight:
                                    active ? FontWeight.w700 : FontWeight.w600,
                              ),
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

  Widget _buildApprovalCard(ClientGetApprovalsResponseModel approval) {
    final statusView = _statusView(approval.status);
    final showActions = statusView.category == _ApprovalStatusCategory.pending;
    final title = approval.title?.trim();
    final projectName = approval.projectName?.trim();
    final description = approval.description?.trim();

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 12, 11, 11).withOpacity(0.25),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.12)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        title?.isNotEmpty == true
                            ? title!
                            : "Approval Request",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    _buildStatusBadge(statusView),
                  ],
                ),
                if (projectName != null && projectName.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    projectName,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
                const SizedBox(height: 10),
                Text(
                  description?.isNotEmpty == true
                      ? description!
                      : "No description provided.",
                  style: const TextStyle(
                    color: Colors.white70,
                    height: 1.4,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),

                // Requested by & Requested Date
                Row(
                  children: [
                    const Icon(
                      Icons.person_outline_rounded,
                      size: 16,
                      color: Colors.white60,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      approval.requestedBy?.trim().isNotEmpty == true
                          ? approval.requestedBy!
                          : "Requested by -",
                      style:
                          const TextStyle(color: Colors.white60, fontSize: 13),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 16,
                      color: Colors.white60,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _formatDate(approval.requestedDate),
                      style:
                          const TextStyle(color: Colors.white60, fontSize: 13),
                    ),
                  ],
                ),

                // Due Date
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.flag_outlined,
                        size: 16,
                        color: Colors.white60,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "Due ${_formatDate(approval.dueDate)}",
                        style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                if (showActions) ...[
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _buildButton(
                          label: "Reject",
                          isPrimary: false,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildButton(
                          label: "Review",
                          isPrimary: true,
                          onTap: () {
                            final approvalId = approval.id ?? '';
                            if (approvalId.trim().isEmpty) {
                              SnackbarNotifier(context: context).notifyError(
                                message: 'Approval ID is missing.',
                              );
                              return;
                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ApprovalDetailsScreen(
                                  approvalId: approvalId,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTeamMemberApprovalCard(
    TeamApprovalItem approval,
  ) {
    final badgeStyle = _teamStatusBadge(approval.status);
    final title = approval.title.trim().isNotEmpty
        ? approval.title.trim()
        : 'Approval Request';
    final description = approval.description.trim().isNotEmpty
        ? approval.description.trim()
        : 'Please review and approve the final design proposal.';
    final isApproved =
        _statusCategory(approval.status) == _ApprovalStatusCategory.approved;
    final fallbackBy = isApproved ? 'Admin' : 'Team';
    final requestedBy = approval.requestedBy.trim().isNotEmpty
        ? approval.requestedBy.trim()
        : fallbackBy;
    final requestedDate = approval.requestedDate;
    final approvedDate = approval.approvedDate ?? approval.requestedDate;
    final byLabelPrefix = isApproved ? 'Accepted by' : 'Requested by';

    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.2),
                Colors.black.withOpacity(0.35),
              ],
            ),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.white.withOpacity(0.35)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: badgeStyle.background,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Text(
                      badgeStyle.label,
                      style: TextStyle(
                        color: badgeStyle.textColor,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  const Icon(
                    Icons.person_outline_rounded,
                    size: 16,
                    color: Colors.white60,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '$byLabelPrefix $requestedBy',
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _dateColumn(
                      'Requested',
                      requestedDate,
                    ),
                  ),
                  if (isApproved) ...[
                    const SizedBox(width: 12),
                    Expanded(
                      child: _dateColumn(
                        'Approved date',
                        approvedDate,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dateColumn(String label, DateTime? date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12.5,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            const Icon(
              Icons.calendar_today_outlined,
              size: 16,
              color: Colors.white60,
            ),
            const SizedBox(width: 6),
            Text(
              _formatDateLong(date),
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

  _TeamStatusBadge _teamStatusBadge(String? status) {
    final category = _statusCategory(status);
    if (category == _ApprovalStatusCategory.pending) {
      return _TeamStatusBadge(
        label: _formatStatusLabel(status),
        background: const Color(0xFFF3E7B3),
        textColor: _accentColor,
      );
    }
    if (category == _ApprovalStatusCategory.approved) {
      return _TeamStatusBadge(
        label: _formatStatusLabel(status),
        background: _accentColor,
        textColor: Colors.white,
      );
    }
    return _TeamStatusBadge(
      label: _formatStatusLabel(status),
      background: Colors.white70,
      textColor: Colors.black87,
    );
  }

  Widget _buildStatusBadge(_ApprovalStatusView statusView) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: statusView.color.withOpacity(0.18),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        statusView.label,
        style: TextStyle(
          color: statusView.color,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildButton({
    required String label,
    required bool isPrimary,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: isPrimary ? const Color(0xFF01676C) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border:
              isPrimary ? null : Border.all(color: Colors.white30, width: 1.2),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMessage(String message, {VoidCallback? onRetry}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
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
      ),
    );
  }

  List<ClientGetApprovalsResponseModel> _scopeApprovals(
    List<ClientGetApprovalsResponseModel> approvals,
  ) {
    final projectId = widget.projectId?.trim() ?? '';
    final projectTitle = widget.projectTitle?.trim() ?? '';
    if (projectId.isEmpty && projectTitle.isEmpty) {
      return approvals;
    }
    return approvals.where((item) {
      if (projectId.isNotEmpty && item.projectId?.trim() == projectId) {
        return true;
      }
      if (projectTitle.isNotEmpty) {
        final name = item.projectName?.trim() ?? '';
        return name.toLowerCase() == projectTitle.toLowerCase();
      }
      return false;
    }).toList();
  }

  List<TeamApprovalItem> _scopeTeamApprovals(
    List<TeamApprovalItem> approvals,
  ) {
    final projectId = widget.projectId?.trim() ?? '';
    final projectTitle = widget.projectTitle?.trim() ?? '';
    if (projectId.isEmpty && projectTitle.isEmpty) {
      return approvals;
    }
    return approvals.where((item) {
      if (projectId.isNotEmpty && item.projectId == projectId) {
        return true;
      }
      if (projectTitle.isNotEmpty) {
        return item.projectName.toLowerCase() == projectTitle.toLowerCase();
      }
      return false;
    }).toList();
  }

  List<ClientGetApprovalsResponseModel> _filterApprovals(
    List<ClientGetApprovalsResponseModel> approvals,
  ) {
    if (_selectedTab == 0) {
      return approvals;
    }
    final filtered = <ClientGetApprovalsResponseModel>[];
    for (final approval in approvals) {
      final category = _statusCategory(approval.status);
      if (_selectedTab == 1 && category == _ApprovalStatusCategory.pending) {
        filtered.add(approval);
      }
      if (_selectedTab == 2 && category == _ApprovalStatusCategory.approved) {
        filtered.add(approval);
      }
    }
    return filtered;
  }

  List<TeamApprovalItem> _filterTeamApprovals(
    List<TeamApprovalItem> approvals,
  ) {
    if (_selectedTab == 0) {
      return approvals;
    }
    final filtered = <TeamApprovalItem>[];
    for (final approval in approvals) {
      final category = _statusCategory(approval.status);
      if (_selectedTab == 1 && category == _ApprovalStatusCategory.pending) {
        filtered.add(approval);
      }
      if (_selectedTab == 2 && category == _ApprovalStatusCategory.approved) {
        filtered.add(approval);
      }
    }
    return filtered;
  }

  _ApprovalCounts _countApprovals(
    List<ClientGetApprovalsResponseModel> approvals,
  ) {
    var pending = 0;
    var approved = 0;
    for (final approval in approvals) {
      final category = _statusCategory(approval.status);
      if (category == _ApprovalStatusCategory.pending) {
        pending += 1;
      } else if (category == _ApprovalStatusCategory.approved) {
        approved += 1;
      }
    }
    return _ApprovalCounts(
      total: approvals.length,
      pending: pending,
      approved: approved,
    );
  }

  _ApprovalCounts _countTeamApprovals(List<TeamApprovalItem> approvals) {
    var pending = 0;
    var approved = 0;
    for (final approval in approvals) {
      final category = _statusCategory(approval.status);
      if (category == _ApprovalStatusCategory.pending) {
        pending += 1;
      } else if (category == _ApprovalStatusCategory.approved) {
        approved += 1;
      }
    }
    return _ApprovalCounts(
      total: approvals.length,
      pending: pending,
      approved: approved,
    );
  }

  _ApprovalStatusView _statusView(String? status) {
    final normalized = status?.trim().toLowerCase() ?? '';
    final category = _statusCategory(status);
    Color color;
    if (category == _ApprovalStatusCategory.pending) {
      color = Colors.orange;
    } else if (category == _ApprovalStatusCategory.approved) {
      color = Colors.green;
    } else if (normalized == 'rejected' || normalized == 'declined') {
      color = Colors.redAccent;
    } else {
      color = Colors.blueAccent;
    }
    return _ApprovalStatusView(
      label: _formatStatusLabel(status),
      color: color,
      category: category,
    );
  }

  _ApprovalStatusCategory _statusCategory(String? status) {
    final normalized = status?.trim().toLowerCase() ?? '';
    if (normalized == 'approved') {
      return _ApprovalStatusCategory.approved;
    }
    if (normalized == 'pending' ||
        normalized == 'review' ||
        normalized.contains('waiting')) {
      return _ApprovalStatusCategory.pending;
    }
    return _ApprovalStatusCategory.other;
  }

  String _formatStatusLabel(String? status) {
    final raw = status?.trim();
    if (raw == null || raw.isEmpty) {
      return "Unknown";
    }
    final cleaned = raw.replaceAll(RegExp(r'[_-]+'), ' ');
    final parts = cleaned.split(RegExp(r'\s+'));
    final words = parts
        .where((part) => part.isNotEmpty)
        .map((part) => part[0].toUpperCase() + part.substring(1).toLowerCase())
        .toList();
    return words.isEmpty ? "Unknown" : words.join(' ');
  }

  String _formatDate(DateTime? date) {
    if (date == null) {
      return "-";
    }
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return "$day/$month/${date.year}";
  }

  String _formatDateLong(DateTime? date) {
    if (date == null) {
      return '-';
    }
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final month = months[date.month - 1];
    return '$month ${date.day.toString().padLeft(2, '0')}, ${date.year}';
  }

  String _firstNonEmpty(String? first, String? second, {String fallback = ''}) {
    if (first != null && first.trim().isNotEmpty) {
      return first.trim();
    }
    if (second != null && second.trim().isNotEmpty) {
      return second.trim();
    }
    return fallback;
  }

  ImageProvider _resolveImage(String source) {
    final value = source.trim();
    if (value.startsWith('http://') || value.startsWith('https://')) {
      return NetworkImage(value);
    }
    if (value.isNotEmpty) {
      return AssetImage(value);
    }
    return const AssetImage('assets/image/aa.png');
  }
}

class _ApprovalCounts {
  final int total;
  final int pending;
  final int approved;

  const _ApprovalCounts({
    required this.total,
    required this.pending,
    required this.approved,
  });
}

enum _ApprovalStatusCategory {
  pending,
  approved,
  other,
}

class _ApprovalStatusView {
  final String label;
  final Color color;
  final _ApprovalStatusCategory category;

  const _ApprovalStatusView({
    required this.label,
    required this.color,
    required this.category,
  });
}

class _TeamStatusBadge {
  final String label;
  final Color background;
  final Color textColor;

  const _TeamStatusBadge({
    required this.label,
    required this.background,
    required this.textColor,
  });
}
