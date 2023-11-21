import 'package:flutter/material.dart';
import 'package:instagram_flutter/config/colors.dart';

class FollowButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color borderColor;
  final String text;
  final bool isOwner;
  const FollowButton({
    super.key,
    required this.backgroundColor,
    required this.borderColor,
    required this.text,
    required this.onPressed,
    required this.isOwner,
  });

  @override
  State<FollowButton> createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 10,
      ),
      child: TextButton(
        onPressed: widget.onPressed,
        child: Container(
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            border: Border.all(
              color: widget.borderColor,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            widget.text,
            style: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          width: widget.isOwner ? 280 : 163,
          height: 35,
        ),
      ),
    );
  }
}
