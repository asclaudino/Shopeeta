import 'package:flutter/material.dart';

class HomeSideBar extends StatelessWidget {
  const HomeSideBar({
    Key? key,
    required double sideBarWidth,
    required double searchBarHeight,
  })  : _sideBarWidth = sideBarWidth,
        _searchBarHeight = searchBarHeight,
        super(key: key);

  final double _sideBarWidth;
  final double _searchBarHeight;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _sideBarWidth,
      height: MediaQuery.of(context).size.height - _searchBarHeight,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text('Filtros'),
          Text('Você está logado!'),
        ],
      ),
    );
  }
}
