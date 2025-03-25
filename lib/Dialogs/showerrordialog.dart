import 'package:flutter/material.dart';
import 'package:notes/Dialogs/generic_dialog.dart';

Future<void> showErrorDialog(BuildContext context, String text) {
  return showGenericDialog(
    context: context,
    title: 'An error occurred',
    content: text,
    optionsBuilder: () {
      return {'Ok': null};
    },
  );
}
