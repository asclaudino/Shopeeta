import 'package:flutter/material.dart';

import '../models/pop_up_menu_button_enums.dart';
import '../pages/home_page.dart';
import '../pages/my_profile_page.dart';

class HomeTopBar extends StatelessWidget {
  const HomeTopBar({
    Key? key,
    required this.sideBarWidth,
    required this.searchBarHeight,
    required this.context,
  }) : super(key: key);

  final BuildContext context;
  final double sideBarWidth;
  final double searchBarHeight;

  void _popUpMenuButtonAction(ProfileMenuOptions option) {
    switch (option) {
      case ProfileMenuOptions.myProfile:
        Navigator.pushReplacementNamed(context, MyProfilePage.pageRouteName);
        break;
      default:
        break;
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
          Expanded(child: Container()),
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
