import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/src/presentation/widgets/dividers/item_divider.dart';
import 'package:elogbook/src/presentation/widgets/header/form_section_header.dart';
import 'package:elogbook/src/presentation/widgets/input/build_text_field.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:flutter/material.dart';

enum ClinicalRecordSectionType { examination, diagnosis, management }

class ClinicalRecordAdaptiveForm extends StatefulWidget {
  final ClinicalRecordSectionType clinicalRecordSectionType;
  final String iconPath;
  final String title;
  const ClinicalRecordAdaptiveForm({
    super.key,
    required this.clinicalRecordSectionType,
    required this.iconPath,
    required this.title,
  });

  @override
  State<ClinicalRecordAdaptiveForm> createState() =>
      _ClinicalRecordAdaptiveFormState();
}

class _ClinicalRecordAdaptiveFormState
    extends State<ClinicalRecordAdaptiveForm> {
  final ValueNotifier<List<ClinicalRecordFormParent>> listExaminationAffected =
      new ValueNotifier([]);
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: listExaminationAffected,
      builder: (context, val, _) {
        return Column(
          children: [
            FormSectionHeader(
              label: widget.title,
              pathPrefix: widget.iconPath,
              padding: 16,
              onTap: () {
                listExaminationAffected.value = [
                  ...listExaminationAffected.value,
                  ClinicalRecordFormParent(
                    listExaminationAffected: listExaminationAffected,
                    index: val.length,
                    clinicalRecordSectionType: widget.clinicalRecordSectionType,
                    title: widget.title,
                  )
                ];
              },
            ),
            ...val,
          ],
        );
      },
    );
  }
}

class ClinicalRecordFormParent extends StatefulWidget {
  final ValueNotifier<List<ClinicalRecordFormParent>> listExaminationAffected;
  final ClinicalRecordSectionType clinicalRecordSectionType;
  final String title;

  final int index;
  const ClinicalRecordFormParent({
    super.key,
    required this.clinicalRecordSectionType,
    required this.listExaminationAffected,
    required this.index,
    required this.title,
  });

  @override
  State<ClinicalRecordFormParent> createState() =>
      _ClinicalRecordFormParentState();
}

class _ClinicalRecordFormParentState extends State<ClinicalRecordFormParent> {
  final ValueNotifier<List<ClinicalRecordFormChild>> listExaminationType =
      new ValueNotifier([]);

  @override
  void initState() {
    listExaminationType.value.add(ClinicalRecordFormChild(
      val: listExaminationType,
      index: 0,
      clinicalRecordSectionType: widget.clinicalRecordSectionType,
      title: widget.title,
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: listExaminationType,
        builder: (context, val, _) {
          if (val.isEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              widget.listExaminationAffected.value =
                  List.from(widget.listExaminationAffected.value)
                    ..removeAt(widget.index);
            });
          }

          return SpacingColumn(
            crossAxisAlignment: CrossAxisAlignment.start,
            horizontalPadding: 16,
            spacing: 14,
            children: [
              Builder(builder: (context) {
                List<String> _genderType = [
                  'Left Eye',
                  'Right Eye',
                  'Both Eye'
                ];
                return DropdownButtonFormField(
                  items: _genderType
                      .map(
                        (e) => DropdownMenuItem(
                          child: Text(e),
                          value: e,
                        ),
                      )
                      .toList(),
                  onChanged: (v) {},
                  value: _genderType[0],
                );
              }),
              ...val,
              FilledButton.icon(
                onPressed: () {
                  listExaminationType.value = [
                    ...listExaminationType.value,
                    ClinicalRecordFormChild(
                      val: listExaminationType,
                      index: val.length,
                      clinicalRecordSectionType:
                          widget.clinicalRecordSectionType,
                      title: widget.title,
                    )
                  ];
                },
                style: FilledButton.styleFrom(
                  backgroundColor: Color(0xFF29C5F6).withOpacity(.2),
                  foregroundColor: primaryColor,
                ),
                icon: Icon(
                  Icons.add_rounded,
                  color: primaryColor,
                ),
                label: Text('Add another type'),
              ),
              ItemDivider(),
              SizedBox(
                height: 4,
              ),
            ],
          );
        });
  }
}

class ClinicalRecordFormChild extends StatelessWidget {
  final String title;
  final ClinicalRecordSectionType clinicalRecordSectionType;
  final ValueNotifier<List<ClinicalRecordFormChild>> val;
  final int index;
  const ClinicalRecordFormChild({
    super.key,
    required this.val,
    required this.index,
    required this.clinicalRecordSectionType,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SpacingColumn(
            spacing: 8,
            children: [
              if (clinicalRecordSectionType ==
                  ClinicalRecordSectionType.management)
                BuildTextField(
                  onChanged: (v) {},
                  label: '${title} Role (${index + 1})',
                ),
              BuildTextField(
                onChanged: (v) {},
                label: '${title} Type (${index + 1})',
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            val.value = List.from(val.value)..removeAt(index);
          },
          icon: Icon(
            Icons.delete_outline_rounded,
            color: primaryColor,
          ),
        )
      ],
    );
  }
}
