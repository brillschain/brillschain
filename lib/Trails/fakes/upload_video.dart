

// import 'dart:convert';

// import 'package:dotted_border/dotted_border.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:supplink/Backend/supaBaseDB/superbaseCredentials.dart';
// import 'package:supplink/Backend/supaBaseDB/superbaseServices/Strorages/connectionsUrlManager.dart';
// import 'package:flick_video_player/flick_video_player.dart';
// import 'package:video_player/video_player.dart';
// class NewPostsConnections extends StatefulWidget {
//   const NewPostsConnections({super.key});
//   @override
//   State<NewPostsConnections> createState() => _NewPostsConnectionsState();
// }
// class _NewPostsConnectionsState extends State<NewPostsConnections> {
//   String imageUrl ='';  // To display while uploading
//   String videoUri = '';
//   String path = ''; // To set the Image in Supabase
//   TextEditingController inputStatementController = TextEditingController();  // To get the statement about the post


//   Map<String, dynamic> NewPostImageStatamentJson(String path, String statement, String ImagePublicurl, String type){
//     Map<String, dynamic> data = {};
//     data['path'] = path;
//     data['statement'] = statement;
//     data['imagePublicUrl'] = ImagePublicurl;
//     data['type'] = type;
//     return data;
//   }


//   Widget display(BuildContext context){
//     print('image url and video url');
//     print('imageUrl-${imageUrl}-');
//     print('videouri${videoUri}');
//     if(imageUrl!=''){
//       return Image.network(imageUrl, fit: BoxFit.cover,);
//     }
//     if(videoUri!=''){
//       return FlickVideoPlayer(
        
//         flickManager: FlickManager(
        
//         videoPlayerController:
//             VideoPlayerController.networkUrl(
//               Uri.parse(
//                 // 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
//                 videoUri
//                 // videoUri,
//               ),
              
//             ),
//           )
//         );
//     }
//     return DottedBorder(
//                         color: const Color.fromARGB(255, 7, 84, 147),
//                         strokeWidth: 1,
//                         strokeCap: StrokeCap.butt,
//                         child: Container(
//                           child: Center(
//                             child: Text(
//                               'No selected media'
//                             ),
//                           ),
//                         ),
//                       );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: Column(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: <Widget>[
//           Semantics(
//             label: 'image_picker_example_from_gallery',
//             child: FloatingActionButton(
//               onPressed: () async{
//                 final picker = ImagePicker();
//                 final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//                 setState(() {
//                   imageUrl = '';
//                   videoUri = '';
//                 });
//                 if(pickedFile==null){return;}
//                 final imageBytes = await pickedFile.readAsBytes();
//                 try{     
//                   print('starting newPost Uploading');
//                   final User? user = SupabaseCreds.supabaseClient.auth.currentUser;
//                   ConnectionManager urlManager = ConnectionManager(user!.id);
//                   String destinationFolder = urlManager.getTrailsUrl();

//                   final List<FileObject> objects = await SupabaseCreds.supabaseClient
//                     .storage.from('myBucket').list(path: destinationFolder);
                  
//                   int picture_id =  objects.length;
                  
//                   setState(() {
//                     path = "${destinationFolder}/Picture${picture_id}/Picture$picture_id";   
//                   });
                  

//                   await SupabaseCreds.supabaseClient.storage.from('myBucket').uploadBinary(path, imageBytes);
//                   String imageUrli = SupabaseCreds.supabaseClient.storage.from('myBucket').getPublicUrl(path);
//                   setState(() {
//                     imageUrl = imageUrli;
//                   });
//                   print('uploaded Image succesfully');

//                 }catch(e){
//                   print('error in newPostCreds');
//                   print(e);
//                 }
//               },
//               heroTag: 'image0',
//               tooltip: 'Pick Image from gallery',
//               child: const Icon(Icons.photo),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(top: 16.0),
//             child: FloatingActionButton(
//               onPressed: () async{

//                 final picker = ImagePicker();
//                 final pickedFile = await picker.pickVideo(source: ImageSource.gallery);
//                 setState(() {
//                   imageUrl='';
//                   videoUri='';
//                 });
//                 if(pickedFile==null){return;}
//                 final videoBytes = await pickedFile.readAsBytes();
//                 try{
//                   print('uploading video');
//                   final User? user = SupabaseCreds.supabaseClient.auth.currentUser;
//                   ConnectionManager urlManager = ConnectionManager(user!.id);
//                   String destinationFolder = urlManager.getTrailsUrl();

//                   final List<FileObject> objects = await SupabaseCreds.supabaseClient
//                     .storage.from('myBucket').list(path: destinationFolder);
                  
//                   int video_id =  objects.length;
                  
//                   setState(() {
//                     path = "${destinationFolder}/Videos${video_id}/Video${video_id}";   
//                   });
                  
//                   print(1);
//                   await SupabaseCreds.supabaseClient.storage.from('myBucket').uploadBinary(path, videoBytes, fileOptions: FileOptions(contentType: 'video/mp4'));
//                   print(2);
//                   String videoUrl = SupabaseCreds.supabaseClient.storage.from('myBucket').getPublicUrl(path);
//                   print(videoUrl);
//                   print(3);
//                   setState(() {
//                     videoUri = videoUrl;
//                   });
//                   print(4);

//                   print('uploaded succesfully');
//                 }catch(e){
//                   print('error in newPostCreds');
//                   print(e);
//                 }
//               },
//               heroTag: 'multipleMedia',
//               tooltip: 'Pick Video from gallery',
//               child: const Icon(Icons.photo_library),
//             ),
//           ),
//         ]
//       ),
//       body: Column(
//           children: [

//             Padding(
//               padding: const EdgeInsets.only(top: 20),
//               child: Center(
//                 child: Column(
//                   children: [
//                     SizedBox(
//                       width: 300,
//                       height: 300,
//                       child: display(context),
//                     ),
//                     Container(
//                       width: 600,
//                       child: TextField(
//                         controller: inputStatementController,
//                       ),
//                     ),
//                     SizedBox(
//                       height: 20,
//                     ),

//                     ElevatedButton(
//                       onPressed: () async{
//                         final User? user = SupabaseCreds.supabaseClient.auth.currentUser;
//                         ConnectionManager urlManager = ConnectionManager(user!.id);
//                         String destinationFolder = urlManager.getPictureUrl();

//                         final List<FileObject> objects = await SupabaseCreds.supabaseClient
//                           .storage.from('myBucket').list(path: destinationFolder);
                        
//                         int picture_id =  objects.length;
//                         String dest = '${destinationFolder}/Picture${picture_id}';
//                         String finalDest = '${dest}/Picture$picture_id';
//                         await SupabaseCreds.supabaseClient
//                           .storage
//                           .from('myBucket')
//                           .move(path, finalDest);

//                         // uploading Image data using json
//                         try{
//                             String imageUrli = SupabaseCreds.supabaseClient.storage.from('myBucket').getPublicUrl(finalDest);
//                             String type = 'Image';
//                             Map<String, dynamic> data = NewPostImageStatamentJson(dest, inputStatementController.text, imageUrli, type);
//                             String jsonData = jsonEncode(data);
//                             print(jsonData);
//                             final http.Response response = await http.post(
//                               Uri.parse('http://127.0.0.1:5001/api/post_data'),
//                               headers: {
//                                   "Access-Control-Allow-Origin": "*", // Required for CORS support to work
//                                   "Access-Control-Allow-Methods": "POST, OPTIONS",
//                                   'Content-Type': 'application/json; charset=UTF-8',
//                               },
//                               body: jsonData,
//                             );
//                             print(response.statusCode);
//                             print(response.body);
//                             print('done uploading json file and Image');
//                         }catch(e){
//                           print('error in upload button ${e}');
//                         }
//                         print('Everything in upload done fine');
//                       },
//                       child: Text(
//                         'Upload'
//                       )
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//     );
//   }
// }