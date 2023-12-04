import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/models/userModel.dart';
import 'package:instagram_flutter/providers/user_provider.dart';
import 'package:instagram_flutter/widgets/follower_card.dart';
import 'package:provider/provider.dart';

class Followers extends StatefulWidget {
  final userData;
  const Followers({
    super.key,
    required this.userData,
  });

  @override
  State<Followers> createState() => _FollowersState();
}

class _FollowersState extends State<Followers> {
  @override
  Widget build(BuildContext context) {
    UserModel user = Provider.of<UserProvider>(context).getUser;
    List followers = widget.userData['followers'];

    return Scaffold(
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: followers.isNotEmpty
            ? FirebaseFirestore.instance
                .collection('users')
                .where('uid', whereIn: followers)
                .snapshots()
            : Stream.empty(),
        builder: ((context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (followers.isEmpty || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No Followers'),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) => Container(
              padding: EdgeInsets.only(left: 5, top: 5),
              child: FollowerCard(
                snap: snapshot.data!.docs[index].data(),
              ),
            ),
          );
        }),
      ),
    );
  }
}
