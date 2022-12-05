import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/features/select_contacts/repository/select_contact_repository.dart';

final getContactProvider = FutureProvider((ref) {
  final selectContactRepository = ref.watch(selectContactRepositoryProvider);
  return selectContactRepository.getContact();
});

final selectContactControllerProvider = Provider((ref) {
  final SelectContactRepository = ref.watch(selectContactRepositoryProvider);
  return selectContactControlller(ref: ref, selectContactRepository: SelectContactRepository);

});


class selectContactControlller {
  final ProviderRef ref;
  final SelectContactRepository selectContactRepository ;

  selectContactControlller({required this.ref, required this.selectContactRepository});


  void selectedContact(Contact selectedContact , BuildContext context ){
    selectContactRepository.selectContact(selectedContact, context);
  }

}
