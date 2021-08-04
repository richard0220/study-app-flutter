import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ImageServer {
  final String uid;
  ImageServer({required this.uid});

  CollectionReference sightingRef =
      FirebaseFirestore.instance.collection('student');

  Future<void> saveImage(File image) async {
    String imageURL = await uploadFile(image);
    sightingRef.doc(uid).update({'image': imageURL});
  }

  Future<String> uploadFile(File image) async {
    Reference reference =
        FirebaseStorage.instance.ref('sighting/${image.path}');
    UploadTask uploadTask = reference.putFile(image);
    String returnURL = await reference.getDownloadURL();
    print(returnURL);
    return returnURL;
  }
}
