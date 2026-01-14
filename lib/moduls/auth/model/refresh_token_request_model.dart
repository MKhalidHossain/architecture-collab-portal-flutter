class RefreshTokenRequestModel {
  final String refreshToken;

  RefreshTokenRequestModel({required this.refreshToken});

  Map<String, dynamic> toJson() {
    return {
      'refreshToken': refreshToken,
    };
  }
}
