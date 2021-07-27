import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_1/friend_pages/friendRequest.dart';
import 'package:flutter_1/friend_pages/searchFriendPage.dart';

class ShowFriend extends StatefulWidget {
  final String uid;
  const ShowFriend({Key? key, required this.uid}) : super(key: key);

  @override
  _ShowFriendState createState() => _ShowFriendState();
}

class _ShowFriendState extends State<ShowFriend> {
  List<String> friends = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Friends'),
        actions: [
          IconButton(
            icon: Icon(Icons.person_add),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                      builder: (context) => FriendPage(uid: widget.uid)));
            },
          ),
          RequestNotification(uid: widget.uid),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('student')
            .doc(widget.uid)
            .snapshots(),
        builder: (BuildContext context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          DocumentSnapshot? documentSnapshot = snapshot.data;
          CollectionReference friend =
              FirebaseFirestore.instance.collection('student');
          for (String id in documentSnapshot!['friend']) {
            friends.add(id);
          }
          return friends.length != 0
              ? StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('student')
                      .where('uid', whereIn: friends)
                      .snapshots(),
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text('Loading...');
                    }
                    return ListView(
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data() as Map<String, dynamic>;
                        return ListTile(
                          title: Text(data['name'].toString()),
                          subtitle: Text(data['email'].toString()),
                        );
                      }).toList(),
                    );
                  })
              : Container(
                  alignment: Alignment.center,
                  child: Text('Add some friends!'),
                );
        },
      ),
    );
  }
}
