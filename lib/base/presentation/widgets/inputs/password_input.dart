import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PasswordInput extends StatefulWidget {
  const PasswordInput({
    Key? key,
    required this.controller,
    required this.focusNode,
    this.onFieldSubmitted,
    required this.inputAction,
    this.placeholder,
    this.error,
    this.label,
    this.showIcon
  }) : super(key: key);

  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String)? onFieldSubmitted;
  final TextInputAction inputAction;
  final String? placeholder;
  final String? error;
  final String? label;
  final bool? showIcon;

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool isVisible = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.label != null ? Column(
          children: [
            Text(
              widget.label!,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 3,),
          ],
        ): Container(),
        SizedBox(
          height: 50,
          child: TextFormField(
            controller: widget.controller,
            focusNode: widget.focusNode,
            onFieldSubmitted: widget.onFieldSubmitted,
            textInputAction: widget.inputAction,
            keyboardType: TextInputType.text,
            obscureText: isVisible,
            maxLines: 1,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
            decoration: InputDecoration(
                hintText: widget.placeholder,
                hintStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                ),
                fillColor: theme.colorScheme.surface,
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                        color: theme.colorScheme.primary
                    )
                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                        color: widget.error != null ? theme.colorScheme.error : Colors.transparent
                    )
                ),
                contentPadding: widget.showIcon == true ? const EdgeInsets.symmetric(vertical: 8,) :
                const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                prefixIcon: widget.showIcon == true ?
                Icon(CupertinoIcons.lock_fill, color: theme.colorScheme.primary,) :
                null,
                suffixIcon: IconButton(
                  highlightColor: Colors.transparent,
                  icon: Icon(
                    isVisible ? CupertinoIcons.eye_slash_fill : CupertinoIcons.eye_fill,
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                  onPressed: () {
                    setState(() {
                      isVisible = !isVisible;
                    });
                  },
                )
            ),
          ),
        ),
        widget.error != null ?
        Padding(
          padding: const EdgeInsets.fromLTRB(2, 0, 0, 8),
          child: Text(
            widget.error!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
        ) :  Container()
      ],
    );
  }
}
