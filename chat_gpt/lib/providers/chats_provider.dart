import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/api_consts.dart';
import '../models/chat_model.dart';
import '../services/api_service.dart';
import '../widgets/text_widget.dart';

class ChatProvider with ChangeNotifier {
  ScrollController listScrollController = ScrollController();
  TextEditingController textEditingController = TextEditingController();
  FocusNode focusNode = FocusNode();

  final List<ChatModel> _chatList = [];
  List<ChatModel> get chatList => _chatList;

  bool _isTyping = false;
  bool get isTyping => _isTyping;

  Future<void> sendMessage(ChatProvider chatProvider, context) async {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: TextWidget(
            label: "Задайте вопрос",
          ),
          backgroundColor: Colors.red,
        ),
      );
      
    

      try {
        String message = textEditingController.text;

        _isTyping = true;
        chatProvider.addUsersMessage(msg: message);
        textEditingController.clear();
        focusNode.unfocus();

        await chatProvider.sendMessageAndGetAnswers(
            message: message, currentModelId: currentModel);

        notifyListeners();
      } catch (error) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: TextWidget(
            label: error.toString(),
          ),
          backgroundColor: Colors.red,
        ));
      } finally {
      
          _isTyping = false;
       notifyListeners();
      }
    
  }

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
