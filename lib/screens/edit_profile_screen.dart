import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_flutter/config/colors.dart';
import 'package:instagram_flutter/config/utils.dart';
import 'package:instagram_flutter/resources/firestore_methods.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController _userName = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController _bio = TextEditingController();
  String photoUrl = "";
  Uint8List? _image;
  bool isLoading = false;
  Map<String, dynamic>? data;
  bool isChange = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    String uid = FirebaseAuth.instance.currentUser!.uid;
    var snap =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    var userdata = snap.data()!;
    setState(() {
      data = userdata;
      _userName.text = userdata['username'];
      _name.text = userdata['name'];
      _bio.text = userdata['bio'];
      photoUrl = userdata['photoUrl'];
      isLoading = false;
    });
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _bio.dispose();
    _name.dispose();
    _userName.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(isChange),
          icon: const Icon(Icons.close_rounded),
        ),
        title: const Text('Edit User info'),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () async {
              await FirestoreMethods().updateUser(
                _userName.text,
                _name.text,
                _bio.text,
                _image,
                context,
                data!,
              );
              isChange = true;
              Navigator.of(context).pop(isChange);
            },
            icon: const Icon(Icons.check),
          )
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          _image == null
                              ? CircleAvatar(
                                  backgroundColor: secondaryColor,
                                  backgroundImage: NetworkImage(photoUrl),
                                  radius: 70,
                                )
                              : CircleAvatar(
                                  backgroundImage: MemoryImage(_image!),
                                  radius: 70,
                                ),
                          Positioned(
                            bottom: -10,
                            left: 100,
                            child: IconButton(
                                onPressed: selectImage,
                                icon: const Icon(Icons.add_a_photo)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: _userName,
                      decoration: const InputDecoration(
                        label: Text('Username'),
                        labelStyle: TextStyle(
                          color: secondaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: _name,
                      decoration: const InputDecoration(
                        label: Text('Name'),
                        labelStyle: TextStyle(
                          color: secondaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: _bio,
                      decoration: const InputDecoration(
                        label: Text('Bio'),
                        labelStyle: TextStyle(
                          color: secondaryColor,
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
