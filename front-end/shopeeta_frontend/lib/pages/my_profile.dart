import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import './login_page.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});
  static const pageRouteName = "/my_profile";

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  bool logedIn = false;
  String userName = "";
  String password = "";
  final _searchBarHeight = 50.0;
  String _toBeSearched = "";

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

  void _searchProducts() async {
    var response = await http.post(
        Uri.parse('http://localhost:8000/productbase/search/'),
        body: '{"search": "$_toBeSearched"}');
    if (json.decode(response.body)["status"] == "success") {}
  }

  @override
  Widget build(BuildContext context) {
    var prefs = SharedPreferences.getInstance();
    prefs.then((prefs) {
      userName = prefs.getString('userName')!;
      password = prefs.getString('password')!;
      _verifyIfIsLogedIn();
    });

    if (logedIn) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              height: _searchBarHeight,
              color: Theme.of(context).colorScheme.primary,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Olá, $userName!, aqui fica a barra de pesquisa',
                    style: const TextStyle(fontSize: 30),
                  ),
                  SizedBox(
                    width: 200,
                    child: Form(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Pesquisar',
                        ),
                        onChanged: (value) {
                          _toBeSearched = value;
                        },
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      _searchProducts();
                    },
                  ),
                ],
              ),
            ),
            Row(
              children: [
                SizedBox(
                  width: 150,
                  height: MediaQuery.of(context).size.height - _searchBarHeight,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text('Filtros'),
                      Text('Você está logado!'),
                    ],
                  ),
                ),
                const VerticalDivider(
                  indent: 10,
                  endIndent: 10,
                  width: 10,
                  thickness: 0,
                  color: Colors.black54,
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text('Resultados'),
                      Text('Você está logado!'),
                    ],
                  ),
                ),
              ],
            ),
          ],
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
