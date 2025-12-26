class ResetPasswordRequestModel {
  final String userId;
  final String newPassword;
  final String confirmPassword;

  ResetPasswordRequestModel({
    required this.userId,
    required this.newPassword,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'newPassword': newPassword,
      'confirmPassword': confirmPassword,
    };
  }

  // Convert a Map to a ResetPasswordRequestModel object
  factory ResetPasswordRequestModel.fromJson(Map<String, dynamic> json) {
    return ResetPasswordRequestModel(
      userId: json['userId'],
      newPassword: json['newPassword'],
      confirmPassword: json['confirmPassword'],
    );
  }
}
