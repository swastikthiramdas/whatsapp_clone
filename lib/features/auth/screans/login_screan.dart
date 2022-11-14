import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_ui/colors.dart';

class LoginPage extends StatefulWidget {
  static const routeName = "/login-screan";

  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
        title: Text("Enter your phone number"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
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
            margin: EdgeInsets.only(bottom: 20),
            child: ElevatedButton(
              onPressed: () {},
              child: Text("NEXT"),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green)),
            ),
          )
        ],
      ),
    );
  }
}
