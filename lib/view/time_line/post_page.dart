import 'package:flutter/material.dart';
import 'package:minisns/utils/authentication.dart';
import 'package:minisns/utils/firestore/posts.dart';
import 'package:minisns/model/post.dart';

class PostPage extends StatefulWidget {
  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  TextEditingController contentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('New Post', style: TextStyle(color: Colors.black)),
        backgroundColor: Theme.of(context).canvasColor,
        elevation: 2,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(controller: contentController,),
            SizedBox(height: 20),
            ElevatedButton(onPressed: () async{
              if(contentController.text.isNotEmpty){
                Post newPost = Post(
                  content: contentController.text,
                  postAccountId: Authentication.myAccount!.id,
                );
                var result = await PostFirestore.addpost(newPost);
                if(result == true){
                  Navigator.pop(context);
                }
              }
            }, child: Text('Post')),
          ],
        ),
      )
    );
  }
}
