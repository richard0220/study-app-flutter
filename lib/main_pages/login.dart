import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter_1/main_pages/myHomePage.dart';
import 'signUp.dart';

class LoginHome extends StatelessWidget {
  const LoginHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  String name = '';
  String email = '';
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool passwordHide = true;

  Future<void> signIn() async {
    try {
      UserCredential user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);

      Navigator.push(
          context,
          MaterialPageRoute<void>(
              builder: (context) => MyHomePage(
                    uid: user.user!.uid,
                  )));
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }

  Future<void> signInAnon() async {
    try {
      UserCredential user = await FirebaseAuth.instance.signInAnonymously();
      Navigator.push(
          context,
          MaterialPageRoute<void>(
              builder: (context) => MyHomePage(
                    uid: user.user!.uid,
                  )));
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }

  void register() {
    Navigator.push(
        context, MaterialPageRoute<void>(builder: (context) => SignUpHome()));
  }

  void seePassword() {
    setState(() {
      passwordHide = !(passwordHide);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.brown[800],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 70,
            ),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 5,
                  color: Colors.white,
                ),
              ),
              child: Column(children: <Widget>[
                Text(
                  'Study',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Center',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ]),
            ),
            SizedBox(
              height: 100,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.brown[300],
              ),
              child: SizedBox(
                width: 350,
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.person),
                    labelText: 'Email',
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.brown[300],
              ),
              child: SizedBox(
                width: 350,
                child: TextField(
                  controller: passwordController,
                  obscureText: passwordHide,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.password),
                    labelText: 'Passport',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.visibility),
                      onPressed: seePassword,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: 320,
              decoration: BoxDecoration(
                color: Colors.brown[100],
                borderRadius: BorderRadius.circular(50),
              ),
              child: ListTile(
                onTap: signIn,
                title: Text(
                  'Login',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.brown[800],
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: 320,
              decoration: BoxDecoration(
                color: Colors.brown[100],
                borderRadius: BorderRadius.circular(50),
              ),
              child: ListTile(
                onTap: signInAnon,
                title: Text(
                  'Guest Login',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.brown[800],
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 80,
            ),
            ListTile(
              title: Text(
                'Not a citizen yet?',
                style: TextStyle(color: Colors.brown[200]),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              width: 200,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.brown[100],
                borderRadius: BorderRadius.circular(50),
              ),
              child: ListTile(
                onTap: register,
                title: Text(
                  'Create account',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.brown[800],
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
