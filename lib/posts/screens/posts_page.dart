import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instrive/common/services/extensions.dart';
import 'package:instrive/common/services/navigation.dart';
import 'package:instrive/common/widgets/common_appbar.dart';
import 'package:instrive/common/widgets/empty_widget.dart';
import 'package:instrive/main.dart';
import 'package:instrive/posts/screens/create_post_page.dart';
import 'package:instrive/profile/profile_screen.dart';
import 'package:instrive/registration_login/services/auth_controller.dart';
import '../../common/services/network_database.dart';
import '../../modals/post_modal.dart';
import '../widgets/display_post_container.dart';

class PostFeedPage extends StatefulWidget {
  final String? userId;
  PostFeedPage({
    super.key,
    this.userId,
  });

  @override
  State<PostFeedPage> createState() => _PostFeedPageState();
}

class _PostFeedPageState extends State<PostFeedPage> {
  final user = AuthController().user;
  final _scrollController = ScrollController();
  bool isLoadingPosts = false;
  List<Post> postList = [];
  bool get isUserPage => (widget.userId != null) ? true : false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPosts();
  }

  void getPosts() async {
    if (!isLoadingPosts) {
      setState(() {
        isLoadingPosts = true;
      });
    }
    List<Post> posts = [];
    if (widget.userId != null) {
      posts = await Network.readUserPosts(widget.userId!);
    } else {
      posts = await Network.readAllPosts();
    }
    postList.clear();
    postList.addAll(posts);

    setState(() {
      isLoadingPosts = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: (isUserPage)
            ? Size(0, 0)
            : Size(
                double.infinity,
                60,
              ),
        child: CompanyAppbar(
          showProfileIcon: true,
          actionWidget: IconButton(
            onPressed: () {
              getPosts();
            },
            icon: Icon(
              Icons.refresh,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            itemCount: postList.length + 1,
            itemBuilder: (itemBuilder, index) {
              if (index == 0) {
                return createPostWidget(context);
              }

              return (postList.isNotEmpty)
                  ? Column(
                      children: [
                        PostContainer(
                          thisPost: postList[index - 1],
                        ),
                        if (index == postList.length && isLoadingPosts)
                          CircularProgressIndicator(),
                      ],
                    )
                  : Container(
                      color: Colors.red,
                      height: 800,
                      width: 80,
                      child: Text('No Posts'),
                    );
            },
          ),
        ),
      ),
    );
  }

  Widget createPostWidget(BuildContext context) {
    return Visibility(
      visible: !isUserPage,
      child: ListTile(
        onTap: () => CustomNavigation.navigateBack(context, PostCreationPage()),
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            'Create Post',
            style: Theme.of(context).textTheme.headline6!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
          ),
        ),
        subtitle: 'Click to create a new post'.subTitle,
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 18,
        ),
      ),
    );
  }
}
