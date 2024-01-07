import 'package:core/styles/color_palette.dart';
import 'package:data/models/clinical_records/management_role_model.dart';
import 'package:data/models/clinical_records/management_types_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main/widgets/dividers/item_divider.dart';
import 'package:main/widgets/headers/form_section_header.dart';
import 'package:main/widgets/spacing_column.dart';
import '../providers/clinical_record_data_notifier.dart';
import '../providers/clinical_record_data_temp.dart';

class ManagementAdaptiveForm extends StatefulWidget {
  final String iconPath;
  final List<ManagementTypesModel>? managementTypes;
  final List<ManagementRoleModel>? managementRole;

  final String title;
  final ClinicalRecordData clinicalRecordData;
  final String unitId;
  const ManagementAdaptiveForm({
    super.key,
    required this.iconPath,
    required this.title,
    this.managementRole,
    this.managementTypes,
    required this.clinicalRecordData,
    required this.unitId,
  });

  @override
  State<ManagementAdaptiveForm> createState() => _ManagementAdaptiveFormState();
}

class _ManagementAdaptiveFormState extends State<ManagementAdaptiveForm> {
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
            if (widget.managementTypes!.isNotEmpty) {
              final type = widget.managementTypes!.first;
              final role = widget.managementRole!.first;
              data.addManagement(RoleTypeModel(
                roleId: role.id,
                roleName: role.roleName,
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
          physics: const NeverScrollableScrollPhysics(),
          itemCount: data.managements.length,
          itemBuilder: (context, index) {
            return SpacingColumn(
              crossAxisAlignment: CrossAxisAlignment.start,
              horizontalPadding: 16,
              spacing: 14,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: SpacingColumn(children: [
                        Builder(builder: (context) {
                          return DropdownButtonFormField(
                            isExpanded: true,
                            hint: const Text('Management Types'),
                            items: widget.managementTypes!
                                .map(
                                  (e) => DropdownMenuItem(
                                    child: Text(e.typeName!),
                                    value: e,
                                  ),
                                )
                                .toList(),
                            onChanged: (v) {
                              data.changeManagementType(
                                RoleTypeModel(
                                  typeId: v?.id,
                                  typeName: v?.typeName,
                                ),
                                data.managements[index].id!,
                              );
                            },
                            value: data.managements[index].typeName == null
                                ? null
                                : widget.managementTypes?.firstWhere(
                                    (element) =>
                                        element.id ==
                                        data.managements[index].typeId),
                          );
                        }),
                        const SizedBox(
                          height: 8,
                        ),
                        Builder(builder: (context) {
                          return DropdownButtonFormField(
                            isExpanded: true,
                            hint: const Text('Management Roles'),
                            items: widget.managementRole!
                                .map(
                                  (e) => DropdownMenuItem(
                                    child: Text(e.roleName!),
                                    value: e,
                                  ),
                                )
                                .toList(),
                            onChanged: (v) {
                              data.changeManagementRole(
                                RoleTypeModel(
                                  roleId: v?.id,
                                  roleName: v?.roleName,
                                ),
                                data.managements[index].id!,
                              );
                            },
                            value: data.managements[index].roleName == null
                                ? null
                                : widget.managementRole?.firstWhere((element) =>
                                    element.id ==
                                    data.managements[index].roleId),
                          );
                        }),
                      ]),
                    ),
                    IconButton(
                      onPressed: () {
                        data.removeManagement(data.managements[index].id!);
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
        )
      ],
    );
  }
}
