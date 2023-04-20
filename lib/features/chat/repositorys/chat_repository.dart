import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_ui/common/enums/message_enum.dart';
import 'package:whatsapp_ui/common/repositories/commom_firebase_storage.dart';
import 'package:whatsapp_ui/common/utils/utils.dart';
import 'package:whatsapp_ui/model/chat_contact.dart';
import 'package:whatsapp_ui/model/message.dart';
import 'package:whatsapp_ui/model/user_model.dart';

final chatRepositoryProvider = Provider(
  (ref) => ChatRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  ),
);

class ChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ChatRepository({required this.firestore, required this.auth});

  //No Problem
  Stream<List<ChatContact>> getChatContacts() {
    return firestore
        .collection('user')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .snapshots()
        .asyncMap((event) async {
      List<ChatContact> contacts = [];

      for (var document in event.docs) {
        var chatContact = ChatContact.fromMap(document.data());

        var userData =
            await firestore.collection('user').doc(chatContact.contactId).get();

        var user = UserModel.fromMap(userData.data()!);

        contacts.add(
          ChatContact(
            name: user.name,
            profilePic: user.profilePic,
            contactId: chatContact.contactId,
            timeSent: chatContact.timeSent,
            lastMessage: chatContact.lastMessage,
          ),
        );
      }

      return contacts;
    });
  }

  //No Problem
  Stream<List<Message>> getChatStream(String recieverUserId) {
    return firestore
        .collection('user')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(recieverUserId)
        .collection('messages')
        .orderBy('timeSent')
        .snapshots()
        .map(
      (event) {
        List<Message> messages = [];

        for (var document in event.docs) {
          messages.add(Message.fromMap(document.data()));
        }

        return messages;
      },
    );
  }

  //Last Message No Problem
  void _saveDataToContactSubCollection(
    UserModel senderUserData,
    UserModel recieverUserData,
    String text,
    DateTime timeSent,
    String recieverUserId,
  ) async {
    //reciever userchat
    var recieverChatContact = ChatContact(
      name: senderUserData.name,
      profilePic: senderUserData.profilePic,
      contactId: senderUserData.uid,
      lastMessage: text,
      timeSent: timeSent,
    );

    await firestore
        .collection('user')
        .doc(recieverUserId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .set(
          recieverChatContact.toMap(),
        );

    //sender usere
    var senderChatContact = ChatContact(
      name: recieverUserData.name,
      profilePic: recieverUserData.profilePic,
      contactId: recieverUserId,
      lastMessage: text,
      timeSent: timeSent,
    );

    await firestore
        .collection('user')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(recieverUserId)
        .set(
          senderChatContact.toMap(),
        );
  }

  void _saveMessageToMessageSubCollecton({
    required String reviverUserId,
    required String text,
    required DateTime timesent,
    required String messageId,
    required String userName,
    required recieverUserName,
    required MessageEnum messageType,
  }) async {
    final message = Message(
      senderId: auth.currentUser!.uid,
      recieverid: reviverUserId,
      text: text,
      type: messageType,
      timeSent: timesent,
      messageId: messageId,
      isSeen: false,
    );

    await firestore
        .collection('user')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(reviverUserId)
        .collection('messages')
        .doc(messageId)
        .set(
          message.toMap(),
        );

    await firestore
        .collection('user')
        .doc(reviverUserId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .collection('messages')
        .doc(messageId)
        .set(
          message.toMap(),
        );
  }

  void sendTextMessage(
      {required BuildContext context,
      required String text,
      required String reciverUseId,
      required UserModel senderUser}) async {
    try {
      var timesent = DateTime.now();

      UserModel reciverUserData;

      var userDataMap =
          await firestore.collection('user').doc(reciverUseId).get();

      reciverUserData = UserModel.fromMap(userDataMap.data()!);

      /*No Problem Last MessageLast Message*/
      _saveDataToContactSubCollection(
        senderUser,
        reciverUserData,
        text,
        timesent,
        reciverUseId,
      );

      var messageId = const Uuid().v4();

      //Send Message Problem
      _saveMessageToMessageSubCollecton(
        reviverUserId: reciverUseId,
        text: text,
        timesent: timesent,
        messageType: MessageEnum.text,
        messageId: messageId,
        recieverUserName: reciverUserData.name,
        userName: senderUser.name,
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void sendFileMessage({
    required BuildContext context,
    required File file,
    required String reciverUserId,
    required UserModel senderUserData,
    required ProviderRef ref,
    required MessageEnum messageEnum,
  }) async {
    try {
      var timeSent = DateTime.now();
      var messageId = const Uuid().v1();

      var imageUri = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storageFileToFirebase(
            "chat/${messageEnum.type}/${senderUserData.uid}/${reciverUserId}/${messageId}",
            file,
          );

      UserModel recieverUserData;
      var userDataMap =
          await firestore.collection('user').doc(reciverUserId).get();
      recieverUserData = UserModel.fromMap(userDataMap.data()!);

      String contactMsg;

      switch (messageEnum) {
        case MessageEnum.image:
          contactMsg = 'image';
          break;
        case MessageEnum.video:
          contactMsg = 'video';
          break;
        case MessageEnum.gif:
          contactMsg = 'gif';
          break;
        case MessageEnum.audio:
          contactMsg = 'audio';
          break;
        default:
          contactMsg = 'audio';
      }

      _saveDataToContactSubCollection(senderUserData, recieverUserData,
          contactMsg, timeSent, reciverUserId);

      _saveMessageToMessageSubCollecton(
        reviverUserId: reciverUserId,
        text: imageUri,
        timesent: timeSent,
        messageId: messageId,
        userName: senderUserData.name,
        recieverUserName: recieverUserData.name,
        messageType: messageEnum,
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

/*
  void sendGIFMessage(
      {required BuildContext context,
        required String GifUrl,
        required String reciverUseId,
        required UserModel senderUser}) async {
    try {
      var timesent = DateTime.now();

      UserModel reciverUserData;

      var userDataMap =
      await firestore.collection('user').doc(reciverUseId).get();

      reciverUserData = UserModel.fromMap(userDataMap.data()!);

      */
/*No Problem Last MessageLast Message*//*

      _saveDataToContactSubCollection(
        senderUser,
        reciverUserData,
        'GIF',
        timesent,
        reciverUseId,
      );

      var messageId = const Uuid().v4();

      //Send Message Problem
      _saveMessageToMessageSubCollecton(
        reviverUserId: reciverUseId,
        text: GifUrl,
        timesent: timesent,
        messageType: MessageEnum.gif,
        messageId: messageId,
        recieverUserName: reciverUserData.name,
        userName: senderUser.name,
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

*/


}
