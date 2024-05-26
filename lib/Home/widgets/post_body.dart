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
import 'package:supplink/utils/snackbars.dart';

class PostCard extends StatefulWidget {
  final snapshot;
  const PostCard({super.key, required this.snapshot});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  int commentsLength = 0;
  bool isFollowing = false;
  final User user = FirebaseAuth.instance.currentUser!;
  @override
  void initState() {
    super.initState();
    getAllComments();
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
      // if (widget.snapshot['uid'] == user.uid) {
      //   isFollowing = false;
      // } else {
      //   var usersnap = await FirebaseFirestore.instance
      //       .collection('Users')
      //       .doc(widget.snapshot['uid'])
      //       .get();
      //   isFollowing = usersnap.data()!['followers'].contains(user.uid);
      // }
    } catch (e) {
      showSnackBar(context, e.toString());
      // print(e.toString());
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
                  radius: 16,
                  backgroundImage: NetworkImage(widget.snapshot['profileUrl']),
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.snapshot['name'],
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                )),
                // isFollowing
                //     ? CustomButton(
                //         function: () async {
                //           await FireBaseFireStoreMethods()
                //               .followUser(user.uid, widget.snapshot['uid']);
                //           setState(() {
                //             isFollowing = true;
                //           });
                //         },
                //         text: 'follow',
                //         backgroundcolor: Colors.blue,
                //         textColor: Colors.white,
                //         width:
                //             MediaQuery.of(context).size.width > 600 ? 200 : 150,
                //       )
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
                    fit: BoxFit.cover,
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 400),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: LikeAnimation(
                      isAnimating: isLikeAnimating,
                      duration: const Duration(milliseconds: 300),
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
            children: [
              LikeAnimation(
                isAnimating: widget.snapshot['likes'].contains(userData.uid),
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
              IconButton(
                  onPressed: () {
                    commentDialog(context);
                  },

                  // onPressed: () => Navigator.of(context)
                  //         .push(MaterialPageRoute(builder: (context) {
                  //       return CommentsScreen(snapshot: widget.snapshot);
                  //     })),
                  icon: const Icon(
                    Icons.message_rounded,
                    size: 32,
                    color: Colors.black,
                  )),
              IconButton(
                onPressed: () {},
                icon: SvgPicture.asset(
                  'assets/instagram-share-icon (1).svg',
                  height: 25,
                  color: Colors.black,
                ),
              ),
              const Spacer(),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.bookmark_border_outlined,
                    size: 32,
                  ))
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
                DefaultTextStyle(
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(fontWeight: FontWeight.w800),
                  child: Text(
                    '${widget.snapshot['likes'].length} likes',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
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
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: InkWell(
                    onTap: () {
                      commentDialog(context);
                    },
                    child: Text(
                      "view all $commentsLength comments ",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),
                Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      DateFormat.yMMMd()
                          .format(widget.snapshot['datePublished'].toDate()),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ))
              ],
            ),
          )
        ],
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
