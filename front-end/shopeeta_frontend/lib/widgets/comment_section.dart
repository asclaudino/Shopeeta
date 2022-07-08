import 'package:flutter/material.dart';
import '../models/comment.dart';
import '../models/product.dart';
import './comment_post.dart';
//import '../helpers/http_requests.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommentSection extends StatefulWidget {
  const CommentSection({
    super.key,
    required this.width,
    required this.product,
  });
  final double width;
  final Product product;
  @override
  State<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final _comments = <Comment>[
    Comment(
      commentText:
          "Esta seria a seção de comentários, mas infelizmente ela não funciona :(",
      userName: "Shopeeta devs",
      numberOfStars: 5,
      productId: 1,
    ),
  ];

  //bool _loadedComments = false;
  String userName = "";
  String password = "";

  /* void _getLatestComments() async {
    var response =
        await CommentHttpRequestHelper.getComments(widget.product.id);
    if (response.success) {
      setState(() {
        _comments = response.content;
        _loadedComments = true;
      });
    }
  } */

  @override
  Widget build(BuildContext context) {
    var prefs = SharedPreferences.getInstance();
    prefs.then((prefs) {
      userName = prefs.getString('userName')!;
      password = prefs.getString('password')!;
    });
    // if (!_loadedComments) _getLatestComments();
    return Container(
      padding: const EdgeInsets.only(
        bottom: 30,
        left: 30,
        top: 30,
        right: 30,
      ),
      width: widget.width,
      height: 500,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
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
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Comentários",
            style: Theme.of(context).textTheme.headline2,
          ),
          const SizedBox(
            height: 20,
          ),
          ..._comments.map((e) {
            return Container(
              height: 150,
              width: double.infinity,
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 15,
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: ((context, index) {
                        return Icon(
                          index < e.numberOfStars
                              ? Icons.star
                              : Icons.star_border_outlined,
                          color: Theme.of(context).colorScheme.secondary,
                          size: 20,
                        );
                      }),
                    ),
                  ),
                  Text(
                    " - ${e.commentText}",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Text(
                    e.userName,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            );
          }).toList(),
          Expanded(
            child: Container(),
          ),
          CommentPost(
            width: widget.width,
            product: widget.product,
            userName: userName,
            password: password,
          ),
        ],
      ),
    );
  }
}
