import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:minisns/model/post.dart';

class PostFirestore {
  static final _firestoreInstance = FirebaseFirestore.instance;
  static final CollectionReference posts = _firestoreInstance.collection('posts');

  static Future<dynamic> addpost(Post newPost) async {
    try {
      final CollectionReference _suerPosts = _firestoreInstance.collection('users').doc(newPost.postAccountId).collection('my_posts');
      var result = await posts.add({
        'content': newPost.content,
        'postAccountId': newPost.postAccountId,
        'createdTime': Timestamp.now(),
      });
      _suerPosts.doc(result.id).set({
        'postId': result.id,
        'createdTime': Timestamp.now(),
      });
      print('addpost complete');
      return true;
    } on FirebaseException catch (e) {
      print('addpost error: $e');
      return false;
    }
  }

  static Future<List<Post>?> getPostFromIds(List<String> ids) async {
    List<Post> postsList = [];
    try {
      await Future.forEach(ids, (id) async {
        var doc = await posts.doc(id).get();
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        Post post = Post(
          id: doc.id,
          content: data['content'],
          postAccountId: data['postAccountId'],
          createdTime: data['createdTime'],
        );
        postsList.add(post);
      });
      print('getPostFromIds complete');
      return postsList;
    } on FirebaseException catch (e) {
      print('getPostFromIds error: $e');
      return null;
    }
  }

  static Future<dynamic> deletePosts(String accountId) async {
    final CollectionReference _userPosts = _firestoreInstance.collection('users').doc(accountId).collection('my_posts');
    var snapshot = await _userPosts.get();
    snapshot.docs.forEach((doc) async {
      await posts.doc(doc.id).delete();
      _userPosts.doc(doc.id).delete();
    });
  }
}