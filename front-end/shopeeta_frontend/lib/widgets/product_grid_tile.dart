import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductGridTile extends StatelessWidget {
  const ProductGridTile({
    super.key,
    required this.product,
  });
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 270,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        boxShadow: [
          BoxShadow(
            blurRadius: 3,
            spreadRadius: 3,
            color: Colors.black.withOpacity(0.3),
            offset: const Offset(0, 0),
          ),
        ],
      ),
      margin: const EdgeInsets.all(10),
      child: GridTile(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text(
              product.name,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            Text(
              '\$${product.price}',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            Text(
              "Vendedor: ${product.seller}",
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ],
        ),
      ),
    );
  }
}
