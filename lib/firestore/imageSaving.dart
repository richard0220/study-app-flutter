import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ImageServer {
  DocumentReference sightingRef =
      FirebaseFirestore.instance.collection('sighting').doc();

  Future<void> saveImage(File image) async {
    String imageURL = await uploadFile(image);
    sightingRef.update({
      'image': FieldValue.arrayUnion(<String>[imageURL])
    });
  }

  Future<String> uploadFile(File image) async {
    Reference reference =
        FirebaseStorage.instance.ref().child('sighting/${image.path}');
    UploadTask uploadTask = reference.putFile(image);
    late String returnURL;
    await reference.getDownloadURL().then((fileURL) {
      returnURL = fileURL;
    });
    return returnURL;
  }
}
