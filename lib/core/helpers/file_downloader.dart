import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class FileDownloader {
  static Future<String> download({
    required String url,
    required String filenameHint,
    void Function(double progress)? onProgress,
  }) async {
    final dir = await getApplicationDocumentsDirectory();
    final fileName = _buildFileName(filenameHint, url);
    final filePath = '${dir.path}/$fileName';
    await Dio().download(
      url,
      filePath,
      onReceiveProgress: (received, total) {
        if (total <= 0) {
          return;
        }
        onProgress?.call(received / total);
      },
    );
    return filePath;
  }

  static String _buildFileName(String title, String url) {
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
}
