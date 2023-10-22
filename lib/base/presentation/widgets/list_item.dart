import 'package:flutter/material.dart';

class ListItem extends StatelessWidget {
  const ListItem({
    super.key,
    required this.icon,
    required this.text,
    this.suffixWidget,
    this.onTap,
  });

  final IconData icon;
  final void Function()? onTap;
  final String text;
  final Widget? suffixWidget;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 20,
                    color: theme.colorScheme.onBackground,
                  ),
                  const SizedBox(width: 10,),
                  Text(text, style: theme.textTheme.bodyMedium),
                ],
              ),
              suffixWidget != null ? suffixWidget! : Container()
            ],
          ),
        ),
      ),
    );
  }
}
