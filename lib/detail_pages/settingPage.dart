import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  double voice = 20;
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.settings),
        title: Text('Setting'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Done'),
          ),
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListTile(
              leading: Icon(Icons.headphones),
              title: Slider(
                value: voice,
                min: 0,
                max: 100,
                onChanged: (newVoice) {
                  setState(() {
                    voice = newVoice;
                  });
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.pages),
                Switch(
                  value: isSwitched,
                  activeColor: Colors.brown,
                  onChanged: (theme) => setState(() {
                    isSwitched = theme;
                  }),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
