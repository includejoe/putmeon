import 'package:flutter/material.dart';

class SelectInput extends StatefulWidget {
  const SelectInput({
    Key? key,
    required this.controller,
    required this.focusNode,
    required this.inputAction,
    required this.options,
    required this.dialogTitle,
    this.placeholder,
    this.prefixIcon,
    this.error,
    this.label,
    this.initialValue,
    this.onFieldSubmitted,
  }) : super(key: key);

  final TextEditingController controller;
  final FocusNode focusNode;
  final TextInputAction inputAction;
  final String dialogTitle;
  final List<String> options;
  final String? placeholder;
  final IconData? prefixIcon;
  final String? error;
  final String? label;
  final String? initialValue;
  final Function(String)? onFieldSubmitted;


  @override
  State<SelectInput> createState() => _SelectInputState();
}

class _SelectInputState extends State<SelectInput> {
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
          child: InkWell(
            onTap: () => optionsDialog(),
            child: TextFormField(
              controller: widget.controller,
              focusNode: widget.focusNode,
              initialValue: widget.initialValue,
              onFieldSubmitted: widget.onFieldSubmitted,
              keyboardType: TextInputType.text,
              textInputAction: widget.inputAction,
              maxLines: 1,
              enabled: false,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
              decoration: InputDecoration(
                hintText: widget.placeholder,
                hintStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                ),
                fillColor: theme.colorScheme.surface,
                disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: widget.error != null ?
                      theme.colorScheme.error :
                      Colors.transparent
                    )
                ),
                contentPadding: widget.label != null ?
                const EdgeInsets.all(8) :
                const EdgeInsets.symmetric(vertical: 8),
                prefixIcon: widget.prefixIcon != null ?
                Icon(widget.prefixIcon, color: theme.colorScheme.primary,) : null,
              ),
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
        ) : Container()
      ],
    );
  }

  Future<dynamic> optionsDialog() {
    final theme = Theme.of(context);

    return showDialog(
      context: context,
      builder: (context) =>  SimpleDialog(
        title: Text(
          widget.dialogTitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        backgroundColor: theme.colorScheme.background,
        children: [
          for (var option in widget.options)
            SimpleDialogOption(
              onPressed: () {
                widget.controller.text = option;
                FocusScope.of(context).unfocus();
                Navigator.pop(context);
              },
              child: Text(option, style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
              ),
            )
        ],
      )
    );
  }
}
