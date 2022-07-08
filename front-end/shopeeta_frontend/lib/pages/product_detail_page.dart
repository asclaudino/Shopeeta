import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/home_top_bar.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({
    super.key,
    required this.product,
    required this.imageUrl,
  });
  static const pageRouteName = "/product_detail";

  final Product product;
  final String imageUrl;

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final _searchBarHeight = 50.0;
  final _sideBarWidth = 200.0;
  final _rightSideBarWidth = 360.0;
  final _productWidth = 888.0;

  // String _toBeSearched = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          HomeTopBar(
            sideBarWidth: _sideBarWidth,
            searchBarHeight: _searchBarHeight,
            context: context,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 50.0,
              ),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                        bottom: 120,
                        left: 30,
                        top: 30,
                        right: 30,
                      ),
                      width: _productWidth,
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
                            width: 0.45 * _productWidth,
                            child: Hero(
                              tag: widget.product.id,
                              child: widget.imageUrl.isEmpty
                                  ? Icon(
                                      Icons.shopping_cart,
                                      size: 150,
                                      color: Colors.black.withOpacity(0.2),
                                    )
                                  : InteractiveViewer(
                                      panEnabled: true,
                                      minScale: 0.5,
                                      maxScale: 3.0,
                                      child: Image.network(
                                        widget.imageUrl,
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
                                  widget.product.name,
                                  style: Theme.of(context).textTheme.headline2,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  widget.product.description,
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Container(
                      padding: const EdgeInsets.all(30),
                      width: _rightSideBarWidth,
                      //height: double.infinity,
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
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "R\$ ${widget.product.price.toStringAsFixed(2)}",
                            style:
                                Theme.of(context).textTheme.headline2!.copyWith(
                                      fontSize: 30,
                                      color: Colors.black,
                                    ),
                          ),
                          const SizedBox(height: 20),
                          Text.rich(
                            TextSpan(
                              text: 'Este produto é vendido e entregue por ',
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: widget.product.seller,
                                  style: const TextStyle(
                                    //decoration: TextDecoration.italic,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                const TextSpan(
                                  text:
                                      '. A Shopeeta não garante a sua compra, nem o pedido nem a entrega.',
                                ),
                                // can add more TextSpans here...
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
