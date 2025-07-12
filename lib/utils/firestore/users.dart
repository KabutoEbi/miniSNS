import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:minisns/model/account.dart';
import 'package:minisns/utils/authentication.dart';
import 'package:minisns/utils/firestore/posts.dart';

class UserFirestore {
  static final _firestoreInstance = FirebaseFirestore.instance;
  static final CollectionReference users = _firestoreInstance.collection('users');

  static Future<dynamic> setUser(Account newAccount) async {
    try {
      await users.doc(newAccount.id).set({
        'name': newAccount.name,
        'userId': newAccount.userId,
        'selfIntroduction': newAccount.selfIntroduction,
        'imagePath': newAccount.imagePath,
        'createdTime': Timestamp.now(),
        'updatedTime': Timestamp.now(),
      });
      print('newAccount setUser complete');
      return true;
    } on FirebaseException catch (e) {
      print('newAccount setUser error: $e');
      return false;
    }
  }

  static Future<dynamic> getUser(String uid) async{
    try {
      DocumentSnapshot documentSnapshot = await users.doc(uid).get();
      Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
      Account myAccount = Account (
        id: uid,
        name: data['name'],
        userId: data['userId'],
        selfIntroduction: data['selfIntroduction'],
        imagePath: data['imagePath'],
        createdTime: data['createdTime'],
        updatedTime: data['updatedTime'],
      );
      Authentication.myAccount = myAccount;
      print('getUser complete');
      return true;
    } on FirebaseException catch (e) {
      print('getUser error: $e');
      return false;
    }
  }

  static Future<dynamic> updateUser(Account updateAccount) async{
    try {
      users.doc(updateAccount.id).update({
        'name': updateAccount.name,
        'userId': updateAccount.userId,
        'selfIntroduction': updateAccount.selfIntroduction,
        'imagePath': updateAccount.imagePath,
        'updatedTime': Timestamp.now(),
      });
      print('updateUser complete');
      return true;
    } on FirebaseException catch (e) {
      print('updateUser error: $e');
      return false;
    }
  }

  static Future<Map<String, Account>?> getPostUserMap(List<String> accountIds) async{
    Map<String, Account> map = {};
    try {
      await Future.forEach(accountIds, (accountId) async {
        var doc = await users.doc(accountId).get();
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        Account postAccount = Account(
          id: accountId,
          name: data['name'],
          userId: data['userId'],
          selfIntroduction: data['selfIntroduction'],
          imagePath: data['imagePath'],
          createdTime: data['createdTime'],
          updatedTime: data['updatedTime'],
        );
        map[accountId] = postAccount;
      });
      print('getPostUserMap complete');
      return map;
    } on FirebaseException catch (e) {
      print('getPostUserMap error: $e');
      return null;
    }
  }

  static Future<dynamic> deleteuser(String accountId) async {
    await users.doc(accountId).delete();
    PostFirestore.deletePosts(accountId);
  }
}