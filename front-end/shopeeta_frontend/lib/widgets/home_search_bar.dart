import 'package:flutter/material.dart';
import 'package:shopeeta_frontend/models/filter.dart';

import '../models/pop_up_menu_button_enums.dart';
import '../models/product.dart';
import '../models/my_tuples.dart';
import '../pages/home_page.dart';
import '../helpers/http_requests.dart';
import '../pages/my_profile_page.dart';

class HomeSearchBar extends StatefulWidget {
  const HomeSearchBar({
    Key? key,
    required this.sideBarWidth,
    required this.searchBarHeight,
    required this.context,
    required this.products,
    required this.changeProductsParent,
    required this.isMyPage,
    required this.userName,
    required this.filters,
  }) : super(key: key);

  final double sideBarWidth;
  final double searchBarHeight;
  final BuildContext context;
  final List<Product> products;
  final List<Filter> filters;
  final Function changeProductsParent;
  final bool isMyPage;
  final String userName;

  @override
  State<HomeSearchBar> createState() => _HomeSearchBarState();
}

class _HomeSearchBarState extends State<HomeSearchBar> {
  final form = GlobalKey<FormState>();

  String _toBeSearched = "";

  void _popUpMenuButtonAction(ProfileMenuOptions option) {
    switch (option) {
      case ProfileMenuOptions.myProfile:
        Navigator.pushReplacementNamed(
            widget.context, MyProfilePage.pageRouteName);
        break;
      case ProfileMenuOptions.logout:
        Navigator.popUntil(
          context,
          ModalRoute.withName('/'),
        );
        break;
      default:
        break;
    }
  }

  void _searchProducts(GlobalKey<FormState> form) async {
    Pair<List<Product>, bool> response;
    if (widget.isMyPage) {
      response = await ShopHttpRequestHelper.searchMyProducts(
          widget.userName, _toBeSearched);
    } else {
      response = await ShopHttpRequestHelper.searchProducts(
          _toBeSearched, widget.filters);
    }
    if (response.success) {
      widget.changeProductsParent(response);
      //form.currentState?.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      height: widget.searchBarHeight,
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
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: widget.sideBarWidth,
            child: IconButton(
              icon: Image.asset('../assets/images/Logo_shopeeta_header.png'),
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.pushReplacementNamed(context, HomePage.pageRouteName);
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
            padding: EdgeInsets.zero,
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
            padding: EdgeInsets.zero,
            color: Theme.of(context).colorScheme.onPrimary,
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
          ),
          PopupMenuButton<ProfileMenuOptions>(
            position: PopupMenuPosition.under,
            padding: EdgeInsets.zero,
            offset: Offset(0, widget.searchBarHeight / 2),
            tooltip: "Op????es de usu??rio",
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
    );
  }
}
