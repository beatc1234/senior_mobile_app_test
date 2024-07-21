import 'dart:convert';
import 'dart:developer';

import 'package:myapp/models/contact_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserController {
  Future<ContactModel?> loadUser(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final model = prefs.getString(id);
    if (model != null) {
      log(jsonDecode(model).toString());
      return ContactModel.fromJson(jsonDecode(model));
    }
    return null;
  }

  Future<String?> loadSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final model = prefs.getString('id');
    return model;
  }

  Future<bool?> saveUser(ContactModel user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final result = prefs.setString(user.id.toString(), jsonEncode(user));
    return result;
  }

  Future<bool?> saveSession(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final result = prefs.setString('id', id);
    return result;
  }
}
