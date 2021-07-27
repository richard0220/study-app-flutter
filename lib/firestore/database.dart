import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;

  DatabaseService({required this.uid});

  final CollectionReference userData =
      FirebaseFirestore.instance.collection('student');

  Future updateData(String name, String email) async {
    return await userData.doc(uid).set({
      'uid': uid,
      'name': name,
      'email': email,
      'friend': <String>[],
      'friendRequest': <String>[],
    });
  }

  // Send friend req
  Future addFriend(String friendId) async {
    return await userData.doc(uid).update({
      'friendRequest': FieldValue.arrayUnion(<String>[friendId]),
    });
  }

  // User accept req
  Future acceptRequest(String id) async {
    return await userData.doc(uid).update({
      'friend': FieldValue.arrayUnion(<String>[id]),
    });
  }

  // sender got accept
  Future acceptComplete(String id) async {
    return await userData.doc(id).update({
      'friend': FieldValue.arrayUnion(<String>[uid]),
    });
  }

  // Delete the send message
  Future addComplete(String id) async {
    return await userData.doc(uid).update({
      'friendRequest': FieldValue.arrayRemove(<String>[id]),
    });
  }
}
