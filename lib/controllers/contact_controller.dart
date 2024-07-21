import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:myapp/utils/constants.dart';

import '../models/contact_model.dart';

class ContactController {
  Future<List<ContactModel>> loadUsersFromJson() async {
    List<ContactModel> users = [];
    String jsonString = await rootBundle.loadString(Constants.jsonPath);
    List<dynamic> jsonList = json.decode(jsonString);
    for (var jsonUser in jsonList) {
      ContactModel user = ContactModel.fromJson(jsonUser);
      users.add(user);
    }
    return users;
  }

  Future<void> saveUsersToJson(List<ContactModel> users) async {
    if (users.isEmpty) return;
    File(Constants.jsonPath).writeAsStringSync('');
    users.map((user) {
      String jsonString = json.encode(user.toJson());
      File(Constants.jsonPath).writeAsString(jsonString);
    }).toList();
  }
}
