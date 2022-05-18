import 'package:flutter/material.dart';
import '../models/filter.dart';

class HomeSideBar extends StatelessWidget {
  const HomeSideBar({
    Key? key,
    required this.sideBarWidth,
    required this.searchBarHeight,
    required this.filters,
    required this.changeFilterState,
  }) : super(key: key);

  final double sideBarWidth;
  final double searchBarHeight;
  final List<Filter> filters;
  final Function changeFilterState;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: sideBarWidth,
      height: MediaQuery.of(context).size.height - searchBarHeight,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 20.0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filtrar por:',
              style: Theme.of(context).textTheme.headline2,
            ),
            const SizedBox(height: 10),
            for (final filter in filters)
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Checkbox(
                    value: filter.isSelected,
                    onChanged: (value) {
                      changeFilterState(filter, value);
                    },
                    activeColor: Theme.of(context).colorScheme.primary,
                  ),
                  Text(
                    filter.name,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
            const SizedBox(height: 20),
            Text(
              'Colocar outras opções aqui',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ],
        ),
      ),
    );
  }
}
