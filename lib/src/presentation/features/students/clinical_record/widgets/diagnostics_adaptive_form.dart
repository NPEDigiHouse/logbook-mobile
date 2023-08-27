import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/src/data/models/clinical_records/affected_part_model.dart';
import 'package:elogbook/src/data/models/clinical_records/diagnosis_types_model.dart';
import 'package:elogbook/src/presentation/features/students/clinical_record/providers/clinical_record_data_notifier.dart';
import 'package:elogbook/src/presentation/features/students/clinical_record/providers/clinical_record_data_temp.dart';
import 'package:elogbook/src/presentation/widgets/dividers/item_divider.dart';
import 'package:elogbook/src/presentation/widgets/headers/form_section_header.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiagnosticsAdaptiveForm extends StatefulWidget {
  final String iconPath;
  final List<AffectedPart> affectedParts;
  final List<DiagnosisTypesModel>? diagnosisTypes;
  final String title;
  final ClinicalRecordData clinicalRecordData;
  final String unitId;
  const DiagnosticsAdaptiveForm({
    super.key,
    required this.affectedParts,
    required this.iconPath,
    required this.title,
    this.diagnosisTypes,
    required this.clinicalRecordData,
    required this.unitId,
  });

  @override
  State<DiagnosticsAdaptiveForm> createState() =>
      _DiagnosticsAdaptiveFormState();
}

class _DiagnosticsAdaptiveFormState extends State<DiagnosticsAdaptiveForm> {
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
              data.addDiagnosticPart(PartModel(
                partId: part.id,
                partName: part.partName,
                types: [
                  if (widget.diagnosisTypes != null &&
                      widget.diagnosisTypes!.isNotEmpty)
                    TypeModel(
                        typeId: widget.diagnosisTypes!.first.id,
                        typeName: widget.diagnosisTypes!.first.typeName),
                  if (widget.diagnosisTypes == null ||
                      widget.diagnosisTypes!.isEmpty)
                    TypeModel(),
                ],
              ));
            } else {
              data.addDiagnosticPart(PartModel());
            }
          },
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: data.diagnostics.length,
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
                      data.changeDiagnosticPart(
                        PartModel(
                          partId: v!.id,
                          partName: v.partName,
                          types: data.diagnostics[index].types,
                        ),
                        data.diagnostics[index].partId!,
                      );
                    },
                    value: data.diagnostics[index].partName == null
                        ? null
                        : widget.affectedParts.firstWhere((element) =>
                            element.id == data.diagnostics[index].partId),
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
                  itemCount: data.diagnostics[index].types!.length,
                  itemBuilder: (context, index2) {
                    final typeData = data.diagnostics[index].types![index2];
                    return Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField(
                            hint: Text('${widget.title} Type (${index2 + 1})'),
                            items: widget.diagnosisTypes!
                                .map(
                                  (e) => DropdownMenuItem(
                                    child: Text(e.typeName!),
                                    value: e,
                                  ),
                                )
                                .toList(),
                            onChanged: (v) {
                              data.changeDiagnosticType(
                                  TypeModel(
                                      typeId: v!.id, typeName: v.typeName),
                                  data.diagnostics[index].partId!,
                                  typeData.typeId!);
                            },
                            value: typeData.typeName == null
                                ? null
                                : widget.diagnosisTypes!.firstWhere(
                                    (element) => element.id == typeData.typeId),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            if (data.diagnostics[index].types!.length == 1) {
                              data.removeDiagnosticsPart(
                                  data.diagnostics[index].partId!);
                            } else {
                              data.removeDiagnosticsType(
                                  data.diagnostics[index].types![index2]
                                      .typeId!,
                                  data.diagnostics[index].partId ?? '');
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
                    data.addDiagnosticsType(
                        TypeModel(), data.diagnostics[index].partId ?? '');
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
