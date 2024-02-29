import 'package:flutter/cupertino.dart';

import '../models/chat_model.dart';
import '../services/api_service.dart';

class ChatProvider with ChangeNotifier {
  ScrollController? listScrollController;
  List<ChatModel> chatList = [];
  List<ChatModel> get getChatList {
    return chatList;
  }

  void addUserMessage({required String msg}) {
    chatList.add(ChatModel(msg: msg, chatIndex: 0));
    notifyListeners();
  }

  Future<void> sendMessageAndGetAnswers(
      {required String msg, required String chosenModelId}) async {
    if (chosenModelId.toLowerCase().startsWith("gpt")) {
      chatList.addAll(await ApiService.sendMessageGPT(
        message: msg,
        modelId: chosenModelId,
      ));
    } else {
      chatList.addAll(await ApiService.sendMessage(
        message: msg,
        modelId: chosenModelId,
      ));
    }
  
    notifyListeners();
  }

  void scrollListToEND() {
   if (listScrollController == null) return;
   if(listScrollController != null){
    listScrollController!.animateTo(
        listScrollController!.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500), //!===
        curve: Curves.easeOut);
    notifyListeners();    
  }
  }
}
