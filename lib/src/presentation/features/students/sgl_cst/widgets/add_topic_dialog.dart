import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/presentation/widgets/input/build_text_field.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:flutter/material.dart';

enum TopicDialogType {
  sgl,
  cst,
}

class AddTopicDialog extends StatefulWidget {
  final TopicDialogType type;
  const AddTopicDialog({
    super.key,
    required this.type,
  });

  @override
  State<AddTopicDialog> createState() => _AddTopicDialogState();
}

class _AddTopicDialogState extends State<AddTopicDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 36.0,
        vertical: 24.0,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 8, left: 4),
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.close_rounded,
                      color: onFormDisableColor,
                    ),
                    tooltip: 'Close',
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          widget.type == TopicDialogType.sgl
                              ? 'Add SGL Topic'
                              : 'Add CST Topic',
                          textAlign: TextAlign.center,
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 44,
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            SpacingColumn(
              horizontalPadding: 16,
              spacing: 12,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: BuildTextField(
                          onChanged: (v) {}, label: 'Start Time'),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child:
                          BuildTextField(onChanged: (v) {}, label: 'End Time'),
                    ),
                  ],
                ),
                TextFormField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search_rounded),
                    label: Text('Supervisor'),
                    suffixIcon: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.close_rounded),
                    ),
                  ),
                ),
                TextFormField(
                  maxLines: 4,
                  minLines: 4,
                  decoration: InputDecoration(
                    label: Text(
                      'Additional notes',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: FilledButton(
                onPressed: () => context.back(),
                child: Text('Submit'),
              ).fullWidth(),
            ),
            SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    );
  }
}
