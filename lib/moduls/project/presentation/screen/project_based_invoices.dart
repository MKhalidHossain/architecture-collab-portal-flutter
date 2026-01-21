import 'dart:io';
import 'dart:ui';
import 'package:dana_bozzetto/moduls/project/controller/project_invoices_controller.dart';
import 'package:dana_bozzetto/moduls/project/model/project_finance_item.dart';
import 'package:dana_bozzetto/moduls/project/presentation/screen/invoice_pdf_preview_screen.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

class ProjectInvoicesScreen extends StatefulWidget {
  const ProjectInvoicesScreen({super.key});

  @override
  State<ProjectInvoicesScreen> createState() => _ProjectInvoicesScreenState();
}

class _ProjectInvoicesScreenState extends State<ProjectInvoicesScreen> {
  late final ProjectInvoicesController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ProjectInvoicesController();
    _controller.fetchFinances();
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
        final finances = _controller.finances;
        final totals = _resolveTotals(finances);
        final totalAmount = totals.totalAmount;
        final totalPaid = totals.totalPaid;
        final totalUnpaid = totals.totalUnpaid;
        final hasData = finances.isNotEmpty;
        final showLoading = _controller.isLoading && !hasData;
        final showError = _controller.errorMessage.isNotEmpty && !hasData;

        return Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              Positioned.fill(
                child: Image.asset('assets/image/ab.png', fit: BoxFit.cover),
              ),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(
                  color: Colors.black.withOpacity(0.45),
                  child: SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _header(context),
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
                                      onRetry: _controller.fetchFinances,
                                    )
                                  : finances.isEmpty
                                      ? const Center(
                                          child: Text(
                                            "No invoices found",
                                            style: TextStyle(
                                              color: Colors.white70,
                                            ),
                                          ),
                                        )
                                      : SingleChildScrollView(
                                          physics:
                                              const BouncingScrollPhysics(),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "Projects Overview",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const SizedBox(height: 16),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  _buildStatCard(
                                                    icon: Icons
                                                        .attach_money_rounded,
                                                    color: Colors.blue,
                                                    amount: _formatCurrency(
                                                      totalAmount,
                                                    ),
                                                    label: "Total Budget",
                                                  ),
                                                  _buildStatCard(
                                                    icon:
                                                        Icons.attach_money_rounded,
                                                    color: Colors.teal,
                                                    amount: _formatCurrency(
                                                      totalPaid,
                                                    ),
                                                    label: "Total Paid",
                                                  ),
                                                  _buildStatCard(
                                                    icon: Icons
                                                        .attach_money_rounded,
                                                    color: Colors.orange,
                                                    amount: _formatCurrency(
                                                      totalUnpaid,
                                                    ),
                                                    label: "Unpaid",
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 32),
                                              ...finances.map(
                                                (item) => _buildInvoiceCard(
                                                  invoiceNumber:
                                                      item.customId ??
                                                          item.id ??
                                                          "-",
                                                  amount: _formatCurrency(
                                                    item.totalAmount,
                                                  ),
                                                  status:
                                                      item.status ?? "Pending",
                                                  statusColor: _statusColor(
                                                    item.status,
                                                  ),
                                                  description:
                                                      _resolveDescription(item),
                                                  issued: _formatDateLabel(
                                                    "Issued",
                                                    item.createdAt,
                                                  ),
                                                  due: _formatDateLabel(
                                                    "Due",
                                                    item.updatedAt,
                                                  ),
                                                  onDownload: () =>
                                                      _handleDownload(
                                                        context,
                                                        item: item,
                                                      ),
                                                  onPreview: () => _handlePreview(
                                                    context,
                                                    item: item,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 40),
                                            ],
                                          ),
                                        ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
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
                "Invoices",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            "Modern Villa Design",
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _formatDate(DateTime.now()),
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color color,
    required String amount,
    required String label,
  }) {
    return Expanded(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.09),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.12)),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: color.withOpacity(0.9),
                  child: Icon(icon, color: Colors.white, size: 28),
                ),
                const SizedBox(height: 12),
                Text(
                  amount,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  label,
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInvoiceCard({
    required String invoiceNumber,
    required String amount,
    required String status,
    required Color statusColor,
    required String description,
    required String issued,
    required String due,
    VoidCallback? onDownload,
    VoidCallback? onPreview,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.09),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.12)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      invoiceNumber,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      amount,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Text(
                    status,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 20),

                // Dates
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 16,
                      color: Colors.white60,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      issued,
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 13,
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.flag_outlined,
                      size: 16,
                      color: Colors.white60,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      due,
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: _buildActionButton(
                        label: "Download",
                        icon: Icons.download_rounded,
                        isPrimary: true,
                        onTap: onDownload,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildActionButton(
                        label: "Preview",
                        icon: Icons.remove_red_eye_rounded,
                        isPrimary: false,
                        onTap: onPreview,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required bool isPrimary,
    VoidCallback? onTap,
  }) {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: isPrimary ? const Color(0xFF01676C) : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        border: isPrimary
            ? null
            : Border.all(color: Colors.white30, width: 1.3),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 18),
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

  _FinanceTotals _resolveTotals(List<ProjectFinanceItem> items) {
    num total = 0;
    num paid = 0;
    for (final item in items) {
      final amount = item.totalAmount ?? 0;
      total += amount;
      if (_isPaid(item.status)) {
        paid += amount;
      }
    }
    return _FinanceTotals(
      totalAmount: total,
      totalPaid: paid,
      totalUnpaid: total - paid,
    );
  }

  bool _isPaid(String? status) {
    final value = status?.toLowerCase().trim();
    return value == 'paid';
  }

  Color _statusColor(String? status) {
    final value = status?.toLowerCase().trim();
    if (value == 'paid') {
      return Colors.teal;
    }
    if (value == 'pending') {
      return Colors.orange;
    }
    if (value == 'overdue') {
      return Colors.redAccent;
    }
    return const Color(0xFF01676C);
  }

  String _formatDate(DateTime date) {
    const months = <String>[
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
    return "$month ${date.day}, ${date.year}";
  }

  String _formatDateLabel(String label, DateTime? date) {
    if (date == null) {
      return "$label -";
    }
    return "$label ${_formatDate(date)}";
  }

  String _formatCurrency(num? amount) {
    final value = amount ?? 0;
    final absValue = value.abs();
    String formatted;
    if (absValue >= 1000000) {
      final compact = (value / 1000000).toStringAsFixed(1);
      formatted = "${_trimTrailingZero(compact)}M";
    } else if (absValue >= 1000) {
      final compact = (value / 1000).toStringAsFixed(1);
      formatted = "${_trimTrailingZero(compact)}K";
    } else {
      formatted = value % 1 == 0
          ? value.toStringAsFixed(0)
          : value.toStringAsFixed(2);
    }
    return '\$$formatted';
  }

  String _trimTrailingZero(String value) {
    if (value.endsWith('.0')) {
      return value.substring(0, value.length - 2);
    }
    return value;
  }

  String _resolveDescription(ProjectFinanceItem item) {
    final notes = item.notes?.trim();
    if (notes != null && notes.isNotEmpty) {
      return notes;
    }
    final descriptions = item.lineItems
        .map((line) => line.description?.trim())
        .where((description) => description != null && description.isNotEmpty)
        .cast<String>()
        .toList();
    if (descriptions.isNotEmpty) {
      return descriptions.length > 1
          ? "${item.type ?? 'Item'}: ${descriptions.take(2).join(', ')}"
          : "${item.type ?? 'Item'}: ${descriptions.first}";
    }
    return item.type?.trim().isNotEmpty == true
        ? item.type!
        : "No details available";
  }

  Future<void> _handlePreview(
    BuildContext context, {
    required ProjectFinanceItem item,
  }) async {
    try {
      final filePath = await _saveInvoicePdf(item, isPreview: true);
      if (!context.mounted) {
        return;
      }
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => InvoicePdfPreviewScreen(
            filePath: filePath,
            title: item.customId ?? "Invoice",
          ),
        ),
      );
    } catch (_) {
      if (!context.mounted) {
        return;
      }
      _showMessage(context, "Unable to preview this invoice.");
    }
  }

  Future<void> _handleDownload(
    BuildContext context, {
    required ProjectFinanceItem item,
  }) async {
    try {
      final filePath = await _saveInvoicePdf(item, isPreview: false);
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

  Future<String> _saveInvoicePdf(
    ProjectFinanceItem item, {
    required bool isPreview,
  }) async {
    final bytes = await _buildInvoicePdfBytes(item);
    final dir = isPreview
        ? await getTemporaryDirectory()
        : await getApplicationDocumentsDirectory();
    final fileName = _buildInvoiceFileName(item);
    final filePath = '${dir.path}/$fileName';
    final file = File(filePath);
    await file.writeAsBytes(bytes, flush: true);
    return file.path;
  }

  String _buildInvoiceFileName(ProjectFinanceItem item) {
    final base =
        (item.customId ?? item.id ?? 'invoice').replaceAll(RegExp(r'\s+'), '_');
    final safe = base.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '');
    return '$safe.pdf';
  }

  Future<List<int>> _buildInvoicePdfBytes(ProjectFinanceItem item) async {
    final pdf = pw.Document();
    final issueDate = _formatDate(item.createdAt ?? DateTime.now());
    final dueDate = _formatDate(item.updatedAt ?? DateTime.now());
    final title = item.customId ?? item.type ?? 'Invoice';

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Text(
            title,
            style: pw.TextStyle(
              fontSize: 24,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Text('Status: ${item.status ?? "Pending"}'),
          pw.SizedBox(height: 6),
          pw.Text('Issued: $issueDate'),
          pw.Text('Due: $dueDate'),
          pw.SizedBox(height: 12),
          if (item.client != null) ...[
            pw.Text('Client: ${item.client?.name ?? "-"}'),
            pw.Text('Email: ${item.client?.email ?? "-"}'),
            pw.SizedBox(height: 12),
          ],
          pw.Text(
            'Line Items',
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 6),
          pw.Table.fromTextArray(
            headers: const ['Description', 'Qty', 'Rate', 'Amount'],
            data: item.lineItems.isEmpty
                ? [
                    ['-', '-', '-', '-'],
                  ]
                : item.lineItems.map((line) {
                    return [
                      line.description ?? '-',
                      '${line.quantity ?? 0}',
                      _formatCurrency(line.rate),
                      _formatCurrency(line.amount),
                    ];
                  }).toList(),
          ),
          pw.SizedBox(height: 16),
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text('Subtotal: ${_formatCurrency(item.subtotal)}'),
                pw.Text('Tax (${item.taxRate ?? 0}%): '
                    '${_formatCurrency(item.taxAmount)}'),
                pw.Text('Discount: ${_formatCurrency(item.discount)}'),
                pw.SizedBox(height: 8),
                pw.Text(
                  'Total: ${_formatCurrency(item.totalAmount)}',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          if ((item.notes ?? '').trim().isNotEmpty) ...[
            pw.SizedBox(height: 16),
            pw.Text(
              'Notes',
              style: pw.TextStyle(
                fontSize: 14,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 4),
            pw.Text(item.notes!.trim()),
          ],
        ],
      ),
    );

    return pdf.save();
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
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
}

class _FinanceTotals {
  final num totalAmount;
  final num totalPaid;
  final num totalUnpaid;

  const _FinanceTotals({
    required this.totalAmount,
    required this.totalPaid,
    required this.totalUnpaid,
  });
}
