import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final commonFirebaseStorageRepositoryProvider = Provider((ref) => commonFirebaseStorageRepository(firebaseStorage: FirebaseStorage.instance));

class commonFirebaseStorageRepository {
  final FirebaseStorage firebaseStorage;

  commonFirebaseStorageRepository({required this.firebaseStorage});

  Future<String> storageFileToFirebase(String ref , File file) async {
    UploadTask uploadTask = firebaseStorage.ref().child(ref).putFile(file);
    TaskSnapshot snap = await uploadTask;
    String downloadUri = await snap.ref.getDownloadURL();
    return downloadUri;
  }
}
