import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:minisns/utils/authentication.dart';
import 'package:minisns/utils/firestore/users.dart';
import 'package:minisns/model/account.dart';
import 'package:minisns/utils/function_utils.dart';
import 'package:minisns/utils/widget_utils.dart';
import 'package:minisns/view/start_up/check_email_page.dart';

class CreateAccountPage extends StatefulWidget {
  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController userIdController = TextEditingController();
  TextEditingController selfIntroductionController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  File? image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetUtils.createAppBar('new account'),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              SizedBox(height: 30),
              GestureDetector(
                onTap: () async {
                  var result = await FunctionUtils.getImageFromGallary();
                  if (result != null) {
                    setState(() {
                      image = File(result.path);
                    });
                  }
                },
                child: CircleAvatar(foregroundImage: image == null ? null : FileImage(image!), radius: 40, child: Icon(Icons.add),),
              ),
              Container(
                width: 300,
                child: TextField(controller: nameController, decoration: InputDecoration(hintText: 'Name'),),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Container(
                  width: 300,
                  child: TextField(controller: userIdController, decoration: InputDecoration(hintText: 'User ID'),),
                ),
              ),
              Container(
                width: 300,
                child: TextField(controller: selfIntroductionController, decoration: InputDecoration(hintText: 'Self Introduction'),),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Container(
                  width: 300,
                  child: TextField(controller: emailController, decoration: InputDecoration(hintText: 'Email'),),
                ),
              ),
              Container(
                width: 300,
                child: TextField(controller: passController, decoration: InputDecoration(hintText: 'Password'),),
              ),
              SizedBox(height: 50),
              ElevatedButton(
                onPressed: () async {
                  if (nameController.text.isNotEmpty &&
                      userIdController.text.isNotEmpty &&
                      selfIntroductionController.text.isNotEmpty &&
                      emailController.text.isNotEmpty &&
                      passController.text.isNotEmpty &&
                      image != null) {
                    var result = await Authentication.signUp(
                      email: emailController.text,
                      pass: passController.text,
                    );
                    if (result is UserCredential) {
                      String imagePath = await FunctionUtils.uploadImage(result.user!.uid, image!);
                      Account newAccount = Account(
                        id: result.user!.uid,
                        name: nameController.text,
                        userId: userIdController.text,
                        selfIntroduction: selfIntroductionController.text,
                        imagePath: imagePath,
                      );
                      var _result = await UserFirestore.setUser(newAccount);
                      if (_result == true) {
                        result.user!.sendEmailVerification();
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CheckEmailPage(email: emailController.text, pass: passController.text)));
                      }
                    }
                  }
                },
                child: Text('Create Account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
