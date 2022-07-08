import 'package:flutter/material.dart';
import '../widgets/comment_section.dart';
import '../models/product.dart';
import '../widgets/home_top_bar.dart';
import '../widgets/product_detail_widget.dart';
import '../widgets/product_pricing_widget.dart';

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
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 30.0,
            ),
            height: MediaQuery.of(context).size.height - _searchBarHeight - 20,
            child: IntrinsicHeight(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(),
                        ),
                        ProductDetailWidget(
                          productWidth: _productWidth,
                          product: widget.product,
                          imageUrl: widget.imageUrl,
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        ProductPricingWidget(
                          rightSideBarWidth: _rightSideBarWidth,
                          product: widget.product,
                        ),
                        Expanded(
                          child: Container(),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 50.0,
                      ),
                      child: CommentSection(
                        width: _productWidth + _rightSideBarWidth + 12,
                        product: widget.product,
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
