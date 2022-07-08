class Comment {
  String commentText;
  String userName;
  int numberOfStars;
  int productId;
  Comment({
    required this.commentText,
    required this.userName,
    required this.numberOfStars,
    required this.productId,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      productId: json['product_id'],
      commentText: json['comment_text'] as String,
      numberOfStars: json['number_of_stars'] as int,
      userName: json['user_name'] as String,
    );
  }
}
