import 'package:flutter/material.dart';
import '../models/product.dart';
import './home_page.dart';

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

  final _rightSideBarWidth = 600.0;

  // String _toBeSearched = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            height: _searchBarHeight,
            color: Theme.of(context).colorScheme.primary,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
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
                Expanded(child: Container()),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 0.4 *
                                (MediaQuery.of(context).size.height -
                                    _searchBarHeight),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                            ),
                            child: Hero(
                              tag: widget.product.id,
                              child: widget.imageUrl.isEmpty
                                  ? Icon(
                                      Icons.image,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    )
                                  : Image.network(
                                      widget.imageUrl,
                                      fit: BoxFit.contain,
                                    ),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Text(
                            widget.product.description,
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ],
                      ),
                    ),
                    const VerticalDivider(
                      width: 10,
                      thickness: 0,
                      color: Colors.black54,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 2,
                        horizontal: 10,
                      ),
                      width: _rightSideBarWidth,
                      height: double.infinity,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            Text(
                              widget.product.name,
                              style: Theme.of(context).textTheme.headline2,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              "R\$ ${widget.product.price}",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline2!
                                  .copyWith(
                                    fontSize: 16,
                                    color: Colors.green,
                                  ),
                            ),
                          ],
                        ),
                      ),
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
