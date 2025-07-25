import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:minisns/utils/authentication.dart';
import 'package:minisns/utils/firestore/users.dart';
import 'package:minisns/utils/widget_utils.dart';
import 'package:minisns/view/screen.dart';

class CheckEmailPage extends StatefulWidget {
  final String email;
  final String pass;
  CheckEmailPage({required this.email, required this.pass});
  @override
  _CheckEmailPageState createState() => _CheckEmailPageState();
}

class _CheckEmailPageState extends State<CheckEmailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetUtils.createAppBar('Check Email'),
      body: Column(
        children: [
          Text('Please check your email to verify your account.'),
          ElevatedButton(onPressed: () async {
            var result = await Authentication.emailSignIn(email: widget.email, pass: widget.pass);
            if(result is UserCredential){
              if(result.user!.emailVerified == true) {
                while (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
                await UserFirestore.getUser(result.user!.uid);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Screen()));
              } else {
                print('Email not verified');
              }
            }
          }, child: Text('Verified Email')),
        ],
      ),
    );
  }
}