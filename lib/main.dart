import 'package:flutter/material.dart';
import 'package:flutterapp/pages/login.page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter App',
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: Colors.black,
          secondary: Colors.yellow,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 33, 34, 39),
        ),
      ),
      home: const LoginPage(title: 'Login'),
    );
  }
}
