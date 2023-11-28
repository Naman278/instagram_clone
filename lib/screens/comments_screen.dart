import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/config/colors.dart';
import 'package:instagram_flutter/config/utils.dart';
import 'package:instagram_flutter/models/userModel.dart';
import 'package:instagram_flutter/providers/user_provider.dart';
import 'package:instagram_flutter/resources/firestore_methods.dart';
import 'package:instagram_flutter/widgets/comment_card.dart';
import 'package:provider/provider.dart';

class CommentsScreen extends StatefulWidget {
  final snap;
  const CommentsScreen({super.key, required this.snap});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _comment = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _comment.dispose();
  }

  _selectComment(BuildContext context, String commentId) async {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text(
            'Delete Comment',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          children: [
            Divider(
              color: mobileBackgroundColor,
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(10),
              child: Text(
                'Delete',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.red,
                ),
              ),
              onPressed: () async {
                await FirestoreMethods()
                    .deleteComment(widget.snap['postId'], commentId, context);
                Navigator.of(context).pop();
                showSnackbar('Comment Deleted', context);
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(10),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.red, fontSize: 17),
                textAlign: TextAlign.center,
              ),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final UserModel user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text(
          'Comments',
        ),
        centerTitle: false,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.snap['postId'])
            .collection('comments')
            .orderBy('datePublished', descending: true)
            .snapshots(),
        builder: ((context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) => GestureDetector(
              // onTap:
              //     // snapshot.data!.docs[index]['uid'] == user.uid
              //     //     ? () {}
              //     //     :
              //     () {
              //   showSnackbar('hello', context);
              // },
              onLongPress: snapshot.data!.docs[index]['uid'] == user.uid
                  ? () => _selectComment(
                      context, snapshot.data!.docs[index]['commentId'])
                  : () {},
              child: CommentCard(
                snap: snapshot.data!.docs[index].data(),
              ),
            ),
          );
        }),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          padding: const EdgeInsets.only(
            left: 16,
            right: 8,
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: secondaryColor,
                backgroundImage: NetworkImage(user.photoUrl),
                radius: 18,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 8,
                  ),
                  child: TextField(
                    controller: _comment,
                    decoration: InputDecoration(
                      hintText: 'Comment as ${user.username}....',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  await FirestoreMethods().postComment(
                    _comment.text,
                    user.uid,
                    user.username,
                    user.photoUrl,
                    widget.snap['postId'],
                    context,
                  );
                  setState(() {
                    _comment.text = "";
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 8,
                  ),
                  child: const Icon(
                    Icons.upload_rounded,
                    color: Colors.blueAccent,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
