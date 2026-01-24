import 'dart:async';

import 'package:dana_bozzetto/moduls/message/interface/message_interface.dart';
import 'package:dana_bozzetto/moduls/message/model/chat_models.dart';
import 'package:dana_bozzetto/moduls/message/model/create_chat_request_model.dart';
import 'package:dana_bozzetto/moduls/message/model/message_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class ChatsController extends ChangeNotifier {
  bool _isLoading = false;
  String _errorMessage = '';
  List<ChatModel> _chats = <ChatModel>[];

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  List<ChatModel> get chats => _chats;

  StreamSubscription<MessageModel>? _messageSubscription;

  _listenToMessages() {
    _messageSubscription =
        Get.find<MessageInterface>().subscribeToMessages().listen((message) {

        });
  } 


  Future<void> fetchChats() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    final result = await Get.find<MessageInterface>().fetchChats();
    result.fold(
      (failure) {
        _errorMessage = failure.uiMessage.isNotEmpty
            ? failure.uiMessage
            : failure.fullError;
      },
      (success) {
        _chats = success.data ?? <ChatModel>[];
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<ChatModel?> createChat({
    required String userId,
    required String projectId,
  }) async {
    if (userId.trim().isEmpty || projectId.trim().isEmpty) {
      _errorMessage = 'User ID or project ID is missing.';
      notifyListeners();
      return null;
    }
    final result = await Get.find<MessageInterface>().createChat(
      param: CreateChatRequestModel(
        userId: userId,
        projectId: projectId,
      ),
    );
    ChatModel? created;
    result.fold(
      (failure) {
        _errorMessage = failure.uiMessage.isNotEmpty
            ? failure.uiMessage
            : failure.fullError;
      },
      (success) {
        created = success.data;
        final chat = success.data;
        if (chat != null && chat.id.isNotEmpty) {
          final index = _chats.indexWhere((item) => item.id == chat.id);
          if (index >= 0) {
            _chats[index] = chat;
          } else {
            _chats = [chat, ..._chats];
          }
        }
      },
    );
    notifyListeners();
    return created;
  }

  @override
  void dispose() {
    _isLoading = false;
    _errorMessage = '';
    _chats = <ChatModel>[];
    _messageSubscription?.cancel();
    super.dispose();
  }
}
