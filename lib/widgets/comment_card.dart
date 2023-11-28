import 'package:flutter/material.dart';
import 'package:instagram_flutter/config/colors.dart';
import 'package:instagram_flutter/models/userModel.dart';
import 'package:instagram_flutter/providers/user_provider.dart';
import 'package:instagram_flutter/resources/firestore_methods.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CommentCard extends StatefulWidget {
  final snap;
  const CommentCard({super.key, required this.snap});

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    UserModel user = Provider.of<UserProvider>(context).getUser;

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 18,
        horizontal: 16,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            child: CircleAvatar(
              backgroundColor: secondaryColor,
              backgroundImage: NetworkImage(widget.snap['profileImage']),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 16,
              ),
              child: GestureDetector(
                // onLongPress: widget.snap['uid'] == user.uid
                //     ? () {
                //         showSnackbar('helo', context);
                //       }
                //     : () {},
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: widget.snap['username'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: ' ${widget.snap['description']}',
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 4,
                      ),
                      child: Text(
                        DateFormat.yMMMd()
                            .format(widget.snap['datePublished'].toDate()),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: secondaryColor,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(right: 8),
            child: Column(
              children: [
                // IconButton(
                //   onPressed: () {},
                //   icon: widget.snap['likes'].contains(user.uid)
                //       ? const Icon(
                //           Icons.favorite,
                //           size: 16,
                //           color: Colors.red,
                //         )
                //       : const Icon(
                //           size: 16,
                //           Icons.favorite_border,
                //         ),
                // ),
                InkWell(
                  onTap: () async {
                    await FirestoreMethods().likeComments(
                      widget.snap['commentId'],
                      user.uid,
                      widget.snap['likes'],
                      widget.snap['postId'],
                      context,
                    );
                  },
                  child: widget.snap['likes'].contains(user.uid)
                      ? const Icon(
                          Icons.favorite,
                          size: 16,
                          color: Colors.red,
                        )
                      : const Icon(
                          size: 16,
                          Icons.favorite_border,
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text('${widget.snap['likes'].length}'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
