import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextInput extends StatelessWidget {
  const TextInput({
    Key? key,
    required this.controller,
    required this.textInputType,
    required this.inputAction,
    this.focusNode,
    this.prefixIcon,
    this.placeholder,
    this.label,
    this.maxLines,
    this.error,
    this.height,
    this.enabled,
    this.inputFormatters,
    this.onFieldSubmitted,
  }) : super(key: key);

  final TextEditingController controller;
  final FocusNode? focusNode;
  final TextInputAction inputAction;
  final TextInputType textInputType;
  final String? placeholder;
  final String? label;
  final IconData? prefixIcon;
  final String? error;
  final int? maxLines;
  final double? height;
  final bool? enabled;
  final List<TextInputFormatter>? inputFormatters;
  final Function(String)? onFieldSubmitted;


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        label != null ? Column(
          children: [
            Text(
              label!,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 3,),
          ],
        ): Container(),
        SizedBox(
          height: height ?? 50,
          child: TextFormField(
            controller: controller,
            focusNode: focusNode,
            onFieldSubmitted: onFieldSubmitted,
            keyboardType: textInputType,
            textInputAction: inputAction,
            inputFormatters: inputFormatters,
            maxLines: maxLines ?? 1,
            enabled: enabled ?? true,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
            decoration: InputDecoration(
              hintText: placeholder,
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
              disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                      color: Colors.transparent
                  )
              ),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                      color: error != null ? theme.colorScheme.error : Colors.transparent
                  )
              ),
              contentPadding: label != null ?
              const EdgeInsets.all(8) :
              const EdgeInsets.symmetric(vertical: 8),
              prefixIcon: prefixIcon != null ?
              Icon(prefixIcon, color: theme.colorScheme.primary,) : null,
            ),
          ),
        ),
        error != null ?
        Padding(
          padding: const EdgeInsets.fromLTRB(2, 0, 0, 8),
          child: Text(
            error!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
        ) : Container()
      ],
    );
  }
}
