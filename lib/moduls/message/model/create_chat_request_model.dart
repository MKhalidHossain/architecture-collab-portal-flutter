class CreateChatRequestModel {
  final String userId;
  final String projectId;

  CreateChatRequestModel({
    required this.userId,
    required this.projectId,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'projectId': projectId,
    };
  }
}
