import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:supplink/Backend/firebase/userDeatilsmaintain.dart' as us;
import 'package:supplink/Home/posts/allpostextract.dart';
import 'package:supplink/Trails/comments.dart';

class AllUsersPosts extends StatefulWidget {
  const AllUsersPosts({Key? key}) : super(key: key);

  @override
  _AllUsersPostsState createState() => _AllUsersPostsState();
}

class _AllUsersPostsState extends State<AllUsersPosts> {
  AllPostExtract allPostExtract = AllPostExtract();
  static late Future<List<PostDetails>> allUserPosts;

  @override
  void initState() {
    super.initState();
    allUserPosts = allPostExtract.fetchAllUserPosts();
  }
  
Widget _buildShimmerEffect() {
  
  return ListView.builder(
          // itemCount: 5,
          itemBuilder: (BuildContext context, int index) {
            return   Container(
            child: Column(
              children: [
                Container(
                  height: 30,
                  child: Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Shimmer.fromColors(
                          baseColor: Colors.grey,
                          highlightColor: Colors.white,
                          child: Container(
                            width: 30, // Adjust width as needed
                            height: 30, // Adjust height as needed
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white, // Add a color for the shimmer effect
                            ),
                          ),
                        ),
                        SizedBox(width: 20), // Add spacing between shimmer widgets if needed
                        Shimmer.fromColors(
                          baseColor: Colors.grey,
                          highlightColor: Colors.white,
                          child: Container(
                            width: 200, // Adjust width as needed
                            height: 20, // Adjust height as needed
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10), // Add border radius
                              color: Colors.white, // Add a color for the shimmer effect
                            ),
                          ),
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey,
                            highlightColor: Colors.white,
                            child: Container(
                              width: 100,
                              height: 20,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10), // Add border radius
                                color: Colors.white, // Add a color for the shimmer effect
                              ),
                            ),
                          ),
                        ),
                        
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
              Shimmer.fromColors(
                baseColor: Colors.grey,
                highlightColor: Colors.white,
                child: Container(
                  width: 500,
                  height: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10), // Add border radius
                    color: Colors.white, // Add a color for the shimmer effect
                  ),
                ),
              ),
              SizedBox(height: 5,),
              Shimmer.fromColors(
                baseColor: Colors.grey,
                highlightColor: Colors.white,
                child: Container(
                  width: 500,
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10), // Add border radius
                    color: Colors.white, // Add a color for the shimmer effect
                    ),
                  ),
                ),

                SizedBox(
                          height: 15,
                        )
              ],
            ),
          );
        });
}


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PostDetails>>(
      future: allUserPosts,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: _buildShimmerEffect()
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

class PostHead extends StatefulWidget {
  final PostDetails post;

  const PostHead({Key? key, required this.post}) : super(key: key);

  @override
  State<PostHead> createState() => _PostHeadState();
}

class _PostHeadState extends State<PostHead> {
  late bool isconnected = false; //TODO
  late us.UserDetailsTable udt;

  @override
  void initState() {
    super.initState();
    udt = us.UserDetailsTable();

    updateIsconnected();
  }

  final user = FirebaseAuth.instance.currentUser;
  void updateIsconnected() async {
    final isconn = await udt.checkFollower(user!.uid, widget.post.uid);
    setState(() {
      isconnected = isconn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        widget.post.profile.isNotEmpty
            ? CircleAvatar(
                backgroundImage: NetworkImage(widget.post.profile),
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
                  widget.post.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Text(
                  widget.post.address,
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
        ElevatedButton(
            onPressed: () {
              setState(() {
                isconnected = !isconnected;
                if (isconnected) {
                  udt.addFollowers(
                      user!.uid, widget.post.uid, widget.post.name);
                } else {
                  // showDialog(context: context,
                  // builder: (context) => AlertDialog(

                  // ),
                  // );
                  udt.deleteFollower(user!.uid, widget.post.uid);
                }
              });
            },
            child: Text(
              isconnected ? 'Connected' : 'Connect',
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: isconnected ? Colors.green : Colors.blue,
            )),
        IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
      ],
    );
  }
}

class PostBottom extends StatelessWidget {
  final PostDetails post;

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
  final PostDetails post;

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
  final PostDetails post;

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
