import 'package:flutter/material.dart';
import 'package:whatsapp_ui/features/auth/screans/user_information_screan.dart';
import 'package:whatsapp_ui/features/select_contacts/screens/select_contact_screen.dart';

import 'common/error.dart';
import 'features/auth/screans/login_screan.dart';
import 'features/auth/screans/otpscreen.dart';


Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginPage.routeName:
      return MaterialPageRoute(builder: (context) => const LoginPage());
    case OTPScreen.routeName:
      final verificationId = settings.arguments as String;
      return MaterialPageRoute(
          builder: (context) => OTPScreen(
                verificationId: verificationId,
              ));
    case UserInformationScreen.routeName:
      return MaterialPageRoute(
          builder: (context) => const UserInformationScreen());
    case SelectContactScreen.routeName:
      return MaterialPageRoute(
          builder: (context) => const SelectContactScreen());
    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: ErrorScreen(
            error: "This page dosn\'t exist",
          ),
        ),
      );
  }
}
