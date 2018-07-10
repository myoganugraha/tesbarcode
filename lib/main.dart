import 'package:flutter/material.dart';
import 'package:tesbarcode/ui/Login.dart';
import 'package:tesbarcode/ui/MainPage.dart';
import 'package:tesbarcode/ui/DeviceInfo.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  final routes = <String, WidgetBuilder>{
    LoginPage.tag: (context) => LoginPage(),
    MainPage.tag: (context) => MainPage(),
    DeviceInfo.tag: (context) => DeviceInfo(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tjakep',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        fontFamily: 'Nunito',
      ),
      home: LoginPage(),
      routes: routes,
    );
  }

}
