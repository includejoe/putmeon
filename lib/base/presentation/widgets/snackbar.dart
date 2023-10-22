import 'package:flutter/material.dart';

showSnackBar(BuildContext context, String content, Color color) {
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(content, style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Theme.of(context).colorScheme.onPrimary
        )),
        showCloseIcon: false,
        backgroundColor: color,
        duration: const Duration(seconds: 3),
      )
  );
}