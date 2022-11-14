import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/features/auth/repository/auth_repositorys.dart';

final authControllerProvider = Provider((ref) {
  final authRository = ref.watch(authRepositoryProvider);
  return AuthControllerler: authRository);
});

class AuthController {
  final AuthRepository authController;

  AuthController({required this.authController});

  void signInWithPhone(BuildContext context, String phoneNumber) {
    authController.signInWithPhone(context, phoneNumber);
  }
}
