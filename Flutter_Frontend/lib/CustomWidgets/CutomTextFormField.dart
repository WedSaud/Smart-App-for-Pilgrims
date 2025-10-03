import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final bool obscureText;
  final TextEditingController controller;

  CustomTextField(
      {required this.hint,
      required this.icon,
      this.obscureText = false,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    var screensize = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: screensize.width * 0.01),
      child: TextField(
        controller: controller,
       // obscureText: obscureText,
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: Colors.black,
          ),
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(screensize.width * 0.09),
          ),
        ),
      ),
    );
  }
}
