import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_1/friend_pages/searchFriendPage.dart';
import 'package:flutter_1/detail_pages/myStudyRoom.dart';
import 'package:flutter_1/detail_pages/profile.dart';
import 'package:flutter_1/friend_pages/showFriend.dart';

class MyHomePage extends StatefulWidget {
  final String uid;

  MyHomePage({required this.uid});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> Options = ['Add To Study List', 'Add To My Favorite'];

  // Log Out
  Future logout() async {
    Navigator.pop(context);
    Navigator.pop(context);
    await FirebaseAuth.instance.signOut();
  }

  // Move to main study room
  void toStudyRoom() {
    Navigator.push(
        context, MaterialPageRoute<void>(builder: (context) => MyStudyRoom()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Study Center',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.brown[800],
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.brown[400],
      ),
      // I don't know why it works
      drawer: Drawer(
        // Get the data from cloudstore
        child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('student')
                .doc(widget.uid)
                .snapshots(),
            builder: (BuildContext context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              DocumentSnapshot? document = snapshot.data;
              String name =
                  document!.exists ? document['name'].toString() : 'Guest';
              String email =
                  document.exists ? document['email'].toString() : widget.uid;
              return ListView(
                children: <Widget>[
                  UserAccountsDrawerHeader(
                      accountName: Text('User: ${name}'),
                      accountEmail: Text('Email: ${email}')),
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text('Profile'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (context) => ProfilePage(
                            name: name,
                            email: email,
                          ),
                        ),
                      );
                    },
                  ),
                  ListTile(
                      leading: Icon(Icons.people),
                      title: Text('Friends'),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                                builder: (context) => ShowFriend(
                                      uid: widget.uid,
                                    )));
                      }),
                  ListTile(
                    leading: Icon(Icons.logout),
                    title: Text('Logout'),
                    onTap: () => logout(),
                  ),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Settings'),
                    onTap: null,
                  )
                ],
              );
            }),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
              Colors.brown.withOpacity(0.5),
              BlendMode.dstATop,
            ),
            alignment: Alignment.topCenter,
            fit: BoxFit.fill,
            image: NetworkImage(
                'https://images.unsplash.com/photo-1484251065541-c9770829890f?ixid=MnwxMjA3fDB8MHxzZWFyY2h8NDZ8fGNvZmZlZSUyMHNob3B8ZW58MHx8MHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=60'),
          ),
        ),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            ListTile(
              title: Text(
                'My Study Room',
                style: TextStyle(
                  color: Colors.brown[800],
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              leading: Icon(Icons.book),
              onTap: toStudyRoom,
            ),
            SizedBox(
              height: 20,
            ),
            ListTile(
              title: Text(
                'My Conference Room',
                style: TextStyle(
                  color: Colors.brown[800],
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              leading: Icon(Icons.meeting_room),
            ),
            SizedBox(
              height: 20,
            ),
            ListTile(
              title: Text(
                'Visit Others',
                style: TextStyle(
                  color: Colors.brown[800],
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              leading: Icon(Icons.other_houses),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.brown[300],
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.home),
              onPressed: null,
            ),
            IconButton(
              onPressed: null,
              icon: Icon(Icons.school),
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceAround,
        ),
      ),
    );
  }
}
