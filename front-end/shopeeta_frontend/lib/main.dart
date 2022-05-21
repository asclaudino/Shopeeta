import 'package:flutter/material.dart';
import 'package:shopeeta_frontend/pages/home_page.dart';

import 'pages/welcome_page.dart';
import 'pages/login_page.dart';
import 'pages/signin_page.dart';
import 'pages/home_page.dart';
import 'pages/my_profile_page.dart';
import 'pages/register_product_page.dart';
import 'pages/wait_for_connection_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _routes = <String, WidgetBuilder>{
    '/': (BuildContext context) => const WelcomePage(title: 'Shopeeta'),
    WaitForConnectionPage.pageRouteName: (BuildContext context) =>
        const WaitForConnectionPage(),
    LoginPage.pageRouteName: (BuildContext context) => const LoginPage(),
    SigninPage.pageRouteName: (BuildContext context) => const SigninPage(),
    HomePage.pageRouteName: (BuildContext context) => const HomePage(),
    MyProfilePage.pageRouteName: (BuildContext context) =>
        const MyProfilePage(),
    RegisterProductPage.pageRouteName: (BuildContext context) =>
        const RegisterProductPage(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: Colors.purple,
          onPrimary: Colors.white,
          secondary: Colors.blueAccent,
          onSecondary: Colors.blueGrey.shade100,
          error: Colors.black,
          onError: Colors.red,
          background: Colors.white60,
          onBackground: Colors.black,
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
            fontFamily: "PlayfairDisplay",
          ),
          bodyText1: TextStyle(
            fontFamily: "PlayfairDisplay",
            fontSize: 16.0,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
          headline2: TextStyle(
            fontFamily: "PlayfairDisplay",
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      routes: _routes,
    );
  }
}
