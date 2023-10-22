import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DateInput extends StatefulWidget {
  const DateInput({
    Key? key,
    required this.controller,
    this.label,
    this.error,
  }) : super(key: key);

  final TextEditingController controller;
  final String? label;
  final String? error;

  @override
  State<DateInput> createState() => _DateInputState();
}

class _DateInputState extends State<DateInput> {
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1990, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        widget.controller.text = "${selectedDate.toLocal()}".split(' ')[0];
      });
    }
  }

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
        InkWell(
          onTap: () {_selectDate(context);},
          child: SizedBox(
            height: 50,
            child: TextFormField(
              controller: widget.controller,
              maxLines: 1,
              enabled: false,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
              decoration: InputDecoration(
                hintText: "Pick date",
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
                        color: widget.error != null ? theme.colorScheme.error : Colors.transparent
                    )
                ),
                contentPadding: widget.label != null ?
                const EdgeInsets.all(8) :
                const EdgeInsets.symmetric(vertical: 8),
                prefixIcon: Icon(CupertinoIcons.calendar, color: theme.colorScheme.primary),
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
}
