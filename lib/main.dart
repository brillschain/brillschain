import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';
// import 'package:scrollable_table_view/scrollable_table_view.dart';
import 'package:provider/provider.dart';
import 'package:supplink/AppIntro/welcome.dart';
// import 'package:supplink/Home/drawer_pages/dashBoard.dart';
import 'package:supplink/Providers/authAppProvider.dart';
import 'package:supplink/Routes/Routes.dart';
// import 'package:supplink/Providers/firebase/firebase_providers.dart';
// import 'package:supplink/Trails/comments.dart';
import 'package:supplink/firebase_options.dart';

void main() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: AppProviders.providers,
      child: const HomePage(),
    );
    // return ChangeNotifierProvider(
    //     create: (_) => FirebaseProvider(),
    //     child: MultiProvider(child: HomePage(), providers: AppProviders.providers));
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // initialRoute: AppRoutes.WelcomeRoute,
      routes: AppRoutes.Routes,
      home: WelcomePage(),
      // home: Center(
      //   child: Text('Supply chain'),
      // ),
    );
  }
}




// -----------------------------------------------------------------------------------------------------
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (context) => PostProvider(),
//       child: MaterialApp(
//         title: 'Flutter Demo',
//         home: PostListPage(),
//       ),
//     );
//   }
// }

// class PostProvider with ChangeNotifier {
//   List<String> posts = [];

//   Future<void> fetchPosts() async {
//     // Simulate fetching posts from an API
//     await Future.delayed(Duration(seconds: 2));
//     posts = ['Post 1', 'Post 2', 'Post 3', 'Post 4', 'Post 5'];
//     notifyListeners();
//   }
// }

// class PostListPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     var postProvider = Provider.of<PostProvider>(context);

//     return Scaffold(
//       appBar: AppBar(title: Text('Posts')),
//       body: ListView.builder(
//         itemCount: postProvider.posts.length,
//         itemBuilder: (context, index) {
//           return ListTile(title: Text(postProvider.posts[index]));
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           await postProvider.fetchPosts();
//         },
//         child: Icon(Icons.refresh),
//       ),
//     );
//   }
// }


//------------------------------------------------------------------------------------------------------

// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';
// import 'package:carousel_slider/carousel_slider.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Lottie Animation Homepage',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//         fontFamily: 'Montserrat', // Custom font family
//       ),
//       home: HomePageCarousel(),
//     );
//   }
// }

// class HomePageCarousel extends StatelessWidget {
//   final List<Widget> pages = [
//     HomePage(
//       tagline: 'Welcome to Our Website!',
//       buttonLabel: 'Learn More',
//       animation: 'assets/animations/your_animation.json',
//       backgroundColor: Colors.blue.shade900,
//     ),
//     HomePage(
//       tagline: 'Discover Amazing Features',
//       buttonLabel: 'Explore',
//       animation: 'assets/animations/your_animation_2.json',
//       backgroundColor: Colors.purple.shade900,
//     ),
//     HomePage(
//       tagline: 'Get Started Today',
//       buttonLabel: 'Sign Up Now',
//       animation: 'assets/animations/your_animation_3.json',
//       backgroundColor: Colors.orange.shade900,
//     ),
//     // Add more HomePage instances for more pages
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: true, // Extend the body behind the app bar
//       appBar: AppBar(
//         backgroundColor: Colors.transparent, // Make the app bar transparent
//         elevation: 0, // Remove the app bar shadow
//         title: Row(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Icon(
//                 Icons.home,
//                 color: Colors.white, // Icon color
//               ),
//             ),
//             Text(
//               'Company Name',
//               style: TextStyle(
//                 color: Colors.white, // Text color
//                 fontSize: 24, // Font size
//                 fontWeight: FontWeight.bold, // Bold font weight
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(
//               Icons.home,
//               color: Colors.white, // Icon color
//             ),
//             onPressed: () {
//               // Add functionality
//             },
//           ),
//           IconButton(
//             icon: Icon(
//               Icons.description,
//               color: Colors.white, // Icon color
//             ),
//             onPressed: () {
//               // Add functionality
//             },
//           ),
//           // Add more IconButton widgets for other options
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             CarouselSlider(
//               options: CarouselOptions(
//                 height: MediaQuery.of(context).size.height * 0.8,
//                 viewportFraction: 1.0,
//                 enableInfiniteScroll: false,
//                 autoPlay: false,
//                 scrollDirection: Axis.horizontal,
//               ),
//               items: pages.map((page) {
//                 return Builder(
//                   builder: (BuildContext context) {
//                     return Container(
//                       width: MediaQuery.of(context).size.width,
//                       decoration: BoxDecoration(
//                         color: page.backgroundColor,
//                       ),
//                       child: page,
//                     );
//                   },
//                 );
//               }).toList(),
//             ),
//             // Add more sections below the carousel
//             SectionWidget(
//               title: 'Section Title 1',
//               description: 'Description for Section 1.',
//               backgroundColor: Colors.grey.shade200,
//             ),
//             SectionWidget(
//               title: 'Section Title 2',
//               description: 'Description for Section 2.',
//               backgroundColor: Colors.grey.shade300,
//             ),
//             SectionWidget(
//               title: 'Section Title 3',
//               description: 'Description for Section 3.',
//               backgroundColor: Colors.grey.shade400,
//             ),
//             // Add more SectionWidget instances for more sections
//           ],
//         ),
//       ),
//     );
//   }
// }

// class HomePage extends StatelessWidget {
//   final String tagline;
//   final String buttonLabel;
//   final String animation;
//   final Color backgroundColor;

//   const HomePage({
//     Key? key,
//     required this.tagline,
//     required this.buttonLabel,
//     required this.animation,
//     required this.backgroundColor,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             tagline,
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 28,
//               fontWeight: FontWeight.bold,
//               letterSpacing: 1.5,
//               shadows: [
//                 Shadow(
//                   color: Colors.black.withOpacity(0.5),
//                   blurRadius: 4,
//                   offset: Offset(2, 2),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: () {
//               // Add your action here
//             },
//             style: ElevatedButton.styleFrom(
//               primary: Colors.orange,
//               onPrimary: Colors.white,
//               padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(30),
//               ),
//             ),
//             child: Text(
//               buttonLabel,
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           SizedBox(height: 20),
//           Lottie.asset(
//             animation, // Path to your Lottie animation file
//             fit: BoxFit.cover,
//             width: MediaQuery.of(context).size.width,
//             height: MediaQuery.of(context).size.height * 0.6,
//           ),
//         ],
//       ),
//     );
//   }
// }

// class SectionWidget extends StatelessWidget {
//   final String title;
//   final String description;
//   final Color backgroundColor;

//   const SectionWidget({
//     Key? key,
//     required this.title,
//     required this.description,
//     required this.backgroundColor,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: backgroundColor,
//       padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Text(
//             title,
//             style: TextStyle(
//               fontSize: 32,
//               fontWeight: FontWeight.bold,
//               color: Colors.black,
//             ),
//           ),
//           SizedBox(height: 20),
//           Text(
//             description,
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: 18,
//               color: Colors.black87,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }




//-------------------------------------------------------------------------------------------------------
// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Lottie Animation Homepage',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//         fontFamily: 'Montserrat', // Custom font family
//       ),
//       home: HomePage(),
//     );
//   }
// }

// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<double> _animation;
//   late AnimationController _titleAnimationController;
//   late Animation<double> _titleAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 1500),
//     );
//     _animation = Tween<double>(begin: 1.0, end: 0.0).animate(
//       CurvedAnimation(
//         parent: _animationController,
//         curve: Curves.easeInOut,
//       ),
//     );
//     _animationController.forward();

//     _titleAnimationController = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 4000),
//     );

//     _titleAnimation = Tween<double>(begin: 0, end: 1).animate(
//       CurvedAnimation(
//         parent: _titleAnimationController,
//         curve: Curves.easeOutSine,
//       ),
//     );

//     _titleAnimationController.addStatusListener((status) {
//       if (status == AnimationStatus.completed) {
//         _titleAnimationController.stop();
//       }
//     });

//     _titleAnimationController.forward();
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     _titleAnimationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         title: Row(
//           children: [
//             // FadeTransition(
//             //   opacity: _animation,
//             //   child: Text(
//             //     'Wave Technologies',
//             //     style: TextStyle(
//             //       color: Colors.white,
//             //       fontSize: 24,
//             //       fontWeight: FontWeight.bold,
//             //     ),
//             //   ),
//             // ),
//             Padding(
//               padding: const EdgeInsets.only(left: 130),
//               child: FadeTransition(
//                 opacity: _titleAnimation,
//                 child: Text(
//                   'Wave Technologies',
//                   style: TextStyle(
//                     color: Color.fromARGB(255, 238, 170, 245),
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           _buildHeaderButton('Home'),
//           _buildHeaderButton('Services'),
//           _buildHeaderButton('Products'),
//           _buildHeaderButton('Contact Us'),
//           SizedBox(width: 16),
//        ElevatedButton(
//             onPressed: () {
//               // Add your action for Login
//             },
//             style: ElevatedButton.styleFrom(
//               // primary: Colors.orange,
//               // onPrimary: Colors.white,
//               padding: EdgeInsets.symmetric(horizontal: 10, vertical: 1),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(20),
//               ),
//             ),
//             child: Text('Login'),
//           ),
//           SizedBox(width: 8),
//           ElevatedButton(
//             onPressed: () {
//               // Add your action for Sign Up
//             },
//             style: ElevatedButton.styleFrom(
//               // primary: Colors.orange,
//               // onPrimary: Colors.white,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(4),
//               ),
//             ),
//             child: Text('Sign Up'),
//           ),
//           SizedBox(width: 16),
//         ],
//       ),
//       body: Stack(
//         children: [
//           Lottie.asset(
//             'assets/Animation - 1711652608670.json',
//             fit: BoxFit.cover,

//             width: double.infinity,
//             height: double.infinity,
//           ),
//           Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [
//                   const Color.fromARGB(255, 0, 75, 188)!.withOpacity(0.9),
//                   const Color.fromARGB(255, 118, 166, 205)!.withOpacity(0.4),
//                   Color.fromARGB(255, 13, 16, 87)!.withOpacity(0.1),
//                 ],
//               ),
//             ),
//           ),
//           Positioned(
//             top: 4.0,
//             left: 4.0,
//             child: FadeTransition(
//               opacity: _titleAnimation,
//               child: Lottie.asset(
//                 'AppTitle.json',
//                 width: 150,
//                 height: 80,
//                 repeat: false,
//                 animate: true,
//               ),
//             ),
//           ),
//           Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 SlideTransition(
//                   position: Tween<Offset>(
//                     begin: Offset(1.0, 0.0),
//                     end: Offset(0.0, 0.0),
//                   ).animate(_animationController),
//                   child: Text(
//                     'Your Tagline Here',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 28,
//                       fontWeight: FontWeight.bold,
//                       letterSpacing: 1.5,
//                       shadows: [
//                         Shadow(
//                           color: Colors.black.withOpacity(0.5),
//                           blurRadius: 4,
//                           offset: Offset(2, 2),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 ScaleTransition(
//                   scale: _animationController,
//                   child: ElevatedButton(
//                     onPressed: () {
//                       // Add your action here
//                     },
//                     style: ElevatedButton.styleFrom(
//                       // primary: Colors.orange,
//                       // onPrimary: Colors.white,
//                       padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                     ),
//                     child: Text(
//                       'Call to Action',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildHeaderButton(String text) {
//     return TextButton(
//       onPressed: () {
//         // Add action for the button
//       },
//       child: Text(
//         text,
//         style: TextStyle(
//           color: Colors.white,
//           fontWeight: FontWeight.bold,
//           decoration: TextDecoration.underline,
//         ),
//       ),
//     );
//   }
// }





// https://lottie.host/bac23f83-1a89-4b0f-a8a0-1c6a7e679f3b/lJLCO3kzHq.json
// ------------------------------------------------------------------------------------------------------
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//           body: ListView(
//             children: [
//               // Load a Lottie file from your assets

//               // Lottie.asset('assets/LottieLogo1.json'),

//               // Load a Lottie file from a remote url
//               Lottie.asset(
//                   'assets/Animation - 1711652608670.json'),

//               // Load an animation and its images from a zip file
//               // Lottie.asset('assets/lottiefiles/angel.zip'),
//             ],
//           ),
//         ),
//     );
//   }
// }



// -------------------------------------------------------------------------------------------------------

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: CommentPage(
//           // title: "Comments page",
//           ),
//     );
//   }
// }

//----------------------------------------------------------------------------------------------------------



// import 'dart:ui_web';
// import 'dart:convert';
// import 'package:flutter/material.dart';

// List<Player> players = [];

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: TextButton(
//         child: Text('Press bro'),
//         onPressed: () async {
//           print("hello world");
//           try{
//           final File file = File('C:/Users/user/Downloads/supplink/lib/test.json'); //load the json file
//           print('readed');
//           await readPlayerData(file); //read data from json file
//           print('playerdatareaded');


//           Player newPlayer = Player(  //add a new item to data list
//             'Samy Brook',
//             '31',
//             'cooking'
//             );

//         players.add(newPlayer);

//         print(players.length);

//         players  //convert list data  to json
//             .map(
//               (player) => player.toJson(),
//             )
//             .toList();
//           print('write');

//           file.writeAsStringSync(json.encode(players));  //write (the whole list) to json file
//           print('ok');
//           }catch(e){
//             print(e);
//           }
//       }

//       ),
//     );
//   }
// }



// Future<void> readPlayerData (File file) async {

//     print('fugds');
//     String contents = await file.readAsString();
//     print('dfdsfd');
//     var jsonResponse = jsonDecode(contents);
//     print('object');

//     for(var p in jsonResponse){

//         Player player = Player(p['name'],p['age'],p['hobby']);
//         players.add(player);
//     }


// }

// class Player {
//   late String name;
//   late String age;
//   late String hobby;


//   Player(
//      this.name,
//      this.age,
//     this.hobby,

//   );

//   Player.fromJson(Map<String, dynamic> json) {
//     name = json['name'];
//     age = json['age'];
//     hobby = json['hobby'];

//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['name'] = this.name;
//     data['age'] = this.age;
//     data['hobby'] = this.hobby;

//     return data;
//   }

// }


// //WORKING
// import 'dart:convert';
// import 'dart:io';
// import 'dart:io' hide File;







































// import 'package:flutter/material.dart';
// // import 'dart:io';
// // import 'package:supabase/supabase.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// // import 'package:universal_io/io.dart';

// // import 'package:storage_client/src/file_stub.dart';
// // import 'package:storage_client/storage_client.dart';


// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       // Hide the debug banner
//       debugShowCheckedModeBanner: false,
//       title: 'dbestech',
//       theme: ThemeData(
//         useMaterial3: true,
//         primarySwatch: Colors.blue,
//       ),
//       home: const HomePage(),
//     );
//   }
// }

// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   static const supabaseUrl = 'https://pgmargyrgwnfydjnszma.supabase.co';
//   static const supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBnbWFyZ3lyZ3duZnlkam5zem1hIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTkwMzI3MjQsImV4cCI6MjAxNDYwODcyNH0.3gVvHMZnR1NxtQ1V9_t69qqZKQ408aC84CjWqygNF4I';
//   final client = SupabaseStorageClient(
//     '$supabaseUrl/storage/v1',
//     {
//       'Authorization': 'Bearer $supabaseKey',
//     },
//   );


//   List _items = [];
//   // Fetch content from the json file
//   Future<void> readJson() async {
//       try{
//         print('1');
//         final file = File('C:/Users/user/Downloads/Balu_exper/supplink/lib/example.txt');
//         final listBytes = file.readAsBytes();
//         // final Uint8List fileData = Uint8List.f(listBytes);
//         final uploadBinaryResponse = await client.from('myBucket').upload(
//               'binaryExample.txt',
//               file,
//               fileOptions: const FileOptions(upsert: true),
//             );
//         print('upload binary response : $uploadBinaryResponse');
//       }catch(e){
//         print('error in upload');
//         print(e);
//       }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: const Text(
//           'dbestech',
//         ),
//       ),
//       body:Column(
//         children: [
//           _items.isNotEmpty?Expanded(
//             child: ListView.builder(
//               itemCount: _items.length,
//               itemBuilder: (context, index) {
//                 return Card(
//                   key: ValueKey(_items[index]["id"]),
//                   margin: const EdgeInsets.all(10),
//                   color: Colors.amber.shade100,
//                   child: ListTile(
//                     leading: Text(_items[index]["id"]),
//                     title: Text(_items[index]["name"]),
//                     subtitle: Text(_items[index]["description"]),
//                   ),
//                 );
//               },
//             ),
//           ): ElevatedButton(
//               onPressed: () {
//                 readJson();
//               },
//               child: Center(child: Text("Load Json")))
//         ],
//       ),
//     );
//   }
// }
