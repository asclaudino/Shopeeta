import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductDetailWidget extends StatelessWidget {
  const ProductDetailWidget({
    Key? key,
    required this.productWidth,
    required this.imageUrl,
    required this.product,
  }) : super(key: key);

  final double productWidth;
  final String imageUrl;
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        bottom: 120,
        left: 30,
        top: 30,
        right: 30,
      ),
      width: productWidth,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            blurRadius: 3,
            spreadRadius: 3,
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 0.45 * productWidth,
            child: Hero(
              tag: product.id,
              child: imageUrl.isEmpty
                  ? Icon(
                      Icons.shopping_cart,
                      size: 200,
                      color: Colors.black.withOpacity(0.2),
                    )
                  : InteractiveViewer(
                      panEnabled: true,
                      minScale: 0.5,
                      maxScale: 3.0,
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.contain,
                      ),
                    ),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: Theme.of(context).textTheme.headline2,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  product.description,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
