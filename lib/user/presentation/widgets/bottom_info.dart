import 'package:flutter/material.dart';

class BottomInfo extends StatelessWidget {
  const BottomInfo({
    super.key,
    required this.info,
    required this.btnText,
    required this.action,
  });

  final String info;
  final String btnText;
  final void Function() action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 50,),
        Divider(
          height: 0,
          thickness: 1,
          color: Colors.grey[400],
        ),
        const SizedBox(height: 10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(info, style: theme.textTheme.bodyMedium,),
            TextButton(
              onPressed: action,
              style: ButtonStyle(
                padding: MaterialStateProperty.all(
                    const EdgeInsets.all(0)
                ),
              ),
              child: Text(
                  btnText,
                  style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.underline,
                      color: theme.colorScheme.primary
                  )
              ),
            ),
          ],
        ),
        const SizedBox(height: 10,),
      ],
    );
  }
}
