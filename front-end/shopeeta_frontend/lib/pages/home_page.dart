import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import './login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const pageRouteName = "/home";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool logedIn = false;
  String userName = "";
  String password = "";

  void _verifyIfIsLogedIn() async {
    var response = await http.post(
        Uri.parse('http://localhost:8000/userbase/login/'),
        body: '{"username": "$userName", "password": "$password"}');
    if (json.decode(response.body)["status"] == "success") {
      setState(() {
        logedIn = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    userName = routeArgs['userName']!;
    password = routeArgs['password']!;

    _verifyIfIsLogedIn();

    if (logedIn) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Olá, $userName!'),
        ),
        body: const Center(
          child: Text('Home'),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Olá, visitante!'),
        ),
        body: Center(
          child: TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushReplacementNamed(LoginPage.pageRouteName);
            },
            child: const Text("Fazer login!"),
          ),
        ),
      );
    }
  }
}
