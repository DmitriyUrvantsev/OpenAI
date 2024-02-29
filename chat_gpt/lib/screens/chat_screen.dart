import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import '../constants/constants.dart';
import '../providers/chats_provider.dart';
import '../widgets/chat_widget.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ChatProvider>(context);
//Автоскрол при достижении низа экрана Юзером или Ботом
    Timer(const Duration(milliseconds: 200), () => provider.scrollListToEND());
//Автоскрол   
    return Scaffold(
//
//
// ======================AppBar виджет=======================================
      appBar: AppBar(
        elevation: 2,
        title: const Center(
            child: Text(
          "ChatGPT",
          style: TextStyle(color: Colors.green),
        )),
        shadowColor: Colors.black,
      ),

//
//
// ======================Body виджет=======================================
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              //ListView==========
              child: ListView.builder(
                  controller: provider.listScrollController,
                  itemCount: provider.chatList.length,
                  itemBuilder: (context, index) {
                    return 
                    //Item-----
                    ChatWidget(
                      message: provider.chatList[index].message,
                      chatIndex: provider.chatList[index].chatIndex,
                      shouldAnimate: provider.chatList.length - 1 == index,
                    );
                  }),
            ),
            //Индикатор==========
            if (provider.isTyping) ...[
              const SpinKitThreeBounce(
                color: Colors.white,
                size: 16,
              ),
            ] else
              const SizedBox(height: 16),
            const SizedBox(
              height: 15,
            ),
//
//
// ======================TextFeild виджет=======================================
            Material(
              color: cardColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        focusNode: provider.focusNode,
                        style: const TextStyle(color: Colors.white),
                        controller: provider.textEditingController,
                        onSubmitted: (value) async {
                          await provider.sendMessage(provider, context);
                        },
                        decoration: const InputDecoration.collapsed(
                            hintText: "Чем я могу помочь?",
                            hintStyle: TextStyle(color: Colors.grey)),
                      ),
                    ),
                    IconButton(
                        onPressed: () async {
                          await provider.sendMessage(provider, context);
                        },
                        icon: const Icon(
                          Icons.send,
                          color: Colors.white,
                        ))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
