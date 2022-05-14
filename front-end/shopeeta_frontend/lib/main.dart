import 'package:flutter/material.dart';

import 'pages/welcome_page.dart';
import 'pages/login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _routes = <String, WidgetBuilder>{
    '/': (BuildContext context) => const WelcomePage(title: 'Shopeeta'),
    '/login': (BuildContext context) => const LoginPage(),
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
