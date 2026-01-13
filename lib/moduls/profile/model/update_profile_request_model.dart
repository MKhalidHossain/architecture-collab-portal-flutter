import 'package:dio/dio.dart';

class UpdateProfileRequestModel {
  final String? avatarPath;
  final String name;
  final String companyName;
  final String address;
  final String email;
  final String phoneNumber;

  UpdateProfileRequestModel({
    this.avatarPath,
    required this.name,
    required this.companyName,
    required this.address,
    required this.email,
    required this.phoneNumber,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'name': name,
      'companyName': companyName,
      'address': address,
      'email': email,
      'phoneNumber': phoneNumber,
    };
    if (avatarPath != null && avatarPath!.isNotEmpty) {
      data['avatar'] = avatarPath;
    }
    return data;
  }

  Future<FormData> toFormData() async {
    final data = <String, dynamic>{
      'name': name,
      'companyName': companyName,
      'address': address,
      'email': email,
      'phoneNumber': phoneNumber,
    };
    if (avatarPath != null && avatarPath!.isNotEmpty) {
      data['avatar'] = await MultipartFile.fromFile(avatarPath!);
    }
    return FormData.fromMap(data);
  }
}
