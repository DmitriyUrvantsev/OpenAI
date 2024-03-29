import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import '../constants/constants.dart';
import '../services/assets_manager.dart';
import 'text_widget.dart';

//Виджет Item в чате ListView===================================================
class ChatWidget extends StatelessWidget {
  const ChatWidget(
      {super.key,
      required this.message,
      required this.chatIndex,
      this.shouldAnimate = false});

  final String message;
  final int chatIndex;
  final bool shouldAnimate;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          //в зависимомсти кто пишет Юзер или Бот применение разных свойств(иконки, цвет)
          color: chatIndex == 0 ? scaffoldBackgroundColor : cardColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  chatIndex == 0
                      ? AssetsManager.userImage
                      : AssetsManager.openaiLogo,
                  height: 30,
                  width: 30,
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: chatIndex == 0
                      ? TextWidget(
                          label: message,
                        )
                      : shouldAnimate
                          ? AnimatedTextKit(
                              isRepeatingAnimation: false,
                              repeatForever: false,
                              displayFullTextOnTap: true,
                              totalRepeatCount: 1,
                              animatedTexts: [
                                  TyperAnimatedText(
                                    message.trim(),
                                    textStyle: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16),
                                  ),
                                ])
                          : Text(
                              message.trim(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16),
                            ),
                ),
                // ===========типа лайк дизлайк- убрал пока
                // chatIndex == 0
                //     ? const SizedBox.shrink()
                //     : const Row(
                //         mainAxisAlignment: MainAxisAlignment.end,
                //         mainAxisSize: MainAxisSize.min,
                //         children: [
                //           Icon(
                //             Icons.thumb_up_alt_outlined,
                //             color: Colors.white,
                //           ),
                //           SizedBox(
                //             width: 5,
                //           ),
                //           Icon(
                //             Icons.thumb_down_alt_outlined,
                //             color: Colors.white,
                //           )
                //         ],
                //       ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
