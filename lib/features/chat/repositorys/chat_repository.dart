import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_ui/common/enums/message_enum.dart';
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
        var userData = await firestore
            .collection('user')
            .doc(chatContact.contactId)
            .get();
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



  Stream<List<Message>> getChatStream(String recieverUserId) {
    return firestore
        .collection('user')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(recieverUserId)
        .collection('messages')
        .snapshots()
        .map((event) {

      List<Message> messages = [];
      for (var document in event.docs) {
        messages.add(Message.fromMap(document.data()));
      }

      return messages;

    });
  }



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
      contactId: recieverUserData.uid,
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

    await firestore
        .collection('user')
        .doc(recieverUserId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
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
      recieverId: reviverUserId,
      text: text,
      isSeen: false,
      timeSent: timesent,
      type: messageType,
      messageId: messageId,
    );

    await firestore
        .collection('user')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(recieverUserName)
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

      _saveDataToContactSubCollection(
        senderUser,
        reciverUserData,
        text,
        timesent,
        reciverUseId,
      );

      var messageId = const Uuid().v4();

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
}
