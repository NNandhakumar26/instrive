import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:instrive/common/services/extensions.dart';
import 'package:instrive/common/services/navigation.dart';
import 'package:instrive/common/widgets/alert_dialog.dart';
import 'package:instrive/modals/app_users.dart';
import 'package:instrive/registration_login/services/auth_controller.dart';

import '../../common/services/network_database.dart';
import '../../common/widgets/widget_util.dart';
import '../../modals/post_modal.dart';

class PostContainer extends StatelessWidget {
  final Post thisPost;
  PostContainer({Key? key, required this.thisPost}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 12, horizontal: 6),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          8.height,
          PostUserContainer(thisPost),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height / 1.64,
              maxWidth: MediaQuery.of(context).size.width,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 0.8,
              ),
              borderRadius: BorderRadius.circular(2),
            ),
            child: (thisPost.postUrls!.length == 1)
                ? CachedNetworkImage(
                    imageUrl: thisPost.postUrls![0],
                    color: Colors.black,
                  )
                : ImageSlideshow(
                    initialPage: 0,
                    indicatorColor: Colors.blue,
                    indicatorBackgroundColor: Colors.grey,
                    children: thisPost.postUrls!
                        .map(
                          (e) => CachedNetworkImage(
                            imageUrl: e,
                          ),
                        )
                        .toList(),
                  ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    thisPost.description ?? '',
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                // 8.height,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PostUserContainer extends StatelessWidget {
  final Post post;

  const PostUserContainer(
    this.post, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: FittedBox(
        fit: BoxFit.scaleDown,
        child: (post.userPhoto == null)
            ? FlutterLogo()
            : CircleAvatar(
                backgroundImage:
                    CachedNetworkImageProvider(post.userPhoto ?? ''),
              ),
      ),
      title: Text(
        post.userName ?? 'Anonymous',
        style: Theme.of(context).textTheme.bodyText1!.copyWith(
              fontWeight: FontWeight.w500,
            ),
      ),
      subtitle: Text(
        (post.dateTime == null)
            ? ''
            : '${post.dateTime!.month} - ${post.dateTime!.year}',
        style: Theme.of(context).textTheme.subtitle1!.copyWith(
              letterSpacing: 1.2,
              fontWeight: FontWeight.w400,
            ),
      ),
      trailing: !(post.userID == (AuthController().user?.uid ?? ''))
          ? 'Follow'.subTitle
          : FittedBox(
              fit: BoxFit.scaleDown,
              child: IconButton(
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (builder) => CustomAlertDialog(
                      context: context,
                      title: 'Confirm Delete',
                      columnWidgets: [
                        'Once you delete the post, it cannot be undone'
                            .plainText,
                      ],
                      primaryButton: 'Confirm',
                      secondaryButton: 'Cancel',
                      onDone: () async {
                        WidgetUtil.showLoading(
                          context,
                          title: 'Deleting post',
                        );
                        await Network.deletePost(post.postID!);
                        // remove the showLoading
                        Navigator.pop(context);

                        // remove the custom alert dialog
                        Navigator.pop(context);
                      },
                    ),
                  );
                },
                icon: Icon(
                  Icons.delete,
                  color: Colors.red.shade400,
                ),
              ),
            ),
    );
  }
}
