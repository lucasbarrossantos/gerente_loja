import 'package:flutter/material.dart';
import 'package:gerenteloja/screens/login_screen.dart';

void main() => runApp(Main());

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.pinkAccent,
      ),
      home: LoginScreen(),
    );
  }
}
