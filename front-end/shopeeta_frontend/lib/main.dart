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
        primaryColor: const Color.fromARGB(255, 194, 19, 101),
      ),
      routes: _routes,
    );
  }
}
