import 'package:flutter/material.dart';

class ReusableButton extends StatelessWidget {
  const ReusableButton({
    super.key,
    required this.childText,
    required this.onPressed,
    required this.buttonColor,
    required this.childTextColor,
    this.iconData,
    this.customWidth,
    this.customHeight,
  });

  final String childText;
  final Function onPressed;
  final Color buttonColor;
  final Color childTextColor;
  final IconData? iconData;
  final double? customWidth;
  final double? customHeight;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed as VoidCallback,
      child: Container(
        height: customHeight ?? 40,
        width: customWidth,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: buttonColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (iconData != null) ...[
              Icon(
                iconData,
                color: childTextColor,
              ),
              const SizedBox(width: 5),
            ],
            Text(
              childText.toUpperCase(),
              style: TextStyle(
                fontSize: 14,
                color: childTextColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
