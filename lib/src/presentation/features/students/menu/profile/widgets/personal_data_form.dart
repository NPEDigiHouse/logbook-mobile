import 'package:flutter/material.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/presentation/features/students/menu/profile/widgets/personal_data_field.dart';
import 'package:elogbook/src/presentation/features/students/menu/profile/widgets/personal_data_text_field.dart';

class PersonalDataForm extends StatefulWidget {
  final String title;
  final Map<String, String?> dataMap;

  const PersonalDataForm({
    super.key,
    required this.title,
    required this.dataMap,
  });

  @override
  State<PersonalDataForm> createState() => _PersonalDataFormState();
}

class _PersonalDataFormState extends State<PersonalDataForm> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late final ValueNotifier<Map<String, String?>> formNotifier;
  late final ValueNotifier<bool> isEditNotifier;

  @override
  void initState() {
    formNotifier = ValueNotifier({});
    isEditNotifier = ValueNotifier(false);

    super.initState();
  }

  @override
  void dispose() {
    formNotifier.dispose();
    isEditNotifier.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final labels = widget.dataMap.keys.toList();
    final values = widget.dataMap.values.toList();

    return ValueListenableBuilder(
      valueListenable: isEditNotifier,
      builder: (context, isEdit, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              color: onDisableColor,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 4, 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      widget.title,
                      style: textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    ValueListenableBuilder(
                      valueListenable: formNotifier,
                      builder: (context, data, child) {
                        return IconButton(
                          icon: Icon(
                            isEdit ? Icons.check_rounded : Icons.edit_rounded,
                            size: 18,
                          ),
                          onPressed: () {
                            if (isEdit) {
                              formKey.currentState!.save();

                              // Save the data to database
                            }

                            isEditNotifier.value = !isEditNotifier.value;
                          },
                          tooltip: isEdit ? 'Save' : 'Edit',
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  for (var i = 0; i < widget.dataMap.length; i++) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                      child: isEdit
                          ? PersonalDataTextField(
                              label: labels[i],
                              value: values[i],
                              onSaved: (value) {
                                formNotifier.value[labels[i]] = value;
                              },
                            )
                          : PersonalDataField(
                              label: labels[i],
                              value: values[i],
                            ),
                    ),
                  ],
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
