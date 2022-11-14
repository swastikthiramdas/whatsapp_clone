import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/colors.dart';
import 'package:whatsapp_ui/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_ui/utils/custome_snackbar.dart';

class LoginPage extends ConsumerStatefulWidget {
  static const routeName = "/login-screan";

  const LoginPage({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final phoneControer = TextEditingController();
  Country? country;

  void PickCountry() {
    showCountryPicker(
        context: context,
        onSelect: (Country _country) {
          setState(() {});
          country = _country;
        });
  }

  void sendPhoneNumber(){
    String PhoneNumber = phoneControer.text.trim();
    if (country!= null && PhoneNumber.isNotEmpty) {
      //Adding Country Code
      final phoneNumber = "+${country!.phoneCode}$PhoneNumber";
      ref.read(authControllerProvider).signInWithPhone(context, phoneNumber);
    }else{
      showSnackBar(context: context, content: "Enter the fields");
    }
  }

  @override
  void dispose() {
    super.dispose();
    phoneControer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: backgroundColor,
        title: const Text("Enter your phone number"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: const Text(
                    "Whatsapp will need to verify your phone number.",
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  )),
              const SizedBox(height: 20),
              TextButton(
                child: const Text("Pick country",
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.w600)),
                onPressed: () => PickCountry(),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (country != null)
                    Text("+${country!.phoneCode}",
                        style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 10),
                  SizedBox(
                      width: size.width * 0.7,
                      child: TextField(
                        controller: phoneControer,
                        decoration: InputDecoration(hintText: "phone number"),
                      ))
                ],
              )
            ],
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: ElevatedButton(
              onPressed: sendPhoneNumber,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.green),
              ),
              child: const Text("NEXT"),
            ),
          )
        ],
      ),
    );
  }
}
