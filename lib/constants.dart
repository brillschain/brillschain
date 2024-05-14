// import 'dart:io';
// import 'dart:convert';
// import 'package:path_provider/path_provider.dart';
// // import 'package:file_saver/file_saver.dart';

// class JsonHandles{
//   void jsonWrite(Map<String, dynamic> data) async{
//     // Create a JSON object
//     // final data = "{
//     //   'name': 'John Doe',
//     //   'age': 30,
//     //   'occupation': 'Software Engineer',
//     // }";

//     // Encode the JSON object to a string
//     print(data);
//     print(data.runtimeType);
//     print('the above one i json');
//     final jsonString = json.encode(data);

//     try{
//     print('jb');
//     // final Directory directory = await getApplicationDocumentsDirectory();
//     // print(directory.path);
//     // final path = directory.path;


//     // Write the JSON string to a file
//     final file = File('C:/Users/user/Downloads/Balu_exper/supplink/lib/.json');
//     // const fileName = 'userDetails.json';

//       // const blob = new Blob([jsonString], {type: 'application/json'});
//       // FileSaver.saveAs(blob, fileName);
//       print(jsonString);
//       file.writeAsString(jsonString);
//       print('allRight');

//       }catch(e){
//       print('error in write as string async');
//       print(e);
//     }
//   }
// }
