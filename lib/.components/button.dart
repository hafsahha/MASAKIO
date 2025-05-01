import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final Function onPressed;
  final String content;
  final double? width;
  final int? backgroundColor;
  final int? textColor;
  const Button({super.key, required this.onPressed, required this.content, this.width, this.backgroundColor, this.textColor});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(backgroundColor ?? 0xFF83AEB1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        elevation: 0,
      ),
      child: Text(
        content,
        style: TextStyle(
          color: Color(textColor ?? 0xFFFFFFFF),
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}