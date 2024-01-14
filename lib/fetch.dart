import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<Map<String, dynamic>>?> fetchData(String apiUrl) async {
  try {
    final response = await http.post(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body) as List;
      return responseData.cast<Map<String, dynamic>>();
    } else {
      return null;
    }
  } catch (e) {
    print('Error during API request: $e');
    return null;
  }
}

Future<List<Map<String, dynamic>>?> fetchDataReq(String apiUrl, Map<String, dynamic> requestBody) async {
  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body) as List;
      return responseData.cast<Map<String, dynamic>>();
    } else {
      return null;
    }
  } catch (e) {
    print('Error during API request: $e');
    return null;
  }
}

Future<List<Map<String, dynamic>>?> insertData(
    String apiUrl, Map<String, dynamic> postData) async {
  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      body: jsonEncode(postData), // Convert the Map to JSON
      headers: {
        'Content-Type': 'application/json', // Set the content type to JSON
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body) as List;
      return responseData.cast<Map<String, dynamic>>();
    } else {
      return null;
    }
  } catch (e) {
    print('Error during API request: $e');
    return null;
  }
}
