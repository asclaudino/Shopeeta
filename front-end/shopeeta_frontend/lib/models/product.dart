class Product {
  String name;
  String description;
  double price;
  String seller;
  String sellerEmail;
  int id;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.seller,
    required this.sellerEmail,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['product_id'],
      name: json['name'] as String,
      description: json['description'] as String,
      price: json['price'] as double,
      seller: json['seller'] as String,
      sellerEmail: json['seller_email'] as String,
    );
  }
}
