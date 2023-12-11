import 'package:core/styles/color_palette.dart';
import 'package:data/models/clinical_records/diagnosis_types_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main/widgets/dividers/item_divider.dart';
import 'package:main/widgets/headers/form_section_header.dart';
import 'package:main/widgets/spacing_column.dart';
import '../providers/clinical_record_data_notifier2.dart';
import '../providers/clinical_record_data_temp.dart';

class DiagnosticsAdaptiveForm extends StatefulWidget {
  final String iconPath;
  final List<DiagnosisTypesModel>? diagnosisTypes;
  final String title;
  final ClinicalRecordData clinicalRecordData;
  final String unitId;
  const DiagnosticsAdaptiveForm({
    super.key,
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
    final data = context.watch<ClinicalRecordDataNotifier2>();
    return Column(
      children: [
        FormSectionHeader(
          label: widget.title,
          pathPrefix: widget.iconPath,
          padding: 16,
          onTap: () {
            if (widget.diagnosisTypes!.isNotEmpty) {
              final type = widget.diagnosisTypes!.first;
              data.addDiagnosticType(TypeModel(
                typeId: type.id,
                typeName: type.typeName,
              ));
            } else {
              data.addDiagnosticType(TypeModel());
            }
          },
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: data.diagnostics.length,
          itemBuilder: (context, index) {
            return SpacingColumn(
              crossAxisAlignment: CrossAxisAlignment.start,
              horizontalPadding: 16,
              spacing: 14,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Builder(builder: (context) {
                        return DropdownButtonFormField(
                          isExpanded: true,
                          hint: const Text('Diagnostics Types'),
                          items: widget.diagnosisTypes!
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e.typeName!),
                                ),
                              )
                              .toList(),
                          onChanged: (v) {
                            data.changeDiagnosticsType(
                              TypeModel(
                                typeId: v?.id,
                                typeName: v?.typeName,
                              ),
                              data.diagnostics[index].id!,
                            );
                          },
                          value: data.diagnostics[index].typeName == null
                              ? null
                              : widget.diagnosisTypes?.firstWhere((element) =>
                                  element.id == data.diagnostics[index].typeId),
                        );
                      }),
                    ),
                    IconButton(
                      onPressed: () {
                        data.removeDiagnosticsType(data.diagnostics[index].id!);
                      },
                      icon: const Icon(
                        Icons.delete_outline_rounded,
                        color: primaryColor,
                      ),
                    )
                  ],
                ),
                const ItemDivider(),
                const SizedBox(
                  height: 4,
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
