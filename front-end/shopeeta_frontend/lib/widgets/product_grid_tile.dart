import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/my_tuples.dart';
import '../helpers/http_requests.dart';

class ProductGridTile extends StatefulWidget {
  const ProductGridTile({
    super.key,
    required this.product,
  });
  final Product product;

  @override
  State<ProductGridTile> createState() => _ProductGridTileState();
}

class _ProductGridTileState extends State<ProductGridTile> {
  String _imageUrl = "";
  bool _isLoading = true;

  @override
  void didUpdateWidget(ProductGridTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    _isLoading = true;
    _imageUrl = "";
    _getImageUrl();
  }

  void _getImageUrl() async {
    Trio<String, bool, String> response =
        await ShopHttpRequestHelper.getProductImage(widget.product.id);
    if (response.success) {
      setState(() {
        _imageUrl = response.content;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      _getImageUrl();
    }
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
            if (_isLoading)
              CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            if (!_isLoading && !_imageUrl.isNotEmpty)
              Icon(
                Icons.shopping_cart,
                color: Theme.of(context).colorScheme.primary,
              ),
            if (!_isLoading && _imageUrl.isNotEmpty)
              SizedBox(
                height: 170,
                child: Image.network(
                  _imageUrl,
                  fit: BoxFit.contain,
                ),
              ),
            Text(
              widget.product.name,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            Text(
              '\$${widget.product.price}',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            Text(
              "Vendedor: ${widget.product.seller}",
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ],
        ),
      ),
    );
  }
}
