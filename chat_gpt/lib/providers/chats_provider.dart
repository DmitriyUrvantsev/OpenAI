import 'package:flutter/cupertino.dart';

import '../models/chat_model.dart';
import '../services/api_service.dart';

class ChatProvider with ChangeNotifier {
  ScrollController? listScrollController;
  final List<ChatModel> _chatList = [];
  List<ChatModel> get chatList => _chatList;





  void addUsersMessage({required String msg}) {
    _chatList.add(ChatModel(message: msg, chatIndex: 0));
    notifyListeners();
  }

  Future<void> sendMessageAndGetAnswers(
      {required String message, required String currentModelId}) async {
    _chatList.addAll(await ApiService.sendMessageGPT(
      message: message,
      modelId: currentModelId,
    ));
    notifyListeners();
  }

//=======автоскрол ListView при достижении низа экрана===================
  void scrollListToEND() {
    if (listScrollController == null) return;
    if (listScrollController != null) {
      listScrollController!
          .animateTo(listScrollController!.position.maxScrollExtent,
              duration: const Duration(milliseconds: 500), //!===
              curve: Curves.easeOut);
      notifyListeners();
    }
  }
}
