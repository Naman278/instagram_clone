import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/config/colors.dart';
import 'package:instagram_flutter/models/userModel.dart';
import 'package:instagram_flutter/providers/user_provider.dart';
import 'package:instagram_flutter/resources/firestore_methods.dart';
import 'package:provider/provider.dart';

class FollowerCard extends StatefulWidget {
  final snap;
  const FollowerCard({
    super.key,
    required this.snap,
  });

  @override
  State<FollowerCard> createState() => _FollowerCardState();
}

class _FollowerCardState extends State<FollowerCard> {
  bool isFollowing = true;
  User currUser = FirebaseAuth.instance.currentUser!;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isFollow();
  }

  isFollow() async {
    List followers = widget.snap['followers'];
    isFollowing = followers.contains(currUser.uid);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    UserModel user = Provider.of<UserProvider>(context).getUser;

    return Container(
      padding: EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: secondaryColor,
            backgroundImage: NetworkImage(widget.snap['photoUrl']),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.snap['username'],
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  widget.snap['name'],
                  style: TextStyle(color: secondaryColor, fontSize: 17),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () async {
              await FirestoreMethods().followUser(
                user.uid,
                widget.snap['uid'],
                context,
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(widget.snap['uid'])
                    .get(),
              );
              setState(() {
                isFollowing = !isFollowing;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: isFollowing ? customGrey : blueColor,
                border: Border.all(
                  color: isFollowing ? customGrey : blueColor,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Text(
                isFollowing ? 'Unfollow' : 'Follow',
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              width: MediaQuery.of(context).size.width * 0.3,
              height: 35,
            ),
          ),
        ],
      ),
    );
  }
}
