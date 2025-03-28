import 'package:flutter/material.dart';
import 'package:notes/Utilities/Dialogs/generic_dialog.dart';

Future<void> cannotShareEmptyNoteDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Sharing',
    content: 'You cannot share an empty note',
    optionsBuilder: () => {'Ok': null},
  );
}
