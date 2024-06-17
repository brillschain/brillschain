import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:supplink/Backend/firebasefirestore/firestore_methods.dart';
import 'package:supplink/Backend/firebasefirestore/firestore_post_methods.dart';
import 'package:supplink/Home/screens/comment_screen.dart';
import 'package:supplink/Home/widgets/custom_button.dart';
import 'package:supplink/Home/widgets/like_animation.dart';
import 'package:supplink/Providers/user_provider.dart';
import 'package:supplink/models/user_model.dart';
import 'package:supplink/utils/hover_text.dart';
import 'package:supplink/utils/snackbars.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostCard extends StatefulWidget {
  final snapshot;
  const PostCard({super.key, required this.snapshot});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  int commentsLength = 0;
  bool isConnection = false;
  bool isCurrentUser = false;
  final User user = FirebaseAuth.instance.currentUser!;
  @override
  void initState() {
    super.initState();
    getAllComments();
    fetchIsConnection();
  }

  void getAllComments() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snapshot['postId'])
          .collection('comments')
          .get();

      setState(() {
        commentsLength = querySnapshot.docs.length;
      });
    } catch (e) {
      showSnackBar(context, e.toString());
      // print(e.toString());
    }
  }

  void fetchIsConnection() async {
    // print(widget.snapshot['uid']);
    // print(user.uid);
    if (widget.snapshot['uid'] == user.uid) {
      isConnection = true;
      isCurrentUser = true;
    } else {
      try {
        var usersnap = await FirebaseFirestore.instance
            .collection('Users')
            .doc(widget.snapshot['uid'])
            .get();
        // print(usersnap);
        var ids = usersnap.data()!['connections'] ?? [];
        // print(ids.length);
        // print(ids);
        // print(ids);
        isConnection = ids.contains(user.uid);
      } catch (e) {
        print(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserData userData = Provider.of<UserProvider>(context).getUser;
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                .copyWith(right: 0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(widget.snapshot['profileUrl']),
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
                // !isCurrentUser
                //     ? isConnection
                //         ? CustomButton(
                //             function: () async {
                //               await FireBaseFireStoreMethods().connectUser(
                //                   user.uid, widget.snapshot['uid']);
                //               setState(() {
                //                 isConnection = false;
                //               });
                //             },
                //             text: 'Connected',
                //             backgroundcolor: Colors.green,
                //             textColor: Colors.white,
                //             width: MediaQuery.of(context).size.width > 600
                //                 ? 150
                //                 : 120,
                //           )
                //         : CustomButton(
                //             function: () async {
                //               await FireBaseFireStoreMethods().connectUser(
                //                   user.uid, widget.snapshot['uid']);
                //               setState(() {
                //                 isConnection = true;
                //               });
                //             },
                //             text: 'Connect',
                //             backgroundcolor: Colors.blue,
                //             textColor: Colors.white,
                //             width: MediaQuery.of(context).size.width > 600
                //                 ? 150
                //                 : 120,
                //           )
                //     : const SizedBox(),
                IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              child: ListView(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shrinkWrap: true,
                                children: ['Delete']
                                    .map((e) => InkWell(
                                          onTap: () async {
                                            FireStorePostMethods().deletePost(
                                                widget.snapshot['postId'],
                                                context);
                                            Navigator.of(context).pop();
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12, horizontal: 16),
                                            child: Text(e),
                                          ),
                                        ))
                                    .toList(),
                              ),
                            );
                          });
                    },
                    icon: const Icon(Icons.more_vert))
              ],
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${widget.snapshot['likes'].length} likes'),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: InkWell(
                  onTap: () {
                    commentDialog(context);
                  },
                  child: HoverText(
                    text: "$commentsLength comments ",
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
          const Divider(
            height: 10,
            thickness: 2,
            color: Colors.grey,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  LikeAnimation(
                    isAnimating:
                        widget.snapshot['likes'].contains(userData.uid),
                    smallLike: true,
                    child: IconButton(
                      onPressed: () async {
                        await FireStorePostMethods().likePost(
                            widget.snapshot['postId'],
                            userData.uid,
                            widget.snapshot['likes']);
                      },
                      icon: widget.snapshot['likes'].contains(userData.uid)
                          ? const Icon(
                              Icons.favorite,
                              size: 32,
                              color: Colors.red,
                            )
                          : const Icon(
                              Icons.favorite_border_outlined,
                              size: 32,
                              color: Colors.black,
                            ),
                    ),
                  ),
                  const Text('Like'),
                ],
              ),
              actionButton(
                  context: context,
                  icon: Icons.message_rounded,
                  label: 'comment',
                  ontap: () {
                    commentDialog(context);
                  }),

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: SvgPicture.asset(
                      'assets/instagram-share-icon (1).svg',
                      height: 25,
                      color: Colors.black,
                    ),
                  ),
                  const Text('share')
                ],
              ),
              // const Spacer(),
              // actionButton(context, Icons.bookmark_border_outlined, 'save'),
              actionButton(
                  context: context,
                  icon: Icons.bookmark_border_outlined,
                  label: 'save',
                  ontap: () {})
              // IconButton(
              //     onPressed: () {},
              //     icon: const Icon(
              //       Icons.bookmark_border_outlined,
              //       size: 32,
              //     ))
            ],
          ),
          //description
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // DefaultTextStyle(
                //   style: Theme.of(context)
                //       .textTheme
                //       .titleSmall!
                //       .copyWith(fontWeight: FontWeight.w800),
                //   child: Text(
                //     '${widget.snapshot['likes'].length} likes',
                //     style: Theme.of(context).textTheme.bodyMedium,
                //   ),
                // ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 8),
                  child: RichText(
                      text: TextSpan(
                          style: const TextStyle(color: Colors.black),
                          children: [
                        TextSpan(
                          text: '${widget.snapshot['name']}  ',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: widget.snapshot['description'],
                        )
                      ])),
                ),
                // Container(
                //   padding: const EdgeInsets.symmetric(vertical: 4),
                //   child: InkWell(
                //     onTap: () {
                //       commentDialog(context);
                //     },
                //     child: Text(
                //       "view all $commentsLength comments ",
                //       style: const TextStyle(
                //         fontSize: 16,
                //         color: Colors.black54,
                //       ),
                //     ),
                //   ),
                // ),
                // Text(
                //   DateFormat.yMMMd()
                //       .format(widget.snapshot['datePublished'].toDate()),
                //   style: const TextStyle(
                //     fontSize: 16,
                //     color: Colors.black54,
                //   ),
                // ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget actionButton(
      {required BuildContext context,
      required IconData icon,
      required String label,
      required Function() ontap}) {
    return InkWell(
      onTap: ontap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32,
              color: Colors.black,
            ),
            Text(label)
          ],
        ),
      ),
    );
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
            margin: const EdgeInsets.all(0),
            width: 450,
            child: CommentsScreen(
              snapshot: widget.snapshot,
            ),
          )),
    );
  }
}
