import 'package:flutter/material.dart';
import 'package:instagram_flutter/config/colors.dart';
import 'package:instagram_flutter/models/userModel.dart';
import 'package:instagram_flutter/providers/user_provider.dart';
import 'package:instagram_flutter/screens/followers_screen.dart';
import 'package:instagram_flutter/screens/following_screen.dart';
import 'package:provider/provider.dart';

class TabView extends StatefulWidget {
  final bool isFollowers;
  final userData;
  TabView({
    super.key,
    required this.isFollowers,
    required this.userData,
  });

  @override
  State<TabView> createState() => _TabViewState();
}

class _TabViewState extends State<TabView> {
  @override
  Widget build(BuildContext context) {
    int currentIndex = widget.isFollowers ? 0 : 1;
    UserModel user = Provider.of<UserProvider>(context).getUser;
    final List<Widget> _tabs = [
      Followers(
        userData: widget.userData,
      ),
      Following(
        userData: widget.userData,
      )
    ];

    return DefaultTabController(
      initialIndex: currentIndex,
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.userData['username']),
          backgroundColor: mobileBackgroundColor,
          bottom: TabBar(tabs: [
            Tab(
              text: 'Followers',
            ),
            Tab(
              text: 'Following',
            ),
          ]),
        ),
        body: TabBarView(children: _tabs),
      ),
    );
  }
}
