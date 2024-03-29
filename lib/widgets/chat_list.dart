import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_ui/common/utils/loader.dart';
import 'package:whatsapp_ui/features/chat/controller/chat_controller.dart';
import 'package:whatsapp_ui/model/message.dart';
import 'package:whatsapp_ui/features/chat/widgets/my_message_card.dart';
import 'package:whatsapp_ui/features/chat/widgets/sender_message_card.dart';

class ChatList extends ConsumerStatefulWidget {
  final String recieverUserId;

  const ChatList({Key? key, required this.recieverUserId}) : super(key: key);

  @override
  ConsumerState<ChatList> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final ScrollController _messageScroller = ScrollController();

  @override
  void dispose() {
    // TODO: implement dispos
    _messageScroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
      stream:
          ref.read(chatControllerProvider).chatStream(widget.recieverUserId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoaderScreen();
        }
        SchedulerBinding.instance.addPostFrameCallback((_) {
          _messageScroller.jumpTo(_messageScroller.position.maxScrollExtent);
        });
        return ListView.builder(
          controller: _messageScroller,
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final messageData = snapshot.data![index];
            if (messageData.senderId ==
                FirebaseAuth.instance.currentUser!.uid) {
              return MyMessageCard(
                messageEnum: messageData.type,
                message: messageData.text,
                date: DateFormat.Hm().format(messageData.timeSent),
              );
            }
            return SenderMessageCard(
              messageEnum: messageData.type,
              message: messageData.text,
              date: DateFormat.Hm().format(messageData.timeSent),
            );
          },
        );
      },
    );
  }
}
