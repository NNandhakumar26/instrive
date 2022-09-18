import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instrive/common/services/app_utils.dart';
import 'package:instrive/common/services/extensions.dart';
import 'package:instrive/common/services/network_database.dart';
import 'package:instrive/common/widgets/alert_dialog.dart';
import 'package:instrive/common/widgets/loading_dialog.dart';
import 'package:instrive/modals/post_modal.dart';
import 'package:instrive/registration_login/services/auth_controller.dart';

import '../widgets/image_picker.dart';

class PostCreationPage extends StatefulWidget {
  const PostCreationPage({super.key});

  @override
  State<PostCreationPage> createState() => _PostCreationPageState();
}

class _PostCreationPageState extends State<PostCreationPage> {
  final commentController = TextEditingController();

  User? user = AuthController.user;
  Post post = Post();

  final files = <File?>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Creation Page'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: 18,
          ),
        ),
        elevation: 8,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: commentController,
              autofocus: false,
              textInputAction: TextInputAction.next,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Write down your comments here...',
                hintStyle: Theme.of(context).textTheme.subtitle1!.copyWith(
                      color: Colors.grey.withOpacity(0.60),
                    ),
              ),
            ),

            SizedBox(
              height: 2,
            ),
            const Divider(height: 10.0, thickness: 0.5),
            SizedBox(
              height: 2,
            ),
            // add the button to photos and post button
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await showDialog<List<File>?>(
                          context: context,
                          builder: (context) => GetImageWidget(),
                        ).then(
                          (files) {
                            if (files != null) {
                              setState(
                                () {
                                  files.addAll(files);
                                },
                              );
                            }
                          },
                        );
                      },
                      label: 'Images'.plainText,
                      icon: Icon(
                        Icons.photo_library_sharp,
                        size: 18,
                      ),
                    ),
                  ),
                ),
                Spacer(),
                const VerticalDivider(
                  width: 8.0,
                  thickness: 20.0,
                  color: Colors.black,
                ),
              ],
            ),
            ...files
                .map(
                  (imageFile) => ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 0.32,
                      ),
                    ),
                    leading: CircleAvatar(
                      foregroundImage: FileImage(imageFile!),
                    ),
                    title: Text(
                      'Image ${files.indexOf(imageFile) + 1}',
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: Colors.black87,
                          ),
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        files.remove(imageFile);
                        setState(() {});
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red.shade600.withOpacity(0.87),
                      ),
                    ),
                  ),
                )
                .toList(),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if ((files.isEmpty) && (commentController.text.isEmpty)) {
            showDialog(
              context: context,
              builder: (BuildContext context) => CustomAlertDialog(
                context: context,
                title: 'Post cannot be empty',
                columnWidgets: [
                  'Either the file or the comment should be not empty'
                      .plainText,
                ],
              ),
            );
            return;
          }
          showDialog(
            context: context,
            builder: (builder) => CustomshowLoading(
              title: 'Uploading post',
            ),
          );
          await uploadFiles();
          if (commentController.text.isNotEmpty) {
            post.description = commentController.text;
          }
          post.dateTime = DateTime.now();
          post.userID = user!.uid;
          post.userName = user!.displayName;
          post.userPhoto = user!.photoURL;

          await Network.createPost(post);
          // Remove the dialog
          Navigator.pop(context);

          // Go back to the main page
          Navigator.pop(context);
          return;
        },
        extendedPadding: EdgeInsets.symmetric(horizontal: 24),
        icon: Icon(
          Icons.send,
          size: 18,
        ),
        label: Text(
          'Post',
          // style: Theme.of(context).textTheme.headline6s,
        ),
      ),
    );
  }

  Future<void> uploadFiles() async {
    if (files.isEmpty) return;

    for (var file in files) {
      if (file == null) continue;
      String url = await AppUtil.uploadFile(
        file: file,
        isPost: true,
      );
      post.postUrls ??= [];
      post.postUrls!.add(url);
    }
  }
}
