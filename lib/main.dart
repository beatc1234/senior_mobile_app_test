import 'package:flutter/material.dart';
import 'package:myapp/utils/palletes.dart';
import 'package:myapp/views/authentication/login_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Palette.white,
        useMaterial3: true,
        fontFamily: 'Inter',
        textTheme: TextTheme(
          titleMedium: TextStyle(
            color: Palette.blue,
            fontWeight: FontWeight.w500,
          ),
          bodyMedium: const TextStyle(
            color: Color(0xFF7f7f7f),
          ),
          labelMedium: TextStyle(
            color: Palette.black,
          ),
        ),
      ),
      home: const LoginView(),
    );
  }
}
