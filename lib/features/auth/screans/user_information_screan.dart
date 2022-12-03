import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/common/utils/utils.dart';
import 'package:whatsapp_ui/features/auth/controller/auth_controller.dart';

const String networkImg =
    "https://imgs.search.brave.com/CFYwjNmlradIA3th9M0LjsjcVQpf6ZY86fLJXPS6GoY/rs:fit:415:415:1/g:ce/aHR0cDovL3JvbmFs/ZG1vdHRyYW0uY28u/bnovd3AtY29udGVu/dC91cGxvYWRzLzIw/MTkvMDEvZGVmYXVs/dC11c2VyLWljb24t/OC5qcGc";

class UserInformationScreen extends ConsumerStatefulWidget {
  static const String routeName = "/user-Information";

  const UserInformationScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<UserInformationScreen> createState() => _UserInformationScreenState();
}

class _UserInformationScreenState extends ConsumerState<UserInformationScreen> {
  final TextEditingController Namecontroller = TextEditingController();
  File? image;

  @override
  void dispose() {
    super.dispose();
    Namecontroller.dispose();
  }

  void selectImage() async {
    image = await pickImageFromgallery(context);
    setState(() {});
  }

  void storeUserData(){
    String name = Namecontroller.text.trim();

    if(name.isNotEmpty){
      ref.read(authControllerProvider).saveUserdataToFirebase(context, name, image);
    } else{
      showSnackBar(context: context, content: "Enter Your Name");
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  image == null
                      ? CircleAvatar(
                          radius: 60, backgroundImage: NetworkImage(networkImg))
                      : CircleAvatar(
                          radius: 60, backgroundImage: FileImage(image!)),
                  Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                        onPressed: selectImage, icon: Icon(Icons.add_a_photo)),
                  )
                ],
              ),
              Row(
                children: [
                  Container(
                    width: size.width * 0.85,
                    padding: const EdgeInsets.all(20),
                    child: TextField(
                      controller: Namecontroller,
                      decoration: InputDecoration(hintText: "Enter Your Name"),
                    ),
                  ),
                  IconButton(onPressed: storeUserData, icon: Icon(Icons.done))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
