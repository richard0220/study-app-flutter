import 'package:email_auth/email_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_1/firestore/database.dart';

class SignUpHome extends StatelessWidget {
  const SignUpHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
        centerTitle: true,
      ),
      body: SignUpPage(),
    );
  }
}

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool otpSended = false;
  bool emailVerified = false;
  bool passwordError = false;
  bool signUpSuccess = false;
  String signingHint = '';

  void sendOTP() async {
    EmailAuth.sessionName = 'Study App';
    var res = await EmailAuth.sendOtp(receiverMail: emailController.text);
    if (res) {
      otpSended = true;
      setState(() {});
    } else {
      print('Failed to send OTP');
    }
  }

  void verifyOTP() {
    var res = EmailAuth.validate(
        receiverMail: emailController.text, userOTP: otpController.text);
    if (res) {
      emailVerified = true;
    } else {
      emailVerified = false;
    }
    setState(() {});
  }

  Future<void> signIn() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);
      await DatabaseService(uid: userCredential.user!.uid)
          .updateData(nameController.text, emailController.text);
      setState(() {
        signUpSuccess = true;
      });
    } on FirebaseException catch (e) {
      passwordError = true;
      if (e.code == 'weak-password') {
        setState(() {
          signingHint = 'The password is too weak!';
        });
      } else if (e.code == 'email-already-in-use') {
        setState(() {
          signingHint = 'The account is already exists for that email.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: <Widget>[
        TextField(
          controller: nameController,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.person),
            labelText: 'Name',
          ),
        ),
        TextField(
          controller: emailController,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.email),
            labelText: 'E-mail',
            suffix: TextButton(
              onPressed: sendOTP,
              child: Text('Send OTP'),
            ),
          ),
        ),
        TextField(
          controller: otpController,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock_open),
            labelText: 'OTP',
            errorText:
                (emailVerified || otpSended == false) ? null : '  Wrong OTP',
            counterText: emailVerified ? 'Successful Verify!' : null,
            counterStyle: TextStyle(color: Colors.brown[300]),
            suffix: TextButton(
              onPressed: verifyOTP,
              child: Text('Verify OTP'),
            ),
          ),
        ),
        TextField(
          obscureText: true,
          controller: passwordController,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.password),
            labelText: 'New Password',
            errorText: passwordError ? signingHint : null,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: ElevatedButton(
                child: Text('sign up'),
                onPressed: emailVerified ? signIn : null,
              ),
            ),
            Container(
              child: signUpSuccess ? Icon(Icons.check) : null,
            ),
          ],
        ),
      ],
    ));
  }
}
