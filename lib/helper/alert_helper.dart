import 'package:flutter/material.dart';

//This helper helps to display message to user by showing up pop up message on screen.
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
