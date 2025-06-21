import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final Function() onPressed;
  final String content;
  final double? width;
  final int? backgroundColor;
  final int? textColor;
  final double? textSize;
  final int? borderColor;

  const Button({
    super.key,
    required this.onPressed,
    required this.content,
    this.width,
    this.backgroundColor,
    this.textColor,
    this.textSize,
    this.borderColor
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(backgroundColor ?? 0xFF83AEB1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          side: borderColor != null
            ? BorderSide(color: Color(borderColor!), width: 2)
            : BorderSide.none,
          elevation: 0,
        ),
        child: Text(
          content,
          style: TextStyle(
            fontSize: textSize ?? 16,
            color: Color(textColor ?? 0xFFFFFFFF),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}