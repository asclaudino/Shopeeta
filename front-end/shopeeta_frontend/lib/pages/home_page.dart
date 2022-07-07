import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './wait_for_connection_page.dart';
import '../models/product.dart';
import '../models/filter.dart';
import '../models/pop_up_menu_button_enums.dart';
import '../widgets/product_grid_tile.dart';
import '../widgets/home_side_bar.dart';
import './my_profile_page.dart';
import '../helpers/http_requests.dart';

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
  final List<Filter> _filters = [
    Filter(name: "Iniciativa", isSelected: false),
    Filter(name: "Comida", isSelected: false),
    Filter(name: "Roupa", isSelected: false),
  ];

  void _popUpMenuButtonAction(ProfileMenuOptions option) {
    switch (option) {
      case ProfileMenuOptions.myProfile:
        Navigator.pushReplacementNamed(context, MyProfilePage.pageRouteName);
        break;
      default:
        break;
    }
  }

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

  void _searchProducts(GlobalKey<FormState> form) async {
    var response = await ShopHttpRequestHelper.searchProducts(_toBeSearched);
    if (response.success) {
      setState(() {
        _products = response.content;
        form.currentState?.reset();
      });
    }
  }

  void _changeFilterState(Filter filter, bool newState) {
    setState(() {
      filter.isSelected = newState;
    });
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
    if (!_loadedProducts) _getLatestProducts();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            height: _searchBarHeight,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 3,
                    spreadRadius: 3,
                    color: Colors.black.withOpacity(0.2),
                    offset: const Offset(0, 0),
                  ),
                ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: _sideBarWidth,
                  child: IconButton(
                    icon: Image.asset(
                        '../assets/images/Logo_shopeeta_header.png'),
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, HomePage.pageRouteName);
                    },
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 2,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onPrimary,
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 0,
                      bottom: 7,
                      left: 10,
                      right: 10,
                    ),
                    child: Form(
                      key: form,
                      child: TextFormField(
                        style: Theme.of(context).textTheme.bodyText1,
                        //textAlignVertical: TextAlignVertical.center,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
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
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  color: Theme.of(context).colorScheme.onPrimary,
                  onPressed: () {
                    _searchProducts(form);
                  },
                ),
                Expanded(
                  child: Container(),
                ),
                IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  color: Theme.of(context).colorScheme.onPrimary,
                  onPressed: () {
                    Navigator.pushNamed(context, '/cart');
                  },
                ),
                PopupMenuButton<ProfileMenuOptions>(
                  position: PopupMenuPosition.under,
                  offset: Offset(0, _searchBarHeight / 2),
                  tooltip: "Opções de usuário",
                  elevation: 10,
                  icon: const Icon(
                    Icons.account_circle_rounded,
                    color: Colors.white,
                  ),
                  onSelected: (ProfileMenuOptions option) {
                    _popUpMenuButtonAction(option);
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: ProfileMenuOptions.myProfile,
                      child: Text('Meu Perfil'),
                    ),
                    const PopupMenuItem(
                      value: ProfileMenuOptions.logout,
                      child: Text('Sair'),
                    ),
                  ],
                ),
              ],
            ),
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
