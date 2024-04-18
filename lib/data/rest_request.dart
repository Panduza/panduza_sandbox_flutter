import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:panduza_sandbox_flutter/data/company.dart';

String baseLocalUrl = "http://192.168.56.105:8000/";
String baseCloudUrl = "http://192.168.97.180:8000/";

// lucas address : 192.168.97.180

// Change url to swap to cloud api or local


// Create first account 
Future<http.Response> createFirstAccount(String username, String password, [ bool isCloud = false ]) async {

  String url = "";

  if (isCloud) {
    url = '${baseCloudUrl}first_register/';
  } else {
    url = '${baseLocalUrl}first_register/';
  }
 

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
  
  String url = '${baseLocalUrl}first_account_exist/';

  var response = await http.get(
    Uri.parse(url),
    headers: {"Content-Type": "application/json"}
  );

  return response;
}

// login 
Future<http.Response> login(String username, String password, [ bool isCloud = false ]) async {

  String url = "";

  if (isCloud) {
    url = '${baseCloudUrl}token/';
  } else {
    url = '${baseLocalUrl}token/';
  }

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
Future<http.Response> getBrokerInfo(String token, [ bool isCloud = false ]) async {

  String url = "";

  if (isCloud) {
    url = '${baseCloudUrl}company_info/';
  } else {
    url = '${baseLocalUrl}company_info/';
  }

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
Future<http.Response> postBrokerInfo(String token, Company company, [ bool isCloud = false ]) async {

  String url = "";

  if (isCloud) {
    url = '${baseCloudUrl}company_info/';
  } else {
    url = '${baseLocalUrl}company_info/';
  }

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
    String username, String password, bool isAdmin, [ bool isCloud = false ]) async {

  String url = "";

  if (isCloud) {
    url = '${baseCloudUrl}register/';
  } else {
    url = '${baseLocalUrl}register/';
  }

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
Future<http.Response> getBench(String token, [ bool isCloud = false ]) async {

  String url = "";

  if (isCloud) {
    url = '${baseCloudUrl}bench/';
  } else {
    url = '${baseLocalUrl}bench/';
  }

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
Future<http.Response> postBench(String token, String name, [ bool isCloud = false ]) async {

  String url = "";

  if (isCloud) {
    url = '${baseCloudUrl}bench/';
  } else {
    url = '${baseLocalUrl}bench/';
  }

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
Future<http.Response> postDevice(String token, String name, String type, [ bool isCloud = false ]) async {

  String url = "";

  if (isCloud) {
    url = '${baseCloudUrl}device/';
  } else {
    url = '${baseLocalUrl}device/';
  }
  
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
Future<http.Response> putDeviceInBench(String token, int benchId, int deviceId, [ bool isCloud = false ]) async {

  String url = "";

  if (isCloud) {
    url = '${baseCloudUrl}bench/';
  } else {
    url = '${baseLocalUrl}bench/';
  }

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
Future<http.Response> delDevice(String token, int id, [ bool isCloud = false ]) async {

  String url = "";

  if (isCloud) {
    url = '${baseCloudUrl}device/';
  } else {
    url = '${baseLocalUrl}device/';
  }

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

