import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Color.fromARGB(255, 255, 34, 34),
      content: Text(
        text,
        style: TextStyle(color: Color.fromARGB(255, 252, 252, 252)),
      ),
    ),
  );
}

void showSuccessSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Color.fromARGB(255, 9, 112, 64),
      content: Text(
        text,
        style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
      ),
    ),
  );
}
