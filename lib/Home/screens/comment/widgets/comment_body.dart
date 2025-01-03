// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:supplink/Backend/firebasefirestore/firestore_post_methods.dart';
import 'package:supplink/Home/widgets/like_animation.dart';
import 'package:supplink/Providers/user_provider.dart';
import 'package:supplink/models/user_model.dart';

class CommentCard extends StatelessWidget {
  final String postId;
  final snapshot;
  const CommentCard({super.key, required this.snapshot, required this.postId});

  @override
  Widget build(BuildContext context) {
    UserData userData = Provider.of<UserProvider>(context).getUser;
    return Container(
      // color: Colors.red,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(snapshot['profileUrl']),
            radius: 18,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                      text: TextSpan(
                          style: const TextStyle(color: Colors.black),
                          children: [
                        TextSpan(
                          text: snapshot['name'],
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: '  ${snapshot['commentText']}',
                        ),
                      ])),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      DateFormat.yMMMd().format(snapshot['timestamp'].toDate()),
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w400),
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                LikeAnimation(
                  isAnimating: snapshot['likes'].contains(userData.uid),
                  smallLike: true,
                  child: IconButton(
                    onPressed: () async {
                      await FireStorePostMethods().likeComment(
                          postId,
                          userData.uid,
                          snapshot['likes'],
                          snapshot['commentId']);
                    },
                    icon: snapshot['likes'].contains(userData.uid)
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
                DefaultTextStyle(
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(fontWeight: FontWeight.w800),
                  child: Text(
                    '${snapshot['likes'].length}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
