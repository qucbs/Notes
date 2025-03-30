import 'package:flutter/material.dart';

typedef CloseDialog = void Function();

CloseDialog showloadingDialog({
  required BuildContext context,
  required String text,
}) {
  final dialog = AlertDialog(
    content: Container(
      height: 100,
      width: 100,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 10),
            Text(text),
          ],
        ),
      ),
    ),
  );
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => dialog,
  );

  return () {
    return Navigator.of(context).pop();
  };
}
