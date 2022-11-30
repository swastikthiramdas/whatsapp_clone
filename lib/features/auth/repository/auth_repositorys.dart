import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/common/repositories/commom_firebase_storage.dart';
import 'package:whatsapp_ui/features/auth/screans/user_information_screan.dart';
import 'package:whatsapp_ui/common/utils/utils.dart';
import 'package:whatsapp_ui/model/user_model.dart';
import 'package:whatsapp_ui/screens/mobile_chat_screen.dart';

import '../screans/otpscreen.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository(
    auth: FirebaseAuth.instance, firestore: FirebaseFirestore.instance));

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthRepository({required this.auth, required this.firestore});

  void signInWithPhone(BuildContext context, String phoneNumber) async {
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
        },
        verificationFailed: (e) {
          throw Exception(e);
        },
        codeSent: ((String verificationId, int? resendToken) async {
          Navigator.pushNamed(context, OTPScreen.routeName,
              arguments: verificationId);
        }),
        codeAutoRetrievalTimeout: (String verifiationId) {},
      );
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!);
    }
  }

  void verifyOTP({
    required BuildContext context,
    required String verificationId,
    required String userOTP,
  }) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: userOTP);
      await auth.signInWithCredential(credential);
      Navigator.pushNamedAndRemoveUntil(
          context, UserInformationScreen.routeName, (route) => false);
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!);
    }
  }

  void saveUserDataToFirebase(
      {required String name,
      required File? profilePic,
      required ProviderRef ref,
      required BuildContext context}) async {
    try {
      String uid = auth.currentUser!.uid;
      String photoUrl = networkImg.toString();

      if (profilePic != null) {
        photoUrl = await ref
            .read(commonFirebaseStorageRepositoryProvider)
            .storageFileToFirebase(
              "profilepic/$uid",
              profilePic,
            );
      }

      var user = UserModel(
          name: name,
          uid: uid,
          phoneNumber: auth.currentUser!.uid,
          profilePic: photoUrl,
          isOnline: true,
          groupId: []);

      firestore.collection("user").doc(uid).set(user.toMap());
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const MobileChatScreen(),
          ),
          (route) => false);
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
