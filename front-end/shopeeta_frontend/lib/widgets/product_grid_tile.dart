import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/product_detail_page_arguments.dart';
import '../models/my_tuples.dart';
import '../helpers/http_requests.dart';
import '../pages/product_detail_page.dart';

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
  Widget? _image;

  @override
  void initState() {
    super.initState();
  }

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
        _image = Image.network(
          _imageUrl,
          fit: BoxFit.contain,
        );
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
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          ProductDetailPage.pageRouteName,
          arguments: ProductDetailPageArguments(
            product: widget.product,
            imageUrl: _imageUrl,
          ),
        );
      },
      child: Container(
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
                CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary,
                ),
              if (!_isLoading)
                Hero(
                  tag: widget.product.id,
                  child: SizedBox(
                    height: 170,
                    width: double.infinity,
                    child: _imageUrl.isNotEmpty
                        ? _image
                        : Icon(
                            Icons.image,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                  ),
                ),
              const SizedBox(height: 10),
              Text(
                widget.product.name,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              const SizedBox(height: 10),
              Text(
                '\$${widget.product.price}',
                style: Theme.of(context).textTheme.headline2,
              ),
              Expanded(child: Container()),
              Text(
                "Vendedor: ${widget.product.seller}",
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
