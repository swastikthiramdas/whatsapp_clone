import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/common/enums/message_enum.dart';
import 'package:whatsapp_ui/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_ui/features/chat/repositorys/chat_repository.dart';
import 'package:whatsapp_ui/model/message.dart';

import '../../../model/chat_contact.dart';

final chatControllerProvider = Provider((ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return ChatController(chatRepository, ref);
});

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;

  ChatController(this.chatRepository, this.ref);

  Stream<List<ChatContact>> chatContacts() {
    return chatRepository.getChatContacts();
  }

  Stream<List<Message>> chatStream(String recieverUserId) {
    return chatRepository.getChatStream(recieverUserId);
  }

  void sendTextMessage(
    BuildContext context,
    String text,
    String reciverUseId,
  ) {
    ref.read(userDataAuthProvider).whenData(
          (value) => chatRepository.sendTextMessage(
            context: context,
            text: text,
            reciverUseId: reciverUseId,
            senderUser: value!,
          ),
        );
  }

/*  void sendGIFMessage(
    BuildContext context,
    String GifUrl,
    String reciverUseId,
  ) {
    ref.read(userDataAuthProvider).whenData(
          (value) => chatRepository.sendGIFMessage(
            context: context,
            GifUrl: GifUrl,
            reciverUseId: reciverUseId,
            senderUser: value!,
          ),
        );
  }*/

  void sendFileMessage(
    BuildContext context,
    File file,
    String reciverUserId,
    MessageEnum messageEnum,
  ) {
    ref
        .read(userDataAuthProvider)
        .whenData((value) => chatRepository.sendFileMessage(
              context: context,
              file: file,
              reciverUserId: reciverUserId,
              senderUserData: value!,
              ref: ref,
              messageEnum: messageEnum,
            ));
  }
}
