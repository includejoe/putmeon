import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  const Loader({super.key, required this.size, this.color});
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: size,
      width: size,
      child: CircularProgressIndicator(
          strokeWidth: 3,
          color: theme.colorScheme.primary
      ),
    );
  }
}
