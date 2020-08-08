import 'package:flutter/material.dart';
import 'package:ibm_hack_try/Home/landingpage.dart';
import 'package:ibm_hack_try/QR/QRPage.dart';
import 'package:ibm_hack_try/Register/register.dart';
import 'package:ibm_hack_try/Utility/utilitypage.dart';
import 'package:ibm_hack_try/login/login.dart';
import 'dart:async';

void main() => runApp(MyApp());

final routes = {
  '/login': (BuildContext context) => LoginPage(),
  '/home': (BuildContext context) => HomePage(),
  '/register': (BuildContext context) => RegisterPage(),
  '/qrpage': (BuildContext context) => QRPage(),
  '/utility': (BuildContext context) => UtilityPage(),
};

class MyApp extends StatelessWidget {
 
 @override
 Widget build(BuildContext context){
   return new MaterialApp(
     title: 'SmarTangle App',
     theme: new ThemeData(primarySwatch: Colors.teal),
     routes: routes,
     home: FirstPage(),
   );
 }
}

class FirstPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    Timer(
        Duration(seconds: 3),
            () =>
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => LoginPage())));
    return Scaffold (
      body: Center(
        child: Image.asset('images/1- Splash Screen.png',fit: BoxFit.fill, height: double.infinity, width:double.infinity)
      ) ,
    );
  }
}