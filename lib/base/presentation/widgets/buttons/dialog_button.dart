import 'package:flutter/material.dart';

class DialogButton extends StatelessWidget {
  const DialogButton({
    super.key,
    required this.btnText,
    this.height,
    this.width,
    this.background,
    this.color
  });

  final String btnText;
  final double? height;
  final double? width;
  final Color? background;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Container(
        height: height ?? 40,
        width: width ?? MediaQuery.of(context).size.width * 0.5,
        decoration: BoxDecoration(
            color: background ?? theme.colorScheme.primary,
            borderRadius: const BorderRadius.all(Radius.circular(8))
        ),
        child: Center(
          child: Text(
            btnText,
            style: theme.textTheme.bodyMedium?.copyWith(
                color: color ?? theme.colorScheme.onPrimary,
                fontWeight: FontWeight.bold
            ),
          )
        ),
      ),
    );
  }
}
