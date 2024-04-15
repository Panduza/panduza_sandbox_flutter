import 'package:http/http.dart' as http;
import 'dart:convert';

String baseUrl = "http://192.168.56.105:8000/";

// Create first account 
Future<http.Response> createFirstAccount(String username, String password) async {
  String url = '${baseUrl}first_register/';

  Map body = {
    'username' : username,
    'password' : password
  };

  // encode Map to json
  String encodedBody = json.encode(body);

  var response = await http.post(
    Uri.parse(url),
    headers: {"Content-Type": "application/json"},
    body: encodedBody
  );

  return response;
}

// Check if first account has been created 
Future<http.Response> firstAccountExist() async {
  String url = '${baseUrl}first_account_exist/';

  var response = await http.get(
    Uri.parse(url),
    headers: {"Content-Type": "application/json"}
  );

  return response;
}