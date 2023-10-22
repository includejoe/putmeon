import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  const RoundButton({
    super.key,
    required this.icon,
    required this.onClick,
    required this.backgroundColor,
    this.iconColor
  });

  final IconData icon;
  final void Function() onClick;
  final Color backgroundColor;
  final Color? iconColor;


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        height: 35,
        width: 35,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 3.5),
            ),
          ],
        ),
        child: Center(
          child: Icon(
            icon,
            size: 20,
            color: iconColor ?? Colors.white,
          ),
        ),
      )
    );
  }
}
