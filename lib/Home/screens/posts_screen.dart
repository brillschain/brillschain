import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:supplink/Home/widgets/post_body.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  late Stream<List<QueryDocumentSnapshot>> _postStream;
  final StreamController<List<QueryDocumentSnapshot>> _streamController =
      StreamController<List<QueryDocumentSnapshot>>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _postStream = FirebaseFirestore.instance
        .collection('posts')
        .orderBy('datePublished', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs);

    _postStream.listen((posts) {
      _streamController.add(posts);
    });
  }

  Future<void> shufflePosts() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('posts').get();
    List<QueryDocumentSnapshot> posts = snapshot.docs;
    posts.shuffle(Random());
    _streamController.add(posts);
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: shufflePosts,
        child: StreamBuilder<List<QueryDocumentSnapshot>>(
          stream: _streamController.stream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text("No posts available"),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return PostCard(
                    snapshot:
                        snapshot.data![index].data() as Map<String, dynamic>);
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _refreshIndicatorKey.currentState?.show();
          shufflePosts();
        },
        child: const Icon(Icons.replay_outlined),
      ),
    );
  }
}














//post with no refershing indicator


// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:supplink/Home/widgets/post_body.dart';

// class PostScreen extends StatefulWidget {
//   const PostScreen({super.key});

//   @override
//   State<PostScreen> createState() => _PostScreenState();
// }

// class _PostScreenState extends State<PostScreen> {
//   @override
//   Widget build(BuildContext context) {
//     var stream = FirebaseFirestore.instance
//         .collection('posts')
//         .orderBy('datePublished', descending: true)
//         .snapshots();
//     Future<void> refreshPosts() async {
//       await Future.delayed(const Duration(milliseconds: 1000));
//       setState(() {
//         stream = FirebaseFirestore.instance
//             .collection('posts')
//             .orderBy('datePublished', descending: false)
//             .snapshots();
//       });
//     }

//     return Scaffold(
//       body: RefreshIndicator(
//         onRefresh: refreshPosts,
//         child: StreamBuilder(
//           stream: stream,
//           builder: ((context,
//               AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             }
//             if (!snapshot.hasData) {
//               return const Center(
//                 child: Text("No posts available"),
//               );
//             }
//             return ListView.builder(
//                 itemCount: snapshot.data!.docs.length,
//                 itemBuilder: ((context, index) {
//                   return PostCard(snapshot: snapshot.data!.docs[index].data());
//                 }));
//           }),
//         ),
//       ),
//       floatingActionButton: IconButton(
//           onPressed: refreshPosts, icon: const Icon(Icons.replay_outlined)),
//     );
//   }
// }
