import 'package:flutter/material.dart';
// import 'package:supplink/Home/drawer_pages/connectionsFolder/myPostsConnections.dart';

class Comment {
  final String id;
  final String username;
  final String avatar;
  final String text;
  final List<Comment> replies;
  int likes;
  bool repliesVisible;
  bool liked;

  Comment(
      {required this.id,
      required this.username,
      required this.avatar,
      required this.text,
      this.replies = const [],
      this.likes = 0,
      this.repliesVisible = false,
      this.liked = false});
}

class CommentPage extends StatefulWidget {
  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  List<Comment> comments = [
    Comment(
      id: '1',
      username: 'User1',
      avatar: 'assets/avatar1.jpg',
      text: 'Root Comment 1',
      replies: [
        Comment(
            id: '1.1',
            username: 'User2',
            avatar: 'assets/avatar2.jpg',
            text: 'Reply 1 to Root Comment 1',
            replies: []),
        Comment(
            id: '1.2',
            username: 'User3',
            avatar: 'assets/avatar3.jpg',
            text: 'Reply 2 to Root Comment 1',
            replies: []),
      ],
    ),
    Comment(
      id: '2',
      username: 'User4',
      avatar: 'assets/avatar4.jpg',
      text: 'Root Comment 2',
      replies: [],
    ),
    Comment(
        id: '3',
        username: 'User5',
        avatar: 'assets/avatar5.jpg',
        text: 'Root Comment 3',
        replies: []),
  ];

  // List<Comment> comments = [];
  // CommentsButton commentsButton = CommentsButton();
  TextEditingController _commentController = TextEditingController();
  TextEditingController replyController = TextEditingController();
  // void initstate() {
  //   super.initState();
  //   comments = commentsButton.comments;
  //   print(comments);
  // }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 600,
        child: Card(
          elevation: 3,
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text('Comment Page'),
            ),
            body: ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) {
                return buildComment(comments[index]);
              },
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        hintText: 'Add a comment...',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      // Add your logic to handle sending the comment
                      String newCommentText = _commentController.text;
                      if (newCommentText.isNotEmpty) {
                        Comment newComment = Comment(
                          id: '4', // You should generate a unique ID for new comments
                          username: 'NewUser',
                          avatar: 'assets/new_avatar.jpg',
                          text: newCommentText,
                          replies: [],
                        );
                        setState(() {
                          comments.add(newComment);
                        });
                        _commentController.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildComment(Comment comment) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Row(
              children: [
                Container(
                  width: 300,
                  child: Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          // backgroundImage: "",
                          child: Text(comment.username[0]),
                          radius: 20,
                        ),
                        title: Text(comment.username,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        subtitle: GestureDetector(
                            onDoubleTap: () {
                              setState(() {
                                comment.liked = !comment.liked;
                                comment.liked
                                    ? comment.likes++
                                    : comment.likes--;
                              });
                            },
                            onTap: () {
                              setState(() {
                                comment.repliesVisible =
                                    !comment.repliesVisible;
                              });
                            },
                            child: Text(comment.text,
                                style: TextStyle(fontSize: 12))),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            comment.repliesVisible = !comment.repliesVisible;
                          });
                        },
                        // onTap: ,
                        child:
                            Text('Reply', style: TextStyle(color: Colors.blue)),
                      )
                    ],
                  ),
                ),
                Spacer(),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        onPressed: () {
                          setState(() {
                            comment.liked = !comment.liked;
                            // print(comment.liked);
                            comment.liked ? comment.likes++ : comment.likes--;
                          });
                        },
                        icon: Icon(comment.liked
                            ? Icons.favorite
                            : Icons.favorite_border)),
                    Text('${comment.likes}')
                  ],
                ),
              ],
            ),
          ),
          if (comment.repliesVisible) ...[
            Padding(
              padding: const EdgeInsets.only(left: 50),
              child: Container(
                width: 600,
                // height: 40,
                child: Card(
                  elevation: 2,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: replyController,
                          decoration: InputDecoration(
                            hintText: 'Reply ',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 0),
                        child: IconButton(
                          onPressed: () {
                            String replyText = replyController.text;
                            if (replyText.isNotEmpty) {
                              Comment newReply = Comment(
                                  id: '${comment.id}.${comment.replies.length + 1}',
                                  username: 'NewUser',
                                  avatar: '',
                                  text: replyText,
                                  replies: []);
                              setState(() {
                                comment.replies.add(newReply);
                              });
                              replyController.clear();
                            }
                          },
                          icon: Icon(Icons.send),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 3),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 50),
                child: Column(
                  children: comment.replies
                      .map((reply) => buildrepliesComment(reply))
                      .toList(),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget buildrepliesComment(Comment comment) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Row(
              children: [
                Container(
                  width: 300,
                  child: Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          // backgroundImage: "",
                          child: Text(comment.username[0]),
                          radius: 20,
                        ),
                        title: Text(comment.username,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        subtitle: GestureDetector(
                            onDoubleTap: () {
                              setState(() {
                                comment.liked = !comment.liked;
                                comment.liked
                                    ? comment.likes++
                                    : comment.likes--;
                              });
                            },
                            onTap: () {
                              setState(() {
                                comment.repliesVisible =
                                    !comment.repliesVisible;
                              });
                            },
                            child: Text(comment.text,
                                style: TextStyle(fontSize: 12))),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            comment.repliesVisible = !comment.repliesVisible;
                          });
                        },
                        // onTap: ,
                        child:
                            Text('Reply', style: TextStyle(color: Colors.blue)),
                      )
                    ],
                  ),
                ),
                Spacer(),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        onPressed: () {
                          setState(() {
                            comment.liked = !comment.liked;
                            // print(comment.liked);
                            comment.liked ? comment.likes++ : comment.likes--;
                          });
                        },
                        icon: Icon(comment.liked
                            ? Icons.favorite
                            : Icons.favorite_border)),
                    Text('${comment.likes}')
                  ],
                ),
              ],
            ),
          ),
          if (comment.repliesVisible) ...[
            SizedBox(height: 3),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 50),
                child: Column(
                  children: comment.replies
                      .map((reply) => buildrepliesComment(reply))
                      .toList(),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
