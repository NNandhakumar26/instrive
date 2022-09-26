import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instrive/common/services/app_utils.dart';
import '../../modals/app_users.dart';
import '../../modals/post_modal.dart';

class Network {
  static final instance = FirebaseFirestore.instance;
  static final usersInstance = instance.collection('users');
  static final postInstance = instance.collection('posts');

  static Future<AppUser?> readUser(String id) async =>
      await usersInstance.doc(id).get().then((value) =>
          (value.data() != null) ? AppUser.fromMap(value.data()!) : null);

  static Future<List<AppUser>> readAllUsers() async =>
      await usersInstance.get().then(
            (value) => value.docs
                .map(
                  (doc) => AppUser.fromMap(doc.data()),
                )
                .toList(),
          );

  static Future<void> updateUser(AppUser user) async =>
      await usersInstance.doc(user.userID).set(
            user.toMap(),
            SetOptions(
              merge: false,
            ),
          );

  static Future<void> deleteUser(String id) async =>
      await usersInstance.doc(id).delete();

  static Future<void> createPost(Post post) async =>
      await postInstance.add(post.toMap());

  // read posts from

  static Future<List<Post>> readAllPosts() async =>
      await postInstance.get().then(
            (value) => value.docs.map(
              (value) {
                Post post = Post.fromMap(value.data());
                post.postID = value.id;
                return post;
              },
            ).toList(),
          );
  static Future<List<Post>> readUserPosts(String userId) async =>
      await postInstance
          .where(
            'userID',
            isEqualTo: userId,
          )
          .get()
          .then(
            (value) => value.docs.map(
              (value) {
                Post post = Post.fromMap(value.data());
                post.postID = value.id;
                return post;
              },
            ).toList(),
          );

  static Future<void> updatePost(Post post) async =>
      await postInstance.doc(post.postID).update(post.toMap());
  // function to delete a post
  static Future<void> deletePost(String id, List<String>? fileUrls) async {
    if (fileUrls != null) {
      for (var file in fileUrls) {
        await AppUtil.deleteFile(file);
      }
    }

    return await postInstance.doc(id).delete();
  }
}
