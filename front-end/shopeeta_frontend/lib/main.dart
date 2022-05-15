import 'package:flutter/material.dart';
import 'package:shopeeta_frontend/pages/home_page.dart';

import 'pages/welcome_page.dart';
import 'pages/login_page.dart';
import 'pages/signin_page.dart';
import 'pages/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _routes = <String, WidgetBuilder>{
    '/': (BuildContext context) => const WelcomePage(title: 'Shopeeta'),
    LoginPage.pageRouteName: (BuildContext context) => const LoginPage(),
    SigninPage.pageRouteName: (BuildContext context) => const SigninPage(),
    HomePage.pageRouteName: (BuildContext context) => const HomePage(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color.fromARGB(255, 0, 224, 224),
          onPrimary: Color.fromARGB(255, 172, 0, 172),
          secondary: Color.fromARGB(255, 172, 0, 172),
          onSecondary: Colors.white,
          error: Colors.black,
          onError: Colors.red,
          background: Colors.purple,
          onBackground: Colors.white,
          surface: Colors.white54,
          onSurface: Colors.black,
        ),
        textTheme: const TextTheme(
          headline1: TextStyle(
            fontSize: 72.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: "OleoScriptSwashCaps",
          ),
          button: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.normal,
            color: Colors.black,
            fontFamily: "PlayFairDisplay",
          ),
        ),
      ),
      routes: _routes,
    );
  }
}
