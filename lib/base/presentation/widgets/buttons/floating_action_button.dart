import 'package:flutter/material.dart';

class FloatActionButton extends StatefulWidget {
  const FloatActionButton({
    super.key,
    required this.icon,
    this.onPressed
  });

  final IconData icon;
  final void Function()? onPressed;

  @override
  State<FloatActionButton> createState() => _FloatActionButtonState();
}

class _FloatActionButtonState extends State<FloatActionButton> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FloatingActionButton(
      backgroundColor: theme.colorScheme.primary,
      onPressed: widget.onPressed,
      child: Icon(
        widget.icon,
        color: theme.colorScheme.onPrimary,
        size: 30,
      ),
    );
  }
}
