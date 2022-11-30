import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/colors.dart';
import 'package:whatsapp_ui/features/auth/controller/auth_controller.dart';

class OTPScreen extends ConsumerWidget {
  static const String routeName = "/otp-screen";
  final String verificationId;
  const OTPScreen({Key? key, required this.verificationId}) : super(key: key);

  void verifyOTP(WidgetRef ref, BuildContext context , String userOTP){
    ref.read(authControllerProvider).verifyOTP(context, userOTP, verificationId);
  }
  @override
  Widget build(BuildContext context , WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Verify your number"),
        elevation: 0,
        backgroundColor: backgroundColor,
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: size.height/20),
            Text("We have sent an SMS with a code." , style: TextStyle(fontSize: 20),),
            SizedBox(
              width: size.width*0.5,
              child: TextField(
                maxLength: 6,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: "- - - - - -",
                  hintStyle: TextStyle(
                    fontSize: 30
                  )
                ),
                keyboardType: TextInputType.number,
                onChanged: (val){
                  if(val.length == 6){
                    verifyOTP(ref, context, val.trim());
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
