import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:panduza_sandbox_flutter/data/company.dart';

String baseCloudUrl = "http://192.168.97.180:8000/";

// lucas address : 192.168.97.180

// Change url to swap to cloud api or local


// Create first account 
Future<http.Response> createFirstAccount(String username, String password) async {

  String url = '${baseCloudUrl}first_register/';
 

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

// login 
Future<http.Response> login(String username, String password) async {

  String url = '${baseCloudUrl}first_register/';

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

// get cloud information (broker address/ broker port/ certificat)
Future<http.Response> getBrokerInfo(String token) async {

  String url = '${baseCloudUrl}first_register/';

  var response = await http.get(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    }
  );

  return response;
}

// set cloud info (company name, broker address, broker port, certificat)
Future<http.Response> postBrokerInfo(String token, Company company) async {

  String url = '${baseCloudUrl}first_register/';

  Map body = {
    'company_name' : company.companyName,
    'broker_address' : company.brokerAddress,
    'broker_port' : company.brokerPort,
    'certificat' : company.certificat
  };

  // encode Map to json
  String encodedBody = json.encode(body);

  var response = await http.post(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: encodedBody
  );

  return response;
}

// Add account user or admin 
Future<http.Response> addAccount(String token, 
    String username, String password, bool isAdmin) async {

  String url = '${baseCloudUrl}first_register/';

  Map body = {
    'username' : username,
    'password' : password,
    'is_admin' : isAdmin
  };

  // encode Map to json
  String encodedBody = json.encode(body);

  var response = await http.post(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: encodedBody
  );

  return response;
}

// Get bench 
Future<http.Response> getBench(String token) async {

  String url = '${baseCloudUrl}first_register/';

  var response = await http.get(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    }
  );

  return response;
}


// Post a new bench with name
Future<http.Response> postBench(String token, String name) async {

  String url = '${baseCloudUrl}first_register/';

  Map body = {
    'name' : name
  };

  // encode Map to json
  String encodedBody = json.encode(body);

  var response = await http.post(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: encodedBody
  );

  return response;
}

// Post a new device with name and type
Future<http.Response> postDevice(String token, String name, String type) async {

  String url = '${baseCloudUrl}first_register/';
  
  Map body = {
    'name' : name,
    "type" : type
  };

  // encode Map to json
  String encodedBody = json.encode(body);

  var response = await http.post(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: encodedBody
  );

  return response;
}

// Link a device to a bench 
Future<http.Response> putDeviceInBench(String token, int benchId, int deviceId) async {

  String url = '${baseCloudUrl}first_register/';

  Map body = {
    'id' : benchId,
    'devices': [
      deviceId
    ]
  };

  // encode Map to json
  String encodedBody = json.encode(body);

  var response = await http.put(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: encodedBody
  );

  return response;
}


// Delete a device (it will be delete of the bench)
Future<http.Response> delDevice(String token, int id) async {

  String url = '${baseCloudUrl}first_register/';

  Map body = {
    'id' : id
  };

  // encode Map to json
  String encodedBody = json.encode(body);

  var response = await http.delete(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: encodedBody
  );

  return response;
}

