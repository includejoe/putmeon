import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PageRefresher extends StatelessWidget {
  const PageRefresher({super.key, required this.onRefresh});
  final void Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: InkWell(
        onTap: onRefresh,
        child: Container(
          height: 50,
          width: 50,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(100),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 3.5),
              ),
            ],
          ),
          child: Icon(
            CupertinoIcons.refresh,
            color: theme.colorScheme.onSurface,
            size: 30,
          ),
        ),
      ),
    );
  }
}
