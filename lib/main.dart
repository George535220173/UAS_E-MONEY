import 'package:flutter/material.dart';
import 'package:uas_emoney/registerlogin/login.dart';
import 'Home/home.dart';

void main(){
  runApp(const myApp());
}

class myApp extends StatelessWidget {
  const myApp({Key? key}) : super(key: key);

  @override
  Widget build (BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}