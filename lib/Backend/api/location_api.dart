import 'dart:convert';

import 'package:http/http.dart' as http;

class FetchLocation {
  Future<List> getCordinates(int locPin) async {
    Map<String, dynamic> jsonData = {'pin': locPin};

    String jsonData_ = jsonEncode(jsonData);

    final http.Response response = await http.post(
      Uri.parse('http://127.0.0.1:5001/api/post_pin'),
      headers: {
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Methods": "POST, OPTIONS",
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonData_,
    );
    Map<String, dynamic> coordinates = json.decode(response.body);
    print(coordinates);
    //"{'latitude':45.45544, 'longitute':73.45553}"
    List cors = [coordinates['latitude'], coordinates['longitude']];
    return cors;
  }
}
