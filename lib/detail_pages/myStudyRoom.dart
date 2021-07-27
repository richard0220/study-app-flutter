import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyStudyRoom extends StatefulWidget {
  const MyStudyRoom({Key? key}) : super(key: key);

  @override
  _MyStudyRoomState createState() => _MyStudyRoomState();
}

class _MyStudyRoomState extends State<MyStudyRoom> {
  var period = const Duration(seconds: 1);
  bool timeRun = false;
  int timeCount = 2700;
  int restMin = 45;
  int restSecond = 0;

  void timeButtonEvent() {
    timeRun = !(timeRun);
    Timer.periodic(period, (timer) {
      if (timeCount < 1 || timeRun == false) {
        timer.cancel();
      } else {
        timeCount--;
        restMin = timeCount ~/ 60;
        restSecond = timeCount % 60;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Let's Study"),
      ),
      body: Container(
        width: 500,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            colorFilter: ColorFilter.mode(
                Colors.brown.withOpacity(0.5), BlendMode.dstATop),
            alignment: Alignment.topCenter,
            image: NetworkImage(
                'https://images.unsplash.com/photo-1522008174174-1a7e4c12078f?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTV8fGNvZmZlZSUyMHNob3B8ZW58MHx8MHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=60'),
          ),
        ),
        child: Column(children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 10),
            child: Text(
              'StudyTime $restMin : $restSecond',
              style: TextStyle(
                fontSize: 28,
                color: Colors.brown[800],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextButton(
            onPressed: timeButtonEvent,
            child: Text(
              timeRun == false ? 'Start' : 'Pause',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
