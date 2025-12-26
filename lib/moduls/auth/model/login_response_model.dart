class LoginResponseModel {
  final String accessToken;
  final String refreshToken;
  final String userId;
  final String role;

  LoginResponseModel({
    required this.accessToken,
    required this.refreshToken,
    required this.userId,
    required this.role,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      userId: json['user']['id'],
      role: json['user']['role'],
    );
  }
}
