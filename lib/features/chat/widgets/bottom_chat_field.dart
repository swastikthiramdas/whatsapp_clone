import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/colors.dart';

import '../controller/chat_controller.dart';

class BottomChatField extends ConsumerStatefulWidget {
  final String recieverUserId;

  const BottomChatField(this.recieverUserId, {Key? key}) : super(key: key);

  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  bool isShowAndHideButtons = false;
  final TextEditingController _messageController = TextEditingController();



  void sendTextMessage() {
    if (isShowAndHideButtons) {
      ref.read(chatControllerProvider).sendTextMessage(
            context,
            _messageController.text.trim(),
            widget.recieverUserId,
          );

      setState(() {
        _messageController.text = "";
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _messageController,
            onChanged: (val) {
              if (val.isNotEmpty) {
                setState(() {
                  isShowAndHideButtons = true;
                });
              } else {
                setState(() {
                  isShowAndHideButtons = false;
                });
              }
            },
            decoration: InputDecoration(
              labelStyle: TextStyle(color: Colors.white),
              filled: true,
              fillColor: mobileChatBoxColor,
              prefixIcon: SizedBox(
                width: isShowAndHideButtons ? 50 : 100,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.emoji_emotions,
                        color: Colors.grey,
                      ),
                    ),
                    isShowAndHideButtons
                        ? const SizedBox(width: 1)
                        : const Icon(
                            Icons.gif,
                            color: Colors.grey,
                          ),
                  ],
                ),
              ),
              suffixIcon: SizedBox(
                width: isShowAndHideButtons ? 50 : 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    isShowAndHideButtons
                        ? const SizedBox(width: 1)
                        : IconButton(
                            padding: EdgeInsets.symmetric(horizontal: 1),
                            onPressed: () {},
                            icon: Icon(
                              Icons.camera_alt,
                              color: Colors.grey,
                            ),
                          ),
                    IconButton(
                      padding: EdgeInsets.symmetric(horizontal: 1),
                      onPressed: () {},
                      icon: Icon(
                        Icons.attach_file,
                        color: Colors.grey,
                      ),
                    )
                  ],
                ),
              ),
              hintText: 'Type a message!',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: const BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
              contentPadding: const EdgeInsets.all(10),
            ),
          ),
        ),
        SizedBox(width: size.width / 10 * 0.010),
        Padding(
          padding: EdgeInsets.only(left: size.width * 0.04),
          child: CircleAvatar(
            radius: 25,
            backgroundColor: Color(0xFF128C7E),
            child: GestureDetector(
              child: Icon(
                isShowAndHideButtons ? Icons.send : Icons.mic,
                color: Colors.white,
              ),
              onTap: sendTextMessage,
            ),
          ),
        )
      ],
    );
  }
}
