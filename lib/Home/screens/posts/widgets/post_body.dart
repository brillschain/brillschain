// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
// import 'package:supplink/Backend/firebasefirestore/firestore_methods.dart';
import 'package:supplink/Backend/firebasefirestore/firestore_post_methods.dart';
// import 'package:supplink/Home/messages/msg_connections.dart';
import 'package:supplink/Home/screens/comment/comment_screen.dart';
import 'package:supplink/Home/screens/posts/widgets/action_button.dart';
import 'package:supplink/Home/screens/profile/profile_screen.dart';
// import 'package:supplink/Home/widgets/custom_button.dart';
import 'package:supplink/Home/widgets/like_animation.dart';
import 'package:supplink/Providers/firebase/post_provider.dart';
import 'package:supplink/Providers/user_provider.dart';
import 'package:supplink/models/user_model.dart';
import 'package:supplink/utils/hover_button.dart';
import 'package:supplink/utils/hover_text.dart';
// import 'package:supplink/utils/snackbars.dart';
import 'package:supplink/utils/toaster.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:expandable_text/expandable_text.dart';

class PostCard extends StatefulWidget {
  final snapshot;
  const PostCard({super.key, required this.snapshot});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  late bool isCurrentUser;
  final User user = FirebaseAuth.instance.currentUser!;
  late String widgetUid;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widgetUid = widget.snapshot['uid'];
      final postProvider = Provider.of<PostProvider>(context, listen: false);

      postProvider.init(widget.snapshot['postId'], widgetUid);
      isCurrentUser = user.uid == widgetUid;
    });
  }

  @override
  Widget build(BuildContext context) {
    final UserData userData = Provider.of<UserProvider>(context).getUser;
    return Consumer<PostProvider>(builder: (context, postProvider, _) {
      return Container(
        color: Colors.white,
        padding: const EdgeInsets.all(4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                  .copyWith(right: 0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage:
                        NetworkImage(widget.snapshot['profileUrl']),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {},
                            child: HoverText(
                              onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ProfilePageview(uid: widgetUid))),
                              text: widget.snapshot['name'],
                              defaultStyle:
                                  const TextStyle(fontWeight: FontWeight.bold),
                              hoverStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                          Text(widget.snapshot['address']),
                          Text(
                            timeago.format(
                                widget.snapshot['datePublished'].toDate()),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    key: _menuKey,
                    icon: const Icon(Icons.more_vert),
                    onPressed: () => _showPopupMenu(postProvider),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ExpandableText(
                textAlign: TextAlign.start,
                // "Another cool reel!, Don't miss this reel! Get ready for jaw-dropping moments, endless entertainment, and a rollercoaster of emotions. Hit play and let the fun begin!Another cool reel!, Don't miss this reel! Get ready for jaw-dropping moments, endless entertainment, and a rollercoaster of emotions. Hit play and let the fun begin!",
                widget.snapshot['description'],
                expandText: '  more..',
                collapseText: ' less..',
                expandOnTextTap: true,
                collapseOnTextTap: true,
                maxLines: 2,
                linkColor: Colors.blue,
                linkStyle: const TextStyle(
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.blue,
                ),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            GestureDetector(
              onDoubleTap: () async {
                await FireStorePostMethods().likePost(widget.snapshot['postId'],
                    userData.uid, widget.snapshot['likes']);
                setState(() {
                  isLikeAnimating = true;
                });
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.45,
                    width: double.infinity,
                    child: Image(
                      image: NetworkImage(
                        widget.snapshot['postUrl'],
                      ),
                      fit: BoxFit.contain,
                    ),
                  ),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: isLikeAnimating ? 1 : 0,
                    child: LikeAnimation(
                        isAnimating: isLikeAnimating,
                        duration: const Duration(milliseconds: 400),
                        onEnd: () {
                          setState(() {
                            isLikeAnimating = false;
                          });
                        },
                        child: const Icon(
                          Icons.favorite,
                          color: Colors.white,
                          size: 125,
                        )),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text('${widget.snapshot['likes'].length} '),
                      const Icon(
                        Icons.thumb_up_alt,
                        size: 24,
                        color: Colors.blue,
                      )
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: InkWell(
                      onTap: () {
                        commentDialog(context);
                      },
                      child: HoverText(
                        text: "${postProvider.commentLength} comments ",
                        defaultStyle: const TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                        hoverStyle: const TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              height: 4,
              thickness: 1,
              color: Colors.grey,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                HoverButton(
                  onPressed: () async {
                    await FireStorePostMethods().likePost(
                        widget.snapshot['postId'],
                        userData.uid,
                        widget.snapshot['likes']);
                  },
                  // child: const ReactionButton(),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    width: 120,
                    child: Row(
                      children: [
                        LikeAnimation(
                          isAnimating:
                              widget.snapshot['likes'].contains(userData.uid),
                          smallLike: true,
                          child: widget.snapshot['likes'].contains(userData.uid)
                              ? const Icon(
                                  Icons.thumb_up_alt,
                                  size: 32,
                                  color: Colors.blue,
                                )
                              : const Icon(
                                  Icons.thumb_up_alt_outlined,
                                  size: 32,
                                  color: Colors.black,
                                ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text('Like'),
                      ],
                    ),
                  ),
                ),
                ActionButton(
                    context: context,
                    icon: Icons.message,
                    label: 'comment',
                    ontap: () {
                      commentDialog(context);
                    }),
                ActionButton(
                    context: context,
                    icon: Icons.share_sharp,
                    label: 'share',
                    ontap: () {}),
                ActionButton(
                    context: context,
                    icon: Icons.bookmark_border_outlined,
                    label: 'save',
                    ontap: () {})
              ],
            ),
            // const Divider(
            //   height: 8,
            //   thickness: 2,
            //   color: Colors.grey,
            // ),
          ],
        ),
      );
    });
  }

  Future<dynamic> commentDialog(BuildContext context) {
    return showDialog(
      barrierColor: Colors.black12,
      context: context,
      builder: (context) => AlertDialog(
          scrollable: true,
          contentPadding: const EdgeInsets.all(0),
          alignment: const Alignment(1, 0),
          content: Container(
            height: 580,
            margin: const EdgeInsets.only(bottom: 10),
            width: 450,
            child: CommentsScreen(
              snapshot: widget.snapshot,
            ),
          )),
    );
  }

  final GlobalKey _menuKey = GlobalKey();

  void _showPopupMenu(PostProvider postProvider) {
    final RenderBox renderBox =
        _menuKey.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
          offset.dx, offset.dy + size.height, offset.dx + size.width, 0),
      items: [
        PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.bookmark),
            title: const Text('Save'),
            onTap: () {
              Navigator.of(context).pop();
              //  Save action
            },
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.link),
            title: const Text('Copy post link'),
            onTap: () {
              Navigator.of(context).pop();
              //  Copy link
            },
          ),
        ),
        !isCurrentUser
            ? PopupMenuItem(
                child: ListTile(
                leading: Icon(postProvider.isConnection
                    ? Icons.person_remove
                    : Icons.person_add),
                title:
                    Text(postProvider.isConnection ? 'disconnect' : 'connect'),
                onTap: () async {
                  await postProvider.manageConnection(widgetUid);

                  message(postProvider);
                },
              ))
            : PopupMenuItem(
                child: ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text('Delete post'),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
        if (isCurrentUser)
          PopupMenuItem(
            child: ListTile(
              leading: const Icon(Icons.edit_document),
              title: const Text('Edit post'),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.visibility_off),
            title: const Text('I don\'t want to see this post'),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        if (!isCurrentUser)
          PopupMenuItem(
            child: ListTile(
              leading: const Icon(Icons.report),
              title: const Text('Report post'),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ),
      ],
    );
  }

  void message(PostProvider postProvider) {
    toastMessage(
        context: context,
        message: "${widget.snapshot['name']} is ${postProvider.response}",
        position: DelightSnackbarPosition.bottom);
    Navigator.of(context).pop();
  }
}
