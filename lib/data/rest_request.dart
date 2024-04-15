import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:panduza_sandbox_flutter/data/company.dart';

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

// login 
Future<http.Response> login(String username, String password) async {
  String url = '${baseUrl}token/';

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
  String url = '${baseUrl}company_info/';

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

  String url = '${baseUrl}company_info/';

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

