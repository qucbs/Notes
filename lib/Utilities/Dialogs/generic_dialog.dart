import 'package:flutter/material.dart';

typedef DialogOptionBuilder<T> = Map<String, T> Function();

Future<T?> showGenericDialog<T>({
  required BuildContext context,
  required String title,
  required String content,
  required DialogOptionBuilder<T> optionsBuilder,
}) {
  final options = optionsBuilder();
  return showDialog<T>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: options.keys.map((optionTitle) {
          final value = options[optionTitle]; // Safe handling
          return TextButton(
            onPressed: () {
              Navigator.of(context).pop(value); // Safe, even if value is null
            },
            child: Text(optionTitle),
          );
        }).toList(),
      );
    },
  );
}
