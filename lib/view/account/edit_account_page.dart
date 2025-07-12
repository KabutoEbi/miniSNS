import 'package:flutter/material.dart';
import 'package:minisns/utils/authentication.dart';
import 'package:minisns/utils/firestore/users.dart';
import 'package:minisns/utils/function_utils.dart';
import 'package:minisns/utils/widget_utils.dart';
import 'dart:io';
import 'package:minisns/model/account.dart';
import 'package:minisns/view/start_up/login_page.dart';

class EditAccountPage extends StatefulWidget {
  @override
  _EditAccountPageState createState() => _EditAccountPageState();
}

class _EditAccountPageState extends State<EditAccountPage> {
  Account myAccount = Authentication.myAccount!;
  TextEditingController nameController = TextEditingController();
  TextEditingController userIdController = TextEditingController();
  TextEditingController selfIntroductionController = TextEditingController();
  File? image;

  ImageProvider getImage(){
    if(image == null){
      return NetworkImage(myAccount.imagePath);
    } else {
      return FileImage(image!);
    }
  }
  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: myAccount.name);
    userIdController = TextEditingController(text: myAccount.userId);
    selfIntroductionController = TextEditingController(text: myAccount.selfIntroduction);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetUtils.createAppBar('Edit Account'),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              SizedBox(height: 30),
              GestureDetector(
                onTap: () async{
                  var result = await FunctionUtils.getImageFromGallary();
                  if (result != null) {
                    setState(() {
                      image = File(result.path);
                    });
                  }
                },
                child: CircleAvatar(foregroundImage: getImage(), radius: 40, child: Icon(Icons.add),),
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
              SizedBox(height: 50),
              ElevatedButton(
                onPressed: () async {
                  if (nameController.text.isNotEmpty &&
                      userIdController.text.isNotEmpty &&
                      selfIntroductionController.text.isNotEmpty) {
                    String imagePath = '';
                    if(image == null){
                      imagePath = myAccount.imagePath;
                    } else {
                      var result = await FunctionUtils.uploadImage(myAccount.id, image!);
                      imagePath = result;
                    }
                    Account updateAccount = Account(
                      id: myAccount.id,
                      name: nameController.text,
                      userId: userIdController.text,
                      selfIntroduction: selfIntroductionController.text,
                      imagePath: imagePath,
                    );
                    Authentication.myAccount = updateAccount;
                    var result = await UserFirestore.updateUser(updateAccount);
                    if(result == true){
                      Navigator.pop(context, true);
                    }
                  }
                },
                child: Text('Save Changes'),
              ),
              SizedBox(height: 50),
              ElevatedButton(onPressed: (){
                Authentication.signOut();
                while(Navigator.canPop(context)){
                  Navigator.pop(context);
                }
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
              }, child: Text('Logout')),
              SizedBox(height: 50),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: (){
                UserFirestore.deleteuser(myAccount.id);
                Authentication.deleteAuth();
                while(Navigator.canPop(context)){
                  Navigator.pop(context);
                }
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
              }, child: Text('Delete')),
            ],
          ),
        ),
      ),
    );
  }
}
