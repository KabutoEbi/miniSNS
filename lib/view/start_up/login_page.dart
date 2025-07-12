import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:minisns/utils/authentication.dart';
import 'package:minisns/utils/firestore/users.dart';
import 'package:minisns/view/screen.dart';
import 'package:minisns/view/start_up/create_account_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              SizedBox(height: 50),
              Text(
                'mini SNS',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Container(
                  width: 300,
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(hintText: 'Email'),
                  ),
                ),
              ),
              Container(
                width: 300,
                child: TextField(
                  controller: passController,
                  decoration: InputDecoration(hintText: 'Password'),
                ),
              ),
              SizedBox(height: 10),
              RichText(
                text: TextSpan(
                  style: TextStyle(color: Colors.black),
                  children: [
                    TextSpan(text: 'Don\'t have an account? '),
                    TextSpan(
                      text: 'Sign Up',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer:
                          TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CreateAccountPage(),
                                ),
                              );
                            },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 70),
              ElevatedButton(
                onPressed: () async {
                  var result = await Authentication.emailSignIn(
                    email: emailController.text,
                    pass: passController.text,
                  );
                  if (result is UserCredential) {
                    if(result.user!.emailVerified == true) {
                      var _result = await UserFirestore.getUser(result.user!.uid);
                    if (_result == true) {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Screen()));
                    }
                    } else {
                      print('Email not verified');
                    }
                  }
                },
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
