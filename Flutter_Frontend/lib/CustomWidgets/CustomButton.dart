import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  CustomButton({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    var screenSizes = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 151, 145, 145),
          minimumSize: Size(screenSizes.width * 0.85, 50),
        ),
        child: Text(text,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: screenSizes.width * 0.045)),
      ),
    );
  }
}
