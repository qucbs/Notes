import 'package:flutter/material.dart';
import 'package:notes/Utilities/Dialogs/generic_dialog.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Delete',
    content: 'Are you sure you want to delete this note?',
    optionsBuilder: () {
      return {
        'Cancel': false,
        'Delete': true,
      };
    },
  ).then((value) => value ?? false);
}
