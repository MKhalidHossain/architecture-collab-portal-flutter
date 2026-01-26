import 'package:dana_bozzetto/core/api_handler/base_repository.dart';
import 'package:dana_bozzetto/core/api_handler/failure.dart';
import 'package:dana_bozzetto/core/api_handler/success.dart';
import 'package:dana_bozzetto/moduls/message/model/chat_models.dart';
import 'package:dana_bozzetto/moduls/message/model/create_chat_request_model.dart';
import 'package:dana_bozzetto/moduls/message/model/message_model.dart';
import 'package:dartz/dartz.dart';

abstract base class MessageInterface extends BaseRepository {
  Future<Either<DataCRUDFailure, Success<List<ChatModel>>>> fetchChats();

  Future<Either<DataCRUDFailure, Success<ChatModel>>> createChat({
    required CreateChatRequestModel param,
  });

  Future<Either<DataCRUDFailure, Success<List<MessageModel>>>> fetchMessages({
    required String chatId,
  });

  Stream<MessageModel> subscribeToMessages();
}
