import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart ' show ByteData, rootBundle;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_flutter/config/colors.dart';
import 'package:instagram_flutter/config/utils.dart';
import 'package:instagram_flutter/resources/auth_method.dart';
import 'package:instagram_flutter/screens/email_verification_page.dart';
import 'package:instagram_flutter/screens/login_screen.dart';
import 'package:instagram_flutter/widgets/text_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  Uint8List? _image;
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadImage();
  }

  Future<void> loadImage() async {
    setState(() {
      isLoading = true;
    });
    ByteData data = await rootBundle.load('assets/default_user.png');
    List<int> bytes = data.buffer.asUint8List();
    setState(() {
      _image = Uint8List.fromList(bytes);
      isLoading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
    _nameController.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void signUpUser() async {
    setState(() {
      isLoading = true;
    });
    String res = await AuthMethods().signUpUser(
        email: _emailController.text,
        password: _passController.text,
        userName: _usernameController.text,
        name: _nameController.text,
        bio: _bioController.text,
        file: _image!,
        context: context);
    setState(() {
      isLoading = false;
    });
    if (res != 'success') {
      showSnackbar(res, context);
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const EmailVerificationScreen(),
        ),
      );
    }
  }

  void navigateToLogin() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 32),
            width: double.infinity,
            child: Align(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  SvgPicture.asset(
                    'assets/ic_instagram.svg',
                    color: primaryColor,
                    height: 64,
                  ),
                  const SizedBox(height: 44),
                  //circular widget to show Profile Pic
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 75,
                        backgroundColor: secondaryColor,
                        backgroundImage: AssetImage('assets/default_user.png'),
                        // MemoryImage(_image!),
                      ),
                      Positioned(
                        bottom: -15,
                        left: 100,
                        child: IconButton(
                          onPressed: () {
                            selectImage();
                          },
                          icon: Icon(
                            Icons.add_a_photo,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFieldInput(
                    textEditingController: _nameController,
                    textInputType: TextInputType.text,
                    hintText: "Enter your name",
                  ),
                  const SizedBox(height: 20),
                  TextFieldInput(
                    textEditingController: _emailController,
                    textInputType: TextInputType.emailAddress,
                    hintText: "Enter your Email",
                  ),
                  const SizedBox(height: 20),
                  TextFieldInput(
                    textEditingController: _usernameController,
                    textInputType: TextInputType.text,
                    hintText: "Enter your User Name",
                  ),
                  const SizedBox(height: 20),
                  TextFieldInput(
                    textEditingController: _passController,
                    isPass: true,
                    textInputType: TextInputType.text,
                    hintText: "Enter your Password",
                  ),
                  const SizedBox(height: 20),
                  TextFieldInput(
                    textEditingController: _bioController,
                    textInputType: TextInputType.text,
                    hintText: "Enter your Bio",
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: signUpUser,
                    child: Container(
                      child: isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                color: primaryColor,
                              ),
                            )
                          : const Text('Sign Up'),
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: const ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        color: blueColor,
                      ),
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Text("Already have an account?"),
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                        ),
                      ),
                      GestureDetector(
                        onTap: navigateToLogin,
                        child: Container(
                          child: Text(
                            " Login",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: blueColor,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
