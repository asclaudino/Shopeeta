import 'package:flutter/material.dart';
import '../models/product.dart';
import '../helpers/http_requests.dart';
import '../models/my_tuples.dart';

class MyProductGridTile extends StatefulWidget {
  const MyProductGridTile({
    super.key,
    required this.product,
    required this.deleteProduct,
  });
  final Product product;
  final Function deleteProduct;

  @override
  State<MyProductGridTile> createState() => _MyProductGridTileState();
}

class _MyProductGridTileState extends State<MyProductGridTile> {
  String _imageUrl = "";
  bool _isLoading = true;

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
      height: 350,
      padding: const EdgeInsets.all(20),
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
      margin: const EdgeInsets.all(10),
      child: GridTile(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (_isLoading)
              Container(
                height: 170,
                alignment: Alignment.center,
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            if (!_isLoading && !_imageUrl.isNotEmpty)
              Container(
                height: 170,
                alignment: Alignment.center,
                child: Icon(
                  Icons.shopping_cart,
                  size: 100,
                  color: Colors.black.withOpacity(0.2),
                ),
              ),
            if (!_isLoading && _imageUrl.isNotEmpty)
              SizedBox(
                height: 170,
                width: double.infinity,
                child: Image.network(
                  _imageUrl,
                  fit: BoxFit.contain,
                ),
              ),
            const SizedBox(
              height: 10,
            ),
            Text(
              widget.product.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              '\$${widget.product.price}',
              style: Theme.of(context).textTheme.headline2,
            ),
            Expanded(
              child: Container(),
            ),
            Center(
              child: IconButton(
                onPressed: () => widget.deleteProduct(),
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).colorScheme.error.withOpacity(0.6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
