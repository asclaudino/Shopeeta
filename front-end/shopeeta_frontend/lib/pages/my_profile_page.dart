import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import './wait_for_connection_page.dart';
import './home_page.dart';
import './register_product_page.dart';
import '../models/product.dart';
import '../widgets/my_product_grid_tile.dart';
import '../widgets/my_alert_dialog.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});
  static const pageRouteName = "/my_profile";

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
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

  void _getMyProducts() async {
    var response = await http.post(
      Uri.parse('http://localhost:8000/shop/get_sellers_products/'),
      body: '{"seller": "$userName"}',
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

  void _searchProducts(GlobalKey<FormState> form) async {
    var response = await http.post(
        Uri.parse('http://localhost:8000/shop/search_products/'),
        body: '{"name": "$_toBeSearched"}');
    if (json.decode(response.body)["status"] == "success") {
      setState(() {
        _products = (json.decode(response.body)["products"] as List)
            .map((i) => Product.fromJson(i))
            .toList();
        form.currentState?.reset();
      });
    }
  }

  void _deleteProduct(Product product) async {
    var response = await http.post(
        Uri.parse('http://localhost:8000/shop/delete_product/'),
        body:
            '{"product_id": "${product.id}", "username": "$userName", "password": "$password"}');
    if (json.decode(response.body)["status"] == "success") {
      _getMyProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    final form = GlobalKey<FormState>();

    var prefs = SharedPreferences.getInstance();
    prefs.then((prefs) {
      userName = prefs.getString('userName')!;
      password = prefs.getString('password')!;
      if (!_logedIn) _verifyIfIsLogedIn();
    });
    if (!_logedIn) return const WaitForConnectionPage();
    if (!_loadedProducts) _getMyProducts();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            height: _searchBarHeight,
            color: Theme.of(context).colorScheme.primary,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: _sideBarWidth,
                  child: TextButton(
                    child: Text(
                      'Shopeeta',
                      style: Theme.of(context).textTheme.headline1!.copyWith(
                            fontSize: 26,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, HomePage.pageRouteName);
                    },
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Form(
                    key: form,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Pesquisar',
                      ),
                      onChanged: (value) {
                        _toBeSearched = value;
                      },
                      onFieldSubmitted: (value) {
                        _searchProducts(form);
                      },
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    _searchProducts(form);
                  },
                ),
                Expanded(child: Container()),
                IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () {
                    Navigator.pushNamed(context, '/cart');
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.account_circle_rounded),
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                        context, MyProfilePage.pageRouteName);
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
                  height: MediaQuery.of(context).size.height - _searchBarHeight,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Filtros'),
                      const Text('Você está logado!'),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                              context, RegisterProductPage.pageRouteName);
                        },
                        child: const Text("Adicionar Produto"),
                      ),
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
                  width: MediaQuery.of(context).size.width - _sideBarWidth - 10,
                  height: MediaQuery.of(context).size.height - _searchBarHeight,
                  child: SingleChildScrollView(
                    child: Wrap(
                      children: _products.map((product) {
                        return MyProductGridTile(
                          product: product,
                          deleteProduct: () {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) => MyAlertDialog(
                                text:
                                    "Tem certeza de que quer deletar seu produto? Esta ação não pode ser desfeita.",
                                title: "Deletar produto?",
                                onConfirmText: "Deletar",
                                onConfirm: () {
                                  _deleteProduct(product);
                                  Navigator.pop(context);
                                },
                              ),
                            );
                          },
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
  }
}