import 'package:flutter/material.dart';
import 'package:whatsapp_ui/features/auth/screans/login_screan.dart';

import '../../../colors.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  void NavigatToLoginScreen(BuildContext context){
    Navigator.pushNamed(context , LoginPage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            Center(
              child: Text(
                "Welcome to WhatsApp",
                style: TextStyle(fontSize: 33, fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(height: size.height / 9),
            Image.asset("assets/bg.png",
                height: 340, width: 340, color: tabColor),
            SizedBox(height: size.height / 9),
            // SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: const Text(
                'Read our Privacy Policy. Tap "Agre and continue" to accept the Terms and Service.',
                style: TextStyle(color: grey),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: size.width/9 , left: size.width/9 , top: size.height/10 ),
              child: ElevatedButton(
                onPressed: () => NavigatToLoginScreen(context),
                child: Center(child: Text("AGREE AND CONTIUE")),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
