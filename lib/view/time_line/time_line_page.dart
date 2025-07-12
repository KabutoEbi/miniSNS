import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:minisns/model/account.dart';
import 'package:minisns/model/post.dart';
import 'package:minisns/utils/firestore/posts.dart';
import 'package:minisns/utils/firestore/users.dart';

class TimeLinePage extends StatefulWidget {
  @override
  _TimeLinePageState createState() => _TimeLinePageState();
}

class _TimeLinePageState extends State<TimeLinePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Time Line', style: TextStyle(color: Colors.black)),
        backgroundColor: Theme.of(context).canvasColor,
        elevation: 2,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: PostFirestore.posts.snapshots(),
        builder: (context, postsnapshot) {
          if (postsnapshot.hasData) {
            List<String> postAccountIds = [];
            postsnapshot.data!.docs.forEach((doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              if (!postAccountIds.contains(data['postAccountId'])) {
                postAccountIds.add(data['postAccountId']);
              }
            });
            return FutureBuilder<Map<String, Account>?>(
              future: UserFirestore.getPostUserMap(postAccountIds),
              builder: (context, usersnapshot) {
                if (usersnapshot.hasData &&
                    usersnapshot.connectionState == ConnectionState.done) {
                  return ListView.builder(
                    itemCount: postsnapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> data = postsnapshot.data!.docs[index].data() as Map<String, dynamic>;
                      Post post = Post(
                        id: postsnapshot.data!.docs[index].id,
                        content: data['content'],
                        postAccountId: data['postAccountId'],
                        createdTime: data['createdTime'],
                      );
                      Account postAccount = usersnapshot.data![post.postAccountId]!;
                      return Container(
                        decoration: BoxDecoration(
                          border: index == 0 ? Border(
                            top: BorderSide(color: Colors.grey, width: 0,),
                            bottom: BorderSide(color: Colors.grey, width: 0,),
                          ) : Border(
                            bottom: BorderSide(color: Colors.grey, width: 0,),
                          ),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15,),
                        child: Row(
                          children: [
                            CircleAvatar(radius: 22, foregroundImage: NetworkImage(postAccount.imagePath,),),
                            Expanded(
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text(postAccount.name, style: TextStyle(fontWeight: FontWeight.bold,),),
                                            Text('@${postAccount.userId}', style: TextStyle(color: Colors.grey,),),
                                          ],
                                        ),
                                        Text(DateFormat('M/d/yy').format(post.createdTime!.toDate(),),),
                                      ],
                                    ),
                                    Text(post.content),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  return Container();
                }
              },
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
