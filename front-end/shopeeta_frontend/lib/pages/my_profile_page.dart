import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './wait_for_connection_page.dart';
import './register_product_page.dart';
import '../models/product.dart';
import '../widgets/my_alert_dialog.dart';
import '../widgets/my_product_grid_tile.dart';
import '../helpers/http_requests.dart';
import '../widgets/home_search_bar.dart';

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
  var _loadedProducts = false;
  List<Product> _products = [];

  void _verifyIfIsLogedIn() async {
    var response =
        await UserHttpRequestHelper.verifyIfIsLogedIn(userName, password);
    if (response) {
      setState(() {
        _logedIn = true;
      });
    }
  }

  void _getMyProducts() async {
    var response =
        await ShopHttpRequestHelper.getMyProducts(userName, password);

    if (response.success) {
      setState(() {
        _products = response.content;
        _loadedProducts = true;
      });
    }
  }

  void _changeProductsPage(response) async {
    setState(() {
      _products = response.content;
    });
  }

  void _deleteProduct(Product product) async {
    var wasDeleted =
        await ShopHttpRequestHelper.deleteProduct(product, userName, password);
    if (wasDeleted) {
      _getMyProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
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
          HomeSearchBar(
            context: context,
            products: _products,
            sideBarWidth: _sideBarWidth,
            searchBarHeight: _searchBarHeight,
            changeProductsParent: _changeProductsPage,
            isMyPage: true,
            userName: userName,
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
