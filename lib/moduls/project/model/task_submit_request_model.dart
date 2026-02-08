import 'package:dio/dio.dart';

class TaskSubmitRequestModel {
  final String docName;
  final String docType;
  final String notes;
  final String fileName;
  final String? filePath;
  final List<int>? fileBytes;

  const TaskSubmitRequestModel({
    required this.docName,
    required this.docType,
    required this.notes,
    required this.fileName,
    this.filePath,
    this.fileBytes,
  });

  Future<FormData> toFormData() async {
    MultipartFile filePart;
    if (filePath != null && filePath!.isNotEmpty) {
      filePart = await MultipartFile.fromFile(
        filePath!,
        filename: fileName,
      );
    } else if (fileBytes != null) {
      filePart = MultipartFile.fromBytes(
        fileBytes!,
        filename: fileName,
      );
    } else {
      throw Exception('File is missing.');
    }

    return FormData.fromMap({
      'file': filePart,
      'docName': docName,
      'docType': docType,
      'notes': notes,
    });
  }
}
