import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/common/utils/loader.dart';
import 'package:whatsapp_ui/features/select_contacts/controller/select_contact_controller.dart';

import '../../../common/error.dart';

class SelectContactScreen extends ConsumerWidget {
  static const String routeName = "/select-contact";

  const SelectContactScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Contact"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert,
            ),
          )
        ],
      ),
      body: ref.watch(getContactProvider).when(
          data: (contactList) =>
              ListView.builder(
                itemCount: contactList.length,
                itemBuilder: (context, index) {
                  final contact = contactList[index];
                  return ListTile(
                    title: Text(contact.displayName),
                    leading: contact.photo == null ? null : CircleAvatar(
                      backgroundImage: MemoryImage(contact.photo!),
                      radius: 30,
                    ),
                  );
                },
              ),
          error: (error, trace) =>
              ErrorScreen(
                error: error.toString(),
              ),
          loading: () => LoaderScreen()),
    );
  }
}
