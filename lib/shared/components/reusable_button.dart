import 'package:flutter/material.dart';

class ReusableButton extends StatelessWidget {
  const ReusableButton({
    super.key,
    required this.childText,
    required this.onPressed,
    required this.buttonColor,
    required this.childTextColor,
  });

  final String childText;
  final Function onPressed;
  final Color buttonColor;
  final Color childTextColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed as VoidCallback,
      child: Container(
        height: 40,
        // width: MediaQuery.of(context).size.width * 0.7,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: buttonColor,
        ),
        child: Center(
            child: Text(
          childText.toUpperCase(),
          style: TextStyle(
            fontSize: 14,
            color: childTextColor,
            fontWeight: FontWeight.w600,
          ),
        )),
      ),
    );
  }
}
