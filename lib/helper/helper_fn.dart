import 'package:flutter/material.dart';

// Error message display function
void displayMessageToUser(String message, BuildContext context,
    {String title = "Oops!"}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("OK"),
        ),
      ],
    ),
  );
}
