class RefreshTokenResponseModel {
  final String token;

  RefreshTokenResponseModel({required this.token});

  factory RefreshTokenResponseModel.fromJson(Map<String, dynamic> json) {
    String readString(dynamic value) => value?.toString() ?? '';
    String pickFirstString(List<dynamic> values) {
      for (final value in values) {
        final stringValue = readString(value);
        if (stringValue.isNotEmpty) {
          return stringValue;
        }
      }
      return '';
    }

    final data = json['data'] is Map ? Map<String, dynamic>.from(json['data']) : json;
    final token = pickFirstString([
      data['token'],
      data['access_token'],
      data['accessToken'],
      json['token'],
      json['access_token'],
      json['accessToken'],
    ]);

    return RefreshTokenResponseModel(token: token);
  }
}
