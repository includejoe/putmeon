import 'package:jobpulse/base/presentation/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeSwitch extends StatelessWidget {
  const ThemeSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Switch(
        activeColor: theme.colorScheme.primary,
        activeTrackColor: theme.colorScheme.primary.withOpacity(0.4),
        value: context.watch<ThemeProvider>().isDarkMode,
        onChanged: (newValue) {
          context.read<ThemeProvider>().toggleTheme();
        }
    );
  }
}
