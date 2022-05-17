import 'package:flutter/material.dart';

class MyAlertDialog extends StatelessWidget {
  const MyAlertDialog({
    super.key,
    required this.text,
    required this.title,
    required this.onConfirmText,
    required this.onConfirm,
  });

  final String text;
  final String title;
  final String onConfirmText;
  final Function onConfirm;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 100,
        height: 250,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          boxShadow: [
            BoxShadow(
              blurRadius: 3,
              spreadRadius: 3,
              color: Colors.black.withOpacity(0.3),
              offset: const Offset(0, 0),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headline2,
            ),
            Text(
              text,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  child: Text(
                    "Cancelar",
                    style: Theme.of(context).textTheme.button,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                  child: Text(
                    onConfirmText,
                    style: Theme.of(context).textTheme.button!.copyWith(
                          color: Colors.red,
                        ),
                  ),
                  onPressed: () => onConfirm(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
