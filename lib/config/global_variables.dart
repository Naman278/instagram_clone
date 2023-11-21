import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/providers/user_provider.dart';
import 'package:instagram_flutter/screens/add_post_screen.dart';
import 'package:instagram_flutter/screens/feed_screen.dart';
import 'package:instagram_flutter/screens/profile_screen.dart';
import 'package:instagram_flutter/screens/search_screen.dart';
import 'package:provider/provider.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  const FeedScreen(),
  const SearchScreen(),
  const AddPostScreen(),
  const Center(
    child: const Text(
      'Feature Comming soon',
    ),
  ),
  Consumer<UserProvider>(
    builder: (context, userProvider, _) {
      final uid =
          userProvider.getUser.uid ?? FirebaseAuth.instance.currentUser!.uid;
      return ProfileScreen(uid: uid);
    },
  )
];
