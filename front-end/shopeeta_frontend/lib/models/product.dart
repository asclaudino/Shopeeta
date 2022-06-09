class Product {
  String name;
  String description;
  double price;
  String seller;
  int id;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.seller,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['product_id'],
      name: json['name'] as String,
      description: json['description'] as String,
      price: json['price'] as double,
      seller: json['seller'] as String,
    );
  }
}
