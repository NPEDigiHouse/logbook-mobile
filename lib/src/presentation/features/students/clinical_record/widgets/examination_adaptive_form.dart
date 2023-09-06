import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/src/data/models/clinical_records/examination_types_model.dart';
import 'package:elogbook/src/presentation/features/students/clinical_record/providers/clinical_record_data_notifier2.dart';
import 'package:elogbook/src/presentation/features/students/clinical_record/providers/clinical_record_data_temp.dart';
import 'package:elogbook/src/presentation/widgets/dividers/item_divider.dart';
import 'package:elogbook/src/presentation/widgets/headers/form_section_header.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExaminationAdaptiveForm extends StatefulWidget {
  final String iconPath;
  final List<ExaminationTypesModel>? examTypes;
  final String title;
  final ClinicalRecordData clinicalRecordData;
  final String unitId;
  const ExaminationAdaptiveForm({
    super.key,
    required this.iconPath,
    required this.title,
    this.examTypes,
    required this.clinicalRecordData,
    required this.unitId,
  });

  @override
  State<ExaminationAdaptiveForm> createState() =>
      _ExaminationAdaptiveFormState();
}

class _ExaminationAdaptiveFormState extends State<ExaminationAdaptiveForm> {
  @override
  Widget build(BuildContext context) {
    final data = context.watch<ClinicalRecordDataNotifier2>();
    return Column(
      children: [
        FormSectionHeader(
          label: widget.title,
          pathPrefix: widget.iconPath,
          padding: 16,
          onTap: () {
            if (widget.examTypes!.isNotEmpty) {
              final type = widget.examTypes!.first;
              data.addExaminationsType(TypeModel(
                typeId: type.id,
                typeName: type.typeName,
              ));
            } else {
              data.addExaminationsType(TypeModel());
            }
          },
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: data.examinations.length,
          itemBuilder: (context, index) {
            return SpacingColumn(
              crossAxisAlignment: CrossAxisAlignment.start,
              horizontalPadding: 16,
              spacing: 12,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Builder(builder: (context) {
                        return DropdownButtonFormField(
                          isExpanded: true,
                          hint: Text('Examination Types'),
                          items: widget.examTypes!
                              .map(
                                (e) => DropdownMenuItem(
                                  child: Text(e.typeName!),
                                  value: e,
                                ),
                              )
                              .toList(),
                          onChanged: (v) {
                            data.changeExaminationType(
                              TypeModel(
                                typeId: v?.id,
                                typeName: v?.typeName,
                              ),
                              data.examinations[index].id!,
                            );
                          },
                          value: data.examinations[index].typeName == null
                              ? null
                              : widget.examTypes?.firstWhere((element) =>
                                  element.id ==
                                  data.examinations[index].typeId),
                        );
                      }),
                    ),
                    IconButton(
                      onPressed: () {
                        data.removeExaminationType(
                            data.examinations[index].id!);
                      },
                      icon: Icon(
                        Icons.delete_outline_rounded,
                        color: primaryColor,
                      ),
                    )
                  ],
                ),
                ItemDivider(),
                SizedBox(),
              ],
            );
          },
        )
      ],
    );
  }
}
