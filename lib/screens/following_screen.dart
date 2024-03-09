import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/widgets/follower_card.dart';

class Following extends StatefulWidget {
  final userData;
  const Following({
    super.key,
    required this.userData,
  });

  @override
  State<Following> createState() => _FollowingState();
}

class _FollowingState extends State<Following> {
  @override
  Widget build(BuildContext context) {
    List following = widget.userData['following'];

    return Scaffold(
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: following.isNotEmpty
            ? FirebaseFirestore.instance
                .collection('users')
                .where('uid', whereIn: following)
                .snapshots()
            : Stream.empty(),
        builder: ((context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (following.isEmpty || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('You don\'t follow anyone'),
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
