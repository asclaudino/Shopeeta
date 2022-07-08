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
  final _sideBarWidth = 220.0;
  final _tilesMaxWidth = 1100.0;
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
                Expanded(
                  child: Container(),
                ),
                SizedBox(
                  width: _sideBarWidth,
                  height: MediaQuery.of(context).size.height - _searchBarHeight,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: 45,
                      ),
                      ElevatedButton.icon(
                        onPressed: () => Navigator.of(context)
                            .pushNamed(RegisterProductPage.pageRouteName),
                        icon: const Icon(Icons.add, size: 18),
                        label: const SizedBox(
                          width: 120.0,
                          child: Text.rich(
                            TextSpan(
                              text: "adicionar produto",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton.icon(
                        onPressed: () => Navigator.of(context)
                            .pushNamed(RegisterProductPage.pageRouteName),
                        icon: const Icon(
                          Icons.person_add_alt_1,
                          color: Colors.black,
                          size: 18,
                        ),
                        label: const SizedBox(
                          width: 120.0,
                          child: Text.rich(
                            TextSpan(
                              text: "editar perfil",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  constraints: BoxConstraints(
                    maxWidth: _tilesMaxWidth,
                  ),
                  padding: const EdgeInsets.only(top: 3),
                  width: MediaQuery.of(context).size.width - _sideBarWidth - 10,
                  height: MediaQuery.of(context).size.height - _searchBarHeight,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        Wrap(
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
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
