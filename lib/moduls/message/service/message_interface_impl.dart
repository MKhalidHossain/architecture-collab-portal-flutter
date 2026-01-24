import 'package:dana_bozzetto/core/api_handler/failure.dart';
import 'package:dana_bozzetto/core/api_handler/success.dart';
import 'package:dana_bozzetto/core/constants/api_endpoints.dart';
import 'package:dana_bozzetto/core/services/app_pigeon/app_pigeon.dart';
import 'package:dana_bozzetto/moduls/message/interface/message_interface.dart';
import 'package:dana_bozzetto/moduls/message/model/chat_models.dart';
import 'package:dana_bozzetto/moduls/message/model/create_chat_request_model.dart';
import 'package:dartz/dartz.dart';

final class MessageInterfaceImpl extends MessageInterface {
  final AppPigeon appPigeon;

  MessageInterfaceImpl({required this.appPigeon});

  @override
  Future<Either<DataCRUDFailure, Success<List<ChatModel>>>> fetchChats() {
    return asyncTryCatch(
      tryFunc: () async {
        final response = await appPigeon.get(ApiEndpoints.chats);
        final payload = _extractPayload(response.data);
        final chats = ChatModel.fromJsonList(payload);
        return Success(data: chats);
      },
    );
  }

  @override
  Future<Either<DataCRUDFailure, Success<ChatModel>>> createChat({
    required CreateChatRequestModel param,
  }) {
    return asyncTryCatch(
      tryFunc: () async {
        final response = await appPigeon.post(
          ApiEndpoints.chats,
          data: param.toJson(),
        );
        final payload = _extractPayload(response.data);
        if (payload is Map) {
          final chat = ChatModel.fromJson(
            Map<String, dynamic>.from(payload),
          );
          return Success(data: chat);
        }
        return Success(
          data: ChatModel(
            id: '',
            projectId: '',
            chatName: '',
            isGroupChat: false,
            users: const [],
            latestMessage: null,
            createdAt: null,
            updatedAt: null,
          ),
        );
      },
    );
  }

  dynamic _extractPayload(dynamic data) {
    if (data is Map) {
      final map = Map<String, dynamic>.from(data);
      if (map['data'] != null) {
        return map['data'];
      }
      if (map['item'] != null) {
        return map['item'];
      }
      if (map['chat'] != null) {
        return map['chat'];
      }
      return map;
    }
    return data;
  }
}
