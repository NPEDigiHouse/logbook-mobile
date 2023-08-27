import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/src/data/models/clinical_records/affected_part_model.dart';
import 'package:elogbook/src/data/models/clinical_records/management_role_model.dart';
import 'package:elogbook/src/data/models/clinical_records/management_types_model.dart';
import 'package:elogbook/src/presentation/features/students/clinical_record/providers/clinical_record_data_notifier.dart';
import 'package:elogbook/src/presentation/features/students/clinical_record/providers/clinical_record_data_temp.dart';
import 'package:elogbook/src/presentation/widgets/dividers/item_divider.dart';
import 'package:elogbook/src/presentation/widgets/headers/form_section_header.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManagementAdaptiveForm extends StatefulWidget {
  final String iconPath;
  final List<AffectedPart> affectedParts;
  final List<ManagementTypesModel>? managementTypes;
  final List<ManagementRoleModel>? managementRole;

  final String title;
  final ClinicalRecordData clinicalRecordData;
  final String unitId;
  const ManagementAdaptiveForm({
    super.key,
    required this.affectedParts,
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
            if (widget.affectedParts.isNotEmpty) {
              final part = widget.affectedParts.first;
              RoleTypeModel rtm = RoleTypeModel();
              if (widget.managementTypes != null &&
                  widget.managementTypes!.isNotEmpty) {
                rtm.typeId = widget.managementTypes!.first.id;
                rtm.typeName = widget.managementTypes!.first.typeName;
              }
              if (widget.managementRole != null &&
                  widget.managementRole!.isNotEmpty) {
                rtm.roleId = widget.managementRole!.first.id;
                rtm.roleName = widget.managementRole!.first.roleName;
              }
              data.addManagementPart(PartManagementModel(
                partId: part.id,
                partName: part.partName,
                typeRoles: [
                  rtm,
                ],
              ));
            } else {
              data.addManagementPart(PartManagementModel());
            }
          },
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: data.managements.length,
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
                      data.changeManagementPart(
                        PartManagementModel(
                          partId: v!.id,
                          partName: v.partName,
                          typeRoles: data.managements[index].typeRoles,
                        ),
                        data.managements[index].partId!,
                      );
                    },
                    value: data.managements[index].partName == null
                        ? null
                        : widget.affectedParts.firstWhere((element) =>
                            element.id == data.managements[index].partId),
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
                  itemCount: data.managements[index].typeRoles!.length,
                  itemBuilder: (context, index2) {
                    final roleTypeData =
                        data.managements[index].typeRoles![index2];
                    return Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              DropdownButtonFormField(
                                hint: Text(
                                    '${widget.title} Type (${index2 + 1})'),
                                items: widget.managementTypes!
                                    .map(
                                      (e) => DropdownMenuItem(
                                        child: Text(e.typeName!),
                                        value: e,
                                      ),
                                    )
                                    .toList(),
                                onChanged: (v) {
                                  if (v != null) {
                                    data.changeManagementType(
                                      typeId: v.id!,
                                      typeName: v.typeName!,
                                      typeIdBefore: roleTypeData.typeId!,
                                      partId: data.managements[index].partId!,
                                    );
                                  }
                                },
                                value: roleTypeData.typeName == null
                                    ? null
                                    : widget.managementTypes!.firstWhere(
                                        (element) =>
                                            element.id == roleTypeData.typeId),
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              DropdownButtonFormField(
                                hint: Text(
                                    '${widget.title} Role (${index2 + 1})'),
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
                                    roleId: v!.id!,
                                    roleName: v.roleName!,
                                    roleIdBefore: roleTypeData.roleId!,
                                    partId: data.managements[index].partId!,
                                  );
                                },
                                value: roleTypeData.roleName == null
                                    ? null
                                    : widget.managementRole!.firstWhere(
                                        (element) =>
                                            element.id == roleTypeData.roleId),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            if (data.managements[index].typeRoles!.length ==
                                1) {
                              data.removeManagementPart(
                                  data.managements[index].partId!);
                            } else {
                              data.removeManagementRoleType(
                                  data.managements[index].typeRoles![index2]
                                      .typeId!,
                                  data.managements[index].partId ?? '',
                                  data.managements[index].typeRoles![index2]
                                          .roleId ??
                                      '');
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
                    data.addManagementType(
                        RoleTypeModel(), data.managements[index].partId ?? '');
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
