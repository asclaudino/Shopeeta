import 'package:flutter/material.dart';
//import '../models/comment.dart';
//import '../helpers/http_requests.dart';
import '../models/product.dart';

class CommentPost extends StatefulWidget {
  const CommentPost({
    super.key,
    required this.width,
    required this.product,
    required this.password,
    required this.userName,
  });

  final double width;
  final Product product;
  final String userName;
  final String password;

  @override
  State<CommentPost> createState() => _CommentPostState();
}

class _CommentPostState extends State<CommentPost> {
  final _formKey = GlobalKey<FormState>();
  String commentario = "";
  /* var _commentPosted = false;
  var _errorOnPostMessage = "";
  var _errorOnPost = false;
 */
  /* void _postComment() async {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      var response = await CommentHttpRequestHelper.postComment(
        Comment(
            commentText: commentario,
            productId: widget.product.id,
            numberOfStars: 5,
            userName: "" // id will be set by the server
            ),
        "", // password
      );
      if (response.success) {
        setState(() {
          // _commentPosted = true;
          // _errorOnPost = false;
        });
      } else {
        setState(() {
          //_errorOnPost = true;
          //_commentPosted = false;
          //_errorOnPostMessage = response.errorMessage;
        });
      }
    }
  } */

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(
        30,
      ),
      width: widget.width,
      //height: 200,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
      ),
      child: Form(
        key: _formKey,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: TextFormField(
                minLines: 4,
                maxLines: 4,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Seu Comentário',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Seu comentário não pode ser vazio!';
                  }
                  return null;
                },
                onSaved: (value) {
                  commentario = value!;
                },
              ),
            ),
            const SizedBox(
              width: 50,
            ),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(
                Icons.comment,
                color: Colors.black,
                size: 18,
              ),
              label: const Text.rich(
                TextSpan(
                  text: "Postar comentário!",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
