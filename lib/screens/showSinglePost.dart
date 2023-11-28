import 'package:flutter/material.dart';
import 'package:instagram_flutter/config/colors.dart';
import 'package:instagram_flutter/widgets/post_card.dart';

class SinglePost extends StatefulWidget {
  final snap;
  const SinglePost({super.key, required this.snap});

  @override
  State<SinglePost> createState() => _SinglePostState();
}

class _SinglePostState extends State<SinglePost> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore'),
        centerTitle: false,
        backgroundColor: mobileBackgroundColor,
      ),
      body: PostCard(snap: widget.snap),
    );
  }
}
