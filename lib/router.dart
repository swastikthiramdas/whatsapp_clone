import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
