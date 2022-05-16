import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import './login_page.dart';
import '../models/product.dart';
import '../widgets/product_grid_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const pageRouteName = "/home";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _logedIn = false;
  String userName = "";
  String password = "";
  final _searchBarHeight = 50.0;
  final _sideBarWidth = 200.0;
  String _toBeSearched = "";
  var _loadedProducts = false;
  List<Product> _products = [];

  void _verifyIfIsLogedIn() async {
    var response = await http.post(
        Uri.parse('http://localhost:8000/userbase/login/'),
        body: '{"username": "$userName", "password": "$password"}');
    if (json.decode(response.body)["status"] == "success") {
      setState(() {
        _logedIn = true;
      });
    }
  }

  void _getLatestProducts() async {
    var response = await http.get(
      Uri.parse('http://localhost:8000/shop/get_latest_products/'),
    );
    if (json.decode(response.body)["status"] == "success") {
      setState(() {
        _products = (json.decode(response.body)["products"] as List)
            .map((i) => Product.fromJson(i))
            .toList();
        _loadedProducts = true;
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
      if (!_logedIn) _verifyIfIsLogedIn();
    });

    if (_logedIn) {
      if (!_loadedProducts) _getLatestProducts();
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
            IntrinsicHeight(
              child: Row(
                children: [
                  SizedBox(
                    width: _sideBarWidth,
                    height:
                        MediaQuery.of(context).size.height - _searchBarHeight,
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
                  Container(
                    padding: const EdgeInsets.all(30),
                    width:
                        MediaQuery.of(context).size.width - _sideBarWidth - 10,
                    height:
                        MediaQuery.of(context).size.height - _searchBarHeight,
                    child: SingleChildScrollView(
                      child: Wrap(
                        children: _products.map((product) {
                          return ProductGridTile(
                            product: product,
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
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
