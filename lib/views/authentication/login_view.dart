import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:myapp/controllers/user_controller.dart';
import 'package:myapp/utils/palletes.dart';
import 'package:myapp/views/homepage/home_page_view.dart';

import '../../models/contact_model.dart';

class LoginView extends StatefulWidget {
  final bool isLogOut;
  const LoginView({
    super.key,
    this.isLogOut = false,
  });

  @override
  State<StatefulWidget> createState() {
    return LoginViewState();
  }
}

class LoginViewState extends State<LoginView> {
  final double _horizontalPadding = 30.0;
  List<ContactModel> users = [];
  final UserController _userController = UserController();
  final TextEditingController _textEditingController = TextEditingController();
  ContactModel? user;

  @override
  void initState() {
    if (!widget.isLogOut) {
      loadUser(true);
    }

    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void loadUser(bool isLogOut) async {
    String? id = _textEditingController.text;
    if (isLogOut) {
      id = await _userController.loadSession();
    }
    await _userController.loadUser(id ?? '').then((value) async {
      setState(() {
        user = value;
      });
      if (user?.id.toString().isNotEmpty == true) {
        log('login');
        await _userController
            .saveSession(user?.id.toString() ?? '')
            .then((val) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePageView(id: user?.id.toString() ?? ''),
            ),
          );
        });
      } else {
        login();
      }
    });
  }

  void login() async {
    if (_textEditingController.text.isEmpty) return;
    await _userController
        .saveUser(
      ContactModel(id: _textEditingController.text),
    )
        .then((value) async {
      if (value == true) {
        await _userController
            .saveSession(_textEditingController.text)
            .then((val) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  HomePageView(id: _textEditingController.text),
            ),
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Palette.white,
        elevation: 0.0,
        shadowColor: Palette.lightGray.withOpacity(0.3),
        backgroundColor: Palette.white,
        title: SafeArea(
          child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: _horizontalPadding - 18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Hi There!',
                  style: TextStyle(
                    color: Palette.blue,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Please login to see your contact list',
                  style: TextStyle(
                    color: Palette.gray,
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 20.0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: _horizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'User ID',
                        style: TextStyle(
                          color: Palette.black,
                          fontSize: 14.0,
                        ),
                      ),
                      TextSpan(
                        text: ' *',
                        style: TextStyle(
                          color: Palette.red,
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10.0),
                TextField(
                  controller: _textEditingController,
                  decoration: InputDecoration(
                    hintText: '019237sfxsdasdad',
                    hintStyle: TextStyle(
                      color: Palette.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w100,
                    ),
                    prefixIconColor: Palette.blue,
                    prefixIcon: const Icon(Icons.person_outline),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Palette.blue,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Palette.blue,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Palette.blue,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onTapOutside: (event) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 45.0),
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: _horizontalPadding - 10.0),
            child: SizedBox(
              width: double.infinity,
              height: 60.0,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0.0,
                  shadowColor: Colors.transparent,
                  backgroundColor: const Color(0xFFecf7fd),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                onPressed: () {
                  loadUser(false);
                },
                child: Text(
                  'Login',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 20.0,
                      ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
