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

  Future addFriend(String friendId) async {
    return await userData.doc(uid).update({
      'friendRequest': FieldValue.arrayUnion(<String>[friendId]),
    });
  }
}
