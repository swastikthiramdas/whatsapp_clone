import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/features/auth/repository/auth_repositorys.dart';

final authControllerProvider = Provider((ref) {
  final authRository = ref.watch(authRepositoryProvider);
  return AuthController(authRepository: authRository , ref: ref);
});

class AuthController {
  final AuthRepository authRepository;
  final ProviderRef ref;
  AuthController({required this.ref, required this.authRepository});


  void signInWithPhone(BuildContext context, String phoneNumber) {
    authRepository.signInWithPhone(context, phoneNumber);
  }

  void verifyOTP(BuildContext context, String userOTP, String verificationId) {
    authRepository.verifyOTP(
        context: context, verificationId: verificationId, userOTP: userOTP);
  }

  void saveUserdataToFirebase(BuildContext context, String name,
      File? profilePic) {
    authRepository.saveUserDataToFirebase(
        name: name, profilePic: profilePic, ref: ref, context: context);
  }

}
