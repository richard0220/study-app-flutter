import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RequestNotification extends StatefulWidget {
  final String uid;
  const RequestNotification({Key? key, required this.uid}) : super(key: key);

  @override
  _RequestNotificationState createState() => _RequestNotificationState();
}

class _RequestNotificationState extends State<RequestNotification> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('student')
            .doc(widget.uid)
            .snapshots(),
        builder: (BuildContext context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          DocumentSnapshot? documentSnapshot = snapshot.data;
          List req = documentSnapshot!['friendRequest'] as List;
          return req.length != 0
              ? StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('student')
                      .where('uid', whereIn: req)
                      .snapshots(),
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text('Loading...');
                    }
                    return PopupMenuButton(
                      icon: Icon(Icons.mail),
                      itemBuilder: (context) =>
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data() as Map<String, dynamic>;
                        return PopupMenuItem(
                          child: ListTile(
                            leading: Icon(Icons.person),
                            title: Text(data['name'].toString()),
                            trailing: TextButton(
                              child: Text('accept'),
                              onPressed: null,
                            ),
                          ),
                          value: null,
                        );
                      }).toList(),
                    );
                  })
              : IconButton(
                  icon: Icon(Icons.mail),
                  onPressed: null,
                );
        });
  }
}
