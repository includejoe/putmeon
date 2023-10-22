import 'package:jobpulse/base/presentation/widgets/buttons/dialog_button.dart';
import 'package:flutter/material.dart';

Future<dynamic> confirmationDialog({
  required BuildContext context,
  required String title,
  required void Function() yesAction
}) {
  final theme = Theme.of(context);

  return showDialog(
      context: context,
      builder: (context) =>  SimpleDialog(
        title: Center(
          child: Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary
              ),
              textAlign: TextAlign.center
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        backgroundColor: theme.colorScheme.background,
        children: [
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context);
              yesAction();
            },
            child: const DialogButton(btnText: "Yes"),
          ),
          SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Center(
                child: Text(
                  "No",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),),
              )
          )
        ],
      )
  );
}