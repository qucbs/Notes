import 'package:flutter/material.dart';
import 'package:notes/Utilities/Dialogs/generic_dialog.dart';

Future<void> showErrorDialog(BuildContext context, String text) {
  return showGenericDialog(
    context: context,
    title: 'Error',
    content: text,
    optionsBuilder: () {
      return {'Ok': null};
    },
  );
}
