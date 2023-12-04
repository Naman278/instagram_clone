import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/config/colors.dart';
import 'package:instagram_flutter/config/utils.dart';
import 'package:instagram_flutter/resources/auth_method.dart';
import 'package:instagram_flutter/resources/firestore_methods.dart';
import 'package:instagram_flutter/screens/TabView.dart';
import 'package:instagram_flutter/screens/confirm_delete_user.dart';
import 'package:instagram_flutter/screens/edit_profile_screen.dart';
import 'package:instagram_flutter/screens/userPosts.dart';
import 'package:instagram_flutter/widgets/follow_button.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postLen = 0;
  bool isOwner = false;
  bool isFollowing = false;
  int followers = 0, following = 0;
  late var currUid;
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    checkUser();
  }

  checkUser() async {
    setState(() {
      currUid = FirebaseAuth.instance.currentUser!.uid;
      currUid == widget.uid ? isOwner = true : isOwner = false;
    });
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      //get post length
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where(
            'uid',
            isEqualTo: widget.uid,
          )
          .get();
      postLen = postSnap.docs.length;
      userData = userSnap.data()!;
      followers = userData['followers'].length;
      following = userData['following'].length;
      isFollowing = userSnap.data()!['followers'].contains(currUid);
      setState(() {});
    } catch (e) {
      showSnackbar(e.toString(), context);
    }
    setState(() {
      isLoading = false;
    });
  }

  _delete(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text(
            'Delete Account!!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, color: Colors.red),
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
                'Cancel',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 17),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(10),
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red, fontSize: 17),
                textAlign: TextAlign.center,
              ),
              onPressed: () async {
                await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const DeleteUser()));
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
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(userData['username']),
              centerTitle: false,
              actions: [
                if (isOwner)
                  IconButton(
                    tooltip: 'Logout',
                    onPressed: () async {
                      await AuthMethods().signOut(context);
                    },
                    icon: const Icon(
                      Icons.logout_rounded,
                      color: Colors.red,
                    ),
                  ),
                if (isOwner)
                  IconButton(
                    onPressed: () => _delete(context),
                    tooltip: 'Delete Account',
                    icon: Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.red,
                    ),
                  ),
              ],
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 16,
                    bottom: 5,
                    left: 16,
                    right: 16,
                  ),
                  child: Column(children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: secondaryColor,
                          backgroundImage: NetworkImage(userData['photoUrl']),
                          radius: 40,
                        ),
                        Expanded(
                          flex: 2,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const SizedBox(
                                width: 40,
                              ),
                              buildStatColumn(postLen, 'Posts'),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => TabView(
                                        isFollowers: true,
                                        userData: userData,
                                      ),
                                    ),
                                  );
                                },
                                child: buildStatColumn(followers, 'Followers'),
                              ),
                              GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => TabView(
                                          isFollowers: false,
                                          userData: userData,
                                        ),
                                      ),
                                    );
                                  },
                                  child:
                                      buildStatColumn(following, 'Following'))
                            ],
                          ),
                        )
                      ],
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 7),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Text(userData['name']),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(userData['bio']),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        isOwner
                            ? FollowButton(
                                backgroundColor: customGrey,
                                borderColor: customGrey,
                                text: 'Edit Profile',
                                isOwner: isOwner,
                                onPressed: () async {
                                  bool result =
                                      await Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => const EditProfile(),
                                    ),
                                  );
                                  if (result) {
                                    getData();
                                  }
                                })
                            : FollowButton(
                                backgroundColor:
                                    isFollowing ? customGrey : blueColor,
                                borderColor:
                                    isFollowing ? customGrey : blueColor,
                                text: isFollowing ? 'Unfollow' : 'Follow',
                                isOwner: isOwner,
                                onPressed: () async {
                                  await FirestoreMethods().followUser(
                                    currUid,
                                    widget.uid,
                                    context,
                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(widget.uid)
                                        .get(),
                                  );
                                  setState(() {
                                    isFollowing = !isFollowing;
                                    followers += isFollowing ? 1 : -1;
                                  });
                                },
                              ),
                        if (!isOwner)
                          FollowButton(
                            backgroundColor: customGrey,
                            borderColor: customGrey,
                            text: 'Message',
                            isOwner: isOwner,
                            onPressed: (() {}),
                          ),
                      ],
                    )
                  ]),
                ),
                const Divider(),
                FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('posts')
                      .where('uid', isEqualTo: widget.uid)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return GridView.builder(
                      shrinkWrap: true,
                      itemCount: (snapshot.data! as dynamic).docs.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 1.5,
                        childAspectRatio: 1,
                      ),
                      itemBuilder: (context, index) {
                        DocumentSnapshot snap =
                            (snapshot.data! as dynamic).docs[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => UserPosts(
                                  uid: widget.uid,
                                ),
                              ),
                            );
                            getData();
                          },
                          child: Container(
                            child: Image(
                              image: NetworkImage(
                                snap['postUrl'],
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(
            top: 4,
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: secondaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
