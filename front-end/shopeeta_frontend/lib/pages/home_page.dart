import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './wait_for_connection_page.dart';
import '../models/product.dart';
import '../models/filter.dart';
import '../widgets/product_grid_tile.dart';
import '../widgets/home_side_bar.dart';
import '../helpers/http_requests.dart';
import '../widgets/home_search_bar.dart';

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
  var _loadedProducts = false;
  List<Product> _products = [];
  final List<Filter> _filters = [
    Filter(name: "Iniciativa", isSelected: false),
    Filter(name: "Comida", isSelected: false),
    Filter(name: "Roupa", isSelected: false),
  ];

  void _verifyIfIsLogedIn() async {
    var connected =
        await UserHttpRequestHelper.verifyIfIsLogedIn(userName, password);
    if (connected) {
      setState(() {
        _logedIn = true;
      });
    }
  }

  void _getLatestProducts() async {
    var response = await ShopHttpRequestHelper.getLatestProducts();
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

  void _changeFilterState(Filter filter, bool newState) {
    setState(() {
      filter.isSelected = newState;
    });
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
    if (!_loadedProducts) _getLatestProducts();
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
            isMyPage: false,
            userName: userName,
          ),
          IntrinsicHeight(
            child: Row(
              children: [
                HomeSideBar(
                  sideBarWidth: _sideBarWidth,
                  searchBarHeight: _searchBarHeight,
                  filters: _filters,
                  changeFilterState: _changeFilterState,
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
  }
}
