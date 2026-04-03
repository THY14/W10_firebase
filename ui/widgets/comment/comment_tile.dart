import 'package:flutter/material.dart';
import '../../../model/comment/comment.dart';

class CommentTile extends StatelessWidget {
  const CommentTile({super.key, required this.comment});

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          leading: Icon(Icons.chat_bubble_outline, color: Colors.grey),
          title: Text(comment.text),
        ),
      ),
    );
  }
}