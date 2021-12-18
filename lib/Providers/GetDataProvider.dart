import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:maafos/Commons/AppConstants.dart';
import 'package:maafos/Models/AccountModel.dart';
import 'package:maafos/Screens/App/HomeScreen/BottomNav.dart';
import 'package:maafos/Screens/AuthFiles/SignUp.dart';

class GetDataProvider extends ChangeNotifier {
  bool loading = true;
  String currentAddress = 'Current Location';
  String fullAddress = 'Fetching Location..';
  double latitude;
  double longitude;
  Map address = {
    "address": "Current Location",
    "landmark": null,
    "coordinates": [],
    "formattedAddress": "Fetching Location",
    "addressType": null
  };
  FlutterSecureStorage storage = FlutterSecureStorage();
  AccountModel get = AccountModel();
  // Future checkUpdate(
  //   context,
  // ) async {
  //   final Uri url = Uri.https(baseUrl, apiUrl + "/branch/appversion",
  //       {"app": "customer", "platform": Platform.operatingSystem.toString()});
  //   final response = await http.get(url, headers: {
  //     "Content-Type": "application/json",
  //     "Accept": "application/json",
  //   });
  //   var jsonData = jsonDecode(response.body);
  //   return jsonData["data"];
  // }

  Future<AccountModel> getData(context) async {
    AccountModel result;
    loading = true;
    var token = await storage.read(key: "token");
    final Uri url = Uri.https(baseUrl, apiUrl + "/customer/me");
    final response = await http.get(url, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $token"
    });
    var jsonData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      get = AccountModel.fromJson(jsonData);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BottomNavigation(),
        ),
      );
      loading = false;
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => SignUp(),
          ),
          (route) => false);
    }

    return result;
  }

  //post request to add address

  Future addAddressData(Map body, BuildContext context) async {
    var token = await storage.read(key: "token");
    final Uri url = Uri.https(baseUrl, apiUrl + "/customer/address");
    final response = await http.post(url, body: jsonEncode(body), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $token"
    });

    if (response.statusCode == 201) {
      var result = jsonDecode(response.body);
      get.customer.address = result["data"]["address"];
      notifyListeners();
    }
    return response.body;
  }

  //Delete address

  Future deleteAddressData(String id) async {
    var token = await storage.read(key: "token");
    final Uri url = Uri.https(baseUrl, apiUrl + "/customer/address/$id");
    final response = await http.delete(url, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $token"
    });
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      get.customer.address = result["data"]["address"];
      notifyListeners();
    }
    return response;
  }

  void setCustomerLocation(val) {
    currentAddress = val["address"];
    latitude = val["latitude"];
    longitude = val["longitude"];
    fullAddress = val["fullAddress"];
    address = {
      "address": val["address"],
      "landmark": val["landmark"] ?? null,
      "coordinates": [val["latitude"], val["longitude"]],
      "formattedAddress": val["fullAddress"],
      "addressType": val["addressType"] ?? null
    };
    notifyListeners();
  }
}
