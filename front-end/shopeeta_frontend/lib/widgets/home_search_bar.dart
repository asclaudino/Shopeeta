import 'package:flutter/material.dart';

import '../models/pop_up_menu_button_enums.dart';
import '../models/product.dart';
import '../pages/home_page.dart';
import '../helpers/http_requests.dart';
import '../pages/my_profile_page.dart';

class HomeSearchBar extends StatelessWidget {
  HomeSearchBar({
    Key? key,
    required this.sideBarWidth,
    required this.searchBarHeight,
    required this.context,
    required this.products,
    required this.searchProductsParent,
  }) : super(key: key);

  final double sideBarWidth;
  final double searchBarHeight;
  final BuildContext context;
  List<Product> products;
  dynamic searchProductsParent;

  final form = GlobalKey<FormState>();
  String _toBeSearched = "";

  void _popUpMenuButtonAction(ProfileMenuOptions option) {
    switch (option) {
      case ProfileMenuOptions.myProfile:
        Navigator.pushReplacementNamed(context, MyProfilePage.pageRouteName);
        break;
      default:
        break;
    }
  }

  void _searchProducts(GlobalKey<FormState> form) async {
    var response = await ShopHttpRequestHelper.searchProducts(_toBeSearched);
    if (response.success) {
      searchProductsParent(response);
      form.currentState?.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      height: searchBarHeight,
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
            width: sideBarWidth,
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
            offset: Offset(0, searchBarHeight / 2),
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
    );
  }
}
