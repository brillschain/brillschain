import 'package:flutter/material.dart';
// import 'dart:convert';

// import 'package:supabase/supabase.dart';
// import 'package:supplink/Backend/supaBaseDB/superbaseCredentials.dart';
// import 'package:supplink/Backend/supaBaseDB/superbaseServices/Strorages/connectionsUrlManager.dart';
// import 'package:http/http.dart' as http;
// import 'package:supplink/Authentication/authRoutes/AppRoutes.dart';
// import 'package:supplink/Backend/supaBaseDB/superbaseServices/Strorages/constants.dart';
import 'package:supplink/Backend/firebase/userDetailsmaintain.dart';
import 'package:supplink/Trails/comments.dart';

class MyPosts extends StatefulWidget {
  const MyPosts({super.key});

  @override
  State<MyPosts> createState() => _MyPostsState();
}

class _MyPostsState extends State<MyPosts> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(300, 0, 0, 0),
      child: Card(
        elevation: 3,
        color: Colors.white,
        child: Container(
          child: MyPostsConnections(),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          width: 550,
          height: double.infinity,
        ),
      ),
    );
  }
}

class MyPostsConnections extends StatefulWidget {
  const MyPostsConnections({Key? key}) : super(key: key);

  @override
  _MyPostsConnectionsState createState() => _MyPostsConnectionsState();
}

class _MyPostsConnectionsState extends State<MyPostsConnections> {
  UserDetailsTable userDetailsTable = UserDetailsTable();
  late Future<List<CurrentUserPostDetails>> userPosts;

  @override
  void initState() {
    super.initState();
    userPosts = userDetailsTable.fetchUserPosts();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CurrentUserPostDetails>>(
      future: userPosts,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text('No posts available.'),
          );
        } else {
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 550,
              childAspectRatio: 1,
              mainAxisSpacing: 10,
            ),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var post = snapshot.data![index];
              return Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 7,
                    ),
                    PostHead(post: post),
                    SizedBox(
                      height: 8,
                    ),
                    PostStatement(post: post),
                    SizedBox(
                      height: 5,
                    ),
                    PostBody(post: post),
                    PostBottom(post: post),
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }
}

class PostHead extends StatelessWidget {
  final CurrentUserPostDetails post;

  const PostHead({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        post.profile.isNotEmpty
            ? CircleAvatar(
                backgroundImage: NetworkImage(post.profile),
                radius: 30,
              )
            : Icon(
                Icons.account_circle_sharp,
                size: 60,
              ),
        SizedBox(
          width: 5,
        ),
        Expanded(
          child: Container(
            // width: 360,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Text(
                  post.address,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
        Spacer(),
        // ElevatedButton(
        //   onPressed: () {},
        //   child: Text('Connect'),
        //   style: ButtonStyle(),
        // ),
        IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
      ],
    );
  }
}

class PostBottom extends StatelessWidget {
  final CurrentUserPostDetails post;

  const PostBottom({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 1,
        ),
        Text(post.postDate),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
                onPressed: () {}, icon: Icon(Icons.favorite_border_sharp)),
            IconButton(
                onPressed: () {
                  showDialog(
                    barrierColor: Colors.black12,
                    context: context,
                    builder: (context) => AlertDialog(
                        scrollable: true,
                        contentPadding: EdgeInsets.all(0),
                        alignment: Alignment(1, 0),
                        content: Container(
                          height: 600,
                          margin: EdgeInsets.all(0),
                          // width: 450,
                          child: CommentPage(),
                        )),
                  );
                },
                // onPressed: () =>
                //     Navigator.of(context).pushNamed(AppRoutes.CommentsRoute),
                icon: Icon(Icons.mode_comment_rounded)),
            IconButton(onPressed: () {}, icon: Icon(Icons.ios_share)),
            IconButton(onPressed: () {}, icon: Icon(Icons.golf_course)),
          ],
        ),
      ],
    );
  }
}

class PostStatement extends StatelessWidget {
  final CurrentUserPostDetails post;

  const PostStatement({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
            height: 40,
            child: Text(
              post.statement,
              style: TextStyle(
                fontSize: 16,
              ),
            )),
      ],
    );
  }
}

class PostBody extends StatelessWidget {
  final CurrentUserPostDetails post;

  const PostBody({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 360,
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 249, 241, 241),
          image: DecorationImage(
              fit: BoxFit.cover,
              alignment: Alignment.center,
              image: NetworkImage(post.posturl))),
    );
  }
}

// class CommentsButton {
//   // CommentPage commentPage = CommentPage();
//    List<Comment> comments = [
//     Comment(
//       id: '1',
//       username: 'User1',
//       avatar: 'assets/avatar1.jpg',
//       text: 'Root Comment 1',
//       replies: [
//         Comment(
//             id: '1.1',
//             username: 'User2',
//             avatar: 'assets/avatar2.jpg',
//             text: 'Reply 1 to Root Comment 1'),
//         Comment(
//             id: '1.2',
//             username: 'User3',
//             avatar: 'assets/avatar3.jpg',
//             text: 'Reply 2 to Root Comment 1'),
//       ],
//     ),
//     Comment(
//       id: '2',
//       username: 'User4',
//       avatar: 'assets/avatar4.jpg',
//       text: 'Root Comment 2',
//       replies: [],
//     ),
//     Comment(
//         id: '3',
//         username: 'User5',
//         avatar: 'assets/avatar5.jpg',
//         text: 'Root Comment 3',
//         replies: []),
//   ];

// }


// class MyPostsConnections extends StatefulWidget {
//   const MyPostsConnections({super.key});

//   @override
//   State<MyPostsConnections> createState() => _MyPostsConnectionsState();
// }

// class _MyPostsConnectionsState extends State<MyPostsConnections> {
//   List<int> myposts = List.generate(100, (index) => index);
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: EdgeInsets.all(3),
//         child: GridView.builder(
//             gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
//               maxCrossAxisExtent: 550,
//               childAspectRatio: 1,
//               mainAxisSpacing: 10,
//               // crossAxisSpacing: 10
//             ),
//             itemCount: myposts.length,
//             itemBuilder: (context, index) {
//               return Container(
//                 // margin: EdgeInsets.all(10),
//                 alignment: Alignment.center,
//                 decoration: BoxDecoration(
//                   color: Color.fromARGB(253, 182, 225, 247),
//                   // borderRadius: BorderRadius.circular(20)
//                 ),
//                 child: Column(
//                   children: [
//                     SizedBox(
//                       height: 7,
//                     ),
//                     PostHead(),
//                     SizedBox(
//                       height: 8,
//                     ),
//                     PostStatement(),
//                     SizedBox(
//                       height: 5,
//                     ),
//                     PostBody(),
//                     // SizedBox(
//                     //   height: 3,
//                     // ),
//                     PostBottom()
//                   ],
//                 ),
//               );
//             }),
//       ),
//     );
//   }
// }

// class PostHead extends StatefulWidget {
//   const PostHead({super.key});

//   @override
//   State<PostHead> createState() => _PostHeadState();
// }

// class _PostHeadState extends State<PostHead> {
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Icon(
//           Icons.account_circle_sharp,
//           size: 40,
//         ),
//         SizedBox(
//           width: 5,
//         ),
//         Container(
//           width: 360,
//           child: Column(
//             // mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('User Name'),
//               Text('User Location'),
//             ],
//           ),
//         ),
//         ElevatedButton(
//           onPressed: () {},
//           child: Text('Connect'),
//           style: ButtonStyle(),
//         ),
//         IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
//       ],
//     );
//   }
// }

// class PostBottom extends StatefulWidget {
//   const PostBottom({super.key});

//   @override
//   State<PostBottom> createState() => _PostBottomState();
// }

// class _PostBottomState extends State<PostBottom> {
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       // crossAxisAlignment: CrossAxisAlignment.stretch,
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         IconButton(onPressed: () {}, icon: Icon(Icons.favorite_border_sharp)),
//         IconButton(onPressed: () {}, icon: Icon(Icons.mode_comment_rounded)),
//         IconButton(onPressed: () {}, icon: Icon(Icons.ios_share)),
//         IconButton(onPressed: () {}, icon: Icon(Icons.golf_course)),
//       ],
//     );
//   }
// }

// class PostStatement extends StatefulWidget {
//   // final String postStatement;
//   // const PostStatement({super.key, required this.postStatement});
//   const PostStatement({super.key});

//   @override
//   State<PostStatement> createState() => _PostStatementState();
// }

// class _PostStatementState extends State<PostStatement> {
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         // Text(widget.postStatement),
//         Container(height: 50, child: Text('post statement and discription')),
//       ],
//     );
//   }
// }

// class PostBody extends StatefulWidget {
//   // final String postUrl, postType;
//   // const PostBody({super.key, required this.postType, required this.postUrl});
//   const PostBody({super.key});

//   @override
//   State<PostBody> createState() => _PostBodyState();
// }

// class _PostBodyState extends State<PostBody> {
//   @override
//   Widget build(BuildContext context) {
//     // if (widget.postType == 'Image') {
//     //   return Image.network(widget.postUrl);
//     // }
//     // if (widget.postType == 'Video') {
//     //   return FlickVideoPlayer(
//     //       flickManager: FlickManager(
//     //     videoPlayerController: VideoPlayerController.networkUrl(
//     //       Uri.parse(
//     //           // 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
//     //           widget.postUrl
//     //           // videoUri,
//     //           ),
//     //     ),
//     //   ));
//     // }
//     return Container(
//       height: 380,
//       color: Color.fromARGB(255, 249, 241, 241),
//     );
//   }
// }
