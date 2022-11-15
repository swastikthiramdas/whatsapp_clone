import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/features/auth/repository/auth_repositorys.dart';

final authControllerProvider = Provider((ref) {
  final authRository = ref.watch(authRepositoryProvider);
  return AuthController(authRepository: authRository);
});

class AuthController {
  final AuthRepository authRepository;

  AuthController({required this.authRepository});


  void signInWithPhone(BuildContext context, String phoneNumber) {
    authRepository.signInWithPhone(context, phoneNumber);
  }
}
