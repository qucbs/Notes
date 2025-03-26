import 'package:flutter/material.dart';
import 'package:notes/Utilities/Dialogs/generic_dialog.dart';

Future<bool> showLogoutDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Log out',
    content: 'Are you sure you want to log out?',
    optionsBuilder: () {
      return {
        'Cancel': false,
        'Log out': true,
      };
    },
  ).then((value) => value ?? false);
}
