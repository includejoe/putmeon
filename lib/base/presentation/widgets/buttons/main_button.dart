import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  const Button({
    Key? key,
    required this.text,
    this.onTap,
    this.backgroundColor,
    this.textColor
  }) : super(key: key);

  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: backgroundColor ?? theme.colorScheme.primary,
            borderRadius: const BorderRadius.all(Radius.circular(8))
        ),
        child: Center(
            child: Text(
              text,
              style: theme.textTheme.labelMedium?.copyWith(
                  color: textColor ?? theme.colorScheme.onPrimary
              ),
            )
        ),
      ),
    );
  }
}
