import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/src/data/models/clinical_records/affected_part_model.dart';
import 'package:elogbook/src/data/models/clinical_records/examination_types_model.dart';
import 'package:elogbook/src/presentation/features/students/clinical_record/providers/clinical_record_data_notifier.dart';
import 'package:elogbook/src/presentation/features/students/clinical_record/providers/clinical_record_data_temp.dart';
import 'package:elogbook/src/presentation/widgets/dividers/item_divider.dart';
import 'package:elogbook/src/presentation/widgets/headers/form_section_header.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExaminationAdaptiveForm extends StatefulWidget {
  final String iconPath;
  final List<AffectedPart> affectedParts;
  final List<ExaminationTypesModel>? examTypes;
  final String title;
  final ClinicalRecordData clinicalRecordData;
  final String unitId;
  const ExaminationAdaptiveForm({
    super.key,
    required this.affectedParts,
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
    final data = context.watch<ClinicalRecordDataNotifier>();
    return Column(
      children: [
        FormSectionHeader(
          label: widget.title,
          pathPrefix: widget.iconPath,
          padding: 16,
          onTap: () {
            if (widget.affectedParts.isNotEmpty) {
              final part = widget.affectedParts.first;
              data.addExaminationsPart(PartModel(
                partId: part.id,
                partName: part.partName,
                types: [
                  if (widget.examTypes != null && widget.examTypes!.isNotEmpty)
                    TypeModel(
                        typeId: widget.examTypes!.first.id,
                        typeName: widget.examTypes!.first.typeName),
                  if (widget.examTypes == null || widget.examTypes!.isEmpty)
                    TypeModel(),
                ],
              ));
            } else {
              data.addExaminationsPart(PartModel());
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
              spacing: 14,
              children: [
                Builder(builder: (context) {
                  return DropdownButtonFormField(
                    hint: Text('Affected Parts'),
                    items: widget.affectedParts
                        .map(
                          (e) => DropdownMenuItem(
                            child: Text(e.partName!),
                            value: e,
                          ),
                        )
                        .toList(),
                    onChanged: (v) {
                      data.changeExaminationPart(
                        PartModel(
                          partId: v!.id,
                          partName: v.partName,
                          types: data.examinations[index].types,
                        ),
                        data.examinations[index].partId!,
                      );
                    },
                    value: data.examinations[index].partName == null
                        ? null
                        : widget.affectedParts.firstWhere((element) =>
                            element.id == data.examinations[index].partId),
                  );
                }),
                ListView.separated(
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: 12,
                    );
                  },
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: data.examinations[index].types!.length,
                  itemBuilder: (context, index2) {
                    final typeData = data.examinations[index].types![index2];
                    return Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField(
                            hint: Text('${widget.title} Type (${index2 + 1})'),
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
                                      typeId: v!.id, typeName: v.typeName),
                                  data.examinations[index].partId!,
                                  typeData.typeId!);
                            },
                            value: typeData.typeName == null
                                ? null
                                : widget.examTypes!.firstWhere(
                                    (element) => element.id == typeData.typeId),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            if (data.examinations[index].types!.length == 1) {
                              data.removeExaminationPart(
                                  data.examinations[index].partId!);
                            } else {
                              data.removeExaminationType(
                                  data.examinations[index].types![index2]
                                      .typeId!,
                                  data.examinations[index].partId ?? '');
                            }
                          },
                          icon: Icon(
                            Icons.delete_outline_rounded,
                            color: primaryColor,
                          ),
                        )
                      ],
                    );
                  },
                ),
                FilledButton.icon(
                  onPressed: () {
                    data.addExaminationType(
                        TypeModel(), data.examinations[index].partId ?? '');
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
          },
        )
      ],
    );
  }
}
