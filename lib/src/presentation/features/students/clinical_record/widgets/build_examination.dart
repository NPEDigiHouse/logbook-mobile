// import 'package:elogbook/core/styles/color_palette.dart';
// import 'package:elogbook/src/data/models/clinical_records/affected_part_model.dart';
// import 'package:elogbook/src/data/models/clinical_records/diagnosis_types_model.dart';
// import 'package:elogbook/src/data/models/clinical_records/examination_types_model.dart';
// import 'package:elogbook/src/data/models/clinical_records/management_role_model.dart';
// import 'package:elogbook/src/data/models/clinical_records/management_types_model.dart';
// import 'package:elogbook/src/presentation/blocs/clinical_record_cubit/clinical_record_cubit.dart';
// import 'package:elogbook/src/presentation/features/students/clinical_record/providers/clinical_record_data_temp.dart';
// import 'package:elogbook/src/presentation/widgets/dividers/item_divider.dart';
// import 'package:elogbook/src/presentation/widgets/headers/form_section_header.dart';
// import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// enum ClinicalRecordSectionType { examination, diagnosis, management }

// class ClinicalRecordAdaptiveForm extends StatefulWidget {
//   final ClinicalRecordSectionType clinicalRecordSectionType;
//   final String iconPath;
//   final List<AffectedPart> affectedParts;
//   final List<ExaminationTypesModel>? examTypes;
//   final List<DiagnosisTypesModel>? diagnosisTypes;
//   final List<ManagementTypesModel>? managementTypes;
//   final List<ManagementRoleModel>? managementRole;

//   final String title;
//   final ClinicalRecordData clinicalRecordData;
//   final String unitId;
//   const ClinicalRecordAdaptiveForm({
//     super.key,
//     required this.affectedParts,
//     required this.clinicalRecordSectionType,
//     required this.iconPath,
//     required this.title,
//     this.examTypes,
//     this.diagnosisTypes,
//     this.managementRole,
//     this.managementTypes,
//     required this.clinicalRecordData,
//     required this.unitId,
//   });

//   @override
//   State<ClinicalRecordAdaptiveForm> createState() =>
//       _ClinicalRecordAdaptiveFormState();
// }

// class _ClinicalRecordAdaptiveFormState
//     extends State<ClinicalRecordAdaptiveForm> {
//   final ValueNotifier<List<ClinicalRecordFormParent>> listExaminationAffected =
//       new ValueNotifier([]);
//   @override
//   Widget build(BuildContext context) {
//     print(widget.examTypes);
//     return ValueListenableBuilder(
//       valueListenable: listExaminationAffected,
//       builder: (context, val, _) {
//         return Column(
//           children: [
//             FormSectionHeader(
//               label: widget.title,
//               pathPrefix: widget.iconPath,
//               padding: 16,
//               onTap: () {
//                 listExaminationAffected.value.add(ClinicalRecordFormParent(
//                   listExaminationAffected: listExaminationAffected,
//                   index: val.length,
//                   clinicalRecordSectionType: widget.clinicalRecordSectionType,
//                   title: widget.title,
//                   affectedParts: widget.affectedParts,
//                   unitId: widget.unitId,
//                   clinicalRecordData: widget.clinicalRecordData,
//                   diagnosisTypes: widget.diagnosisTypes,
//                   examTypes: widget.examTypes,
//                   managementRole: widget.managementRole,
//                   managementTypes: widget.managementTypes,
//                 ));
//                 listExaminationAffected.notifyListeners();
//               },
//             ),
//             ...val,
//           ],
//         );
//       },
//     );
//   }
// }

// class ClinicalRecordFormParent extends StatefulWidget {
//   final ValueNotifier<List<ClinicalRecordFormParent>> listExaminationAffected;
//   final ClinicalRecordSectionType clinicalRecordSectionType;
//   final List<AffectedPart> affectedParts;
//   final ClinicalRecordData clinicalRecordData;
//   final List<ExaminationTypesModel>? examTypes;
//   final List<DiagnosisTypesModel>? diagnosisTypes;
//   final List<ManagementTypesModel>? managementTypes;
//   final List<ManagementRoleModel>? managementRole;
//   final String title;
//   final String unitId;

//   final int index;
//   const ClinicalRecordFormParent({
//     super.key,
//     required this.affectedParts,
//     required this.clinicalRecordSectionType,
//     required this.listExaminationAffected,
//     required this.index,
//     required this.title,
//     required this.unitId,
//     required this.clinicalRecordData,
//     this.examTypes,
//     this.diagnosisTypes,
//     this.managementRole,
//     this.managementTypes,
//   });

//   @override
//   State<ClinicalRecordFormParent> createState() =>
//       _ClinicalRecordFormParentState();
// }

// class _ClinicalRecordFormParentState extends State<ClinicalRecordFormParent> {
//   final ValueNotifier<List<ClinicalRecordFormChild>> listExaminationType =
//       new ValueNotifier([]);
//   AffectedPart? tempAffectedPart;
//   @override
//   void initState() {
//     listExaminationType.value.add(ClinicalRecordFormChild(
//       clinicalRecordData: widget.clinicalRecordData,
//       val: listExaminationType,
//       index: 0,
//       clinicalRecordSectionType: widget.clinicalRecordSectionType,
//       title: widget.title,
//       unitId: widget.unitId,
//       examTypes: widget.examTypes,
//       diagnosisTypes: widget.diagnosisTypes,
//       managementRole: widget.managementRole,
//       managementTypes: widget.managementTypes,
//       affectedPart: widget.affectedParts[0],
//     ));
//     tempAffectedPart = widget.affectedParts[0];

//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ValueListenableBuilder(
//         valueListenable: listExaminationType,
//         builder: (context, val, _) {
//           if (val.isEmpty) {
//             WidgetsBinding.instance.addPostFrameCallback((_) {
//               widget.listExaminationAffected.value
//                   .removeWhere((element) => element.index == widget.index);
//               widget.listExaminationAffected.notifyListeners();
//             });
//           }

//           return SpacingColumn(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             horizontalPadding: 16,
//             spacing: 14,
//             children: [
//               Builder(builder: (context) {
//                 return DropdownButtonFormField(
//                   hint: Text('Affected Parts'),
//                   items: widget.affectedParts
//                       .map(
//                         (e) => DropdownMenuItem(
//                           child: Text(e.partName!),
//                           value: e,
//                         ),
//                       )
//                       .toList(),
//                   onChanged: (v) {
//                     widget.clinicalRecordData.updateAffectedPart(
//                         old: tempAffectedPart!,
//                         newAffectedPart: v!,
//                         type: widget.clinicalRecordSectionType);

//                     tempAffectedPart = v;
//                   },
//                   value: widget.affectedParts.isNotEmpty
//                       ? widget.affectedParts[0]
//                       : null,
//                 );
//               }),
//               ...val,
//               FilledButton.icon(
//                 onPressed: () {
//                   listExaminationType.value.add(ClinicalRecordFormChild(
//                     val: listExaminationType,
//                     index: val.length,
//                     clinicalRecordSectionType: widget.clinicalRecordSectionType,
//                     title: widget.title,
//                     unitId: widget.unitId,
//                     clinicalRecordData: widget.clinicalRecordData,
//                     affectedPart: tempAffectedPart ?? widget.affectedParts[0],
//                     diagnosisTypes: widget.diagnosisTypes,
//                     examTypes: widget.examTypes,
//                     managementRole: widget.managementRole,
//                     managementTypes: widget.managementTypes,
//                   ));
//                   listExaminationType.notifyListeners();
//                 },
//                 style: FilledButton.styleFrom(
//                   backgroundColor: Color(0xFF29C5F6).withOpacity(.2),
//                   foregroundColor: primaryColor,
//                 ),
//                 icon: Icon(
//                   Icons.add_rounded,
//                   color: primaryColor,
//                 ),
//                 label: Text('Add another type'),
//               ),
//               ItemDivider(),
//               SizedBox(
//                 height: 4,
//               ),
//             ],
//           );
//         });
//   }
// }

// class ClinicalRecordFormChild extends StatefulWidget {
//   final String title;
//   final ClinicalRecordSectionType clinicalRecordSectionType;
//   final ClinicalRecordData clinicalRecordData;
//   final ValueNotifier<List<ClinicalRecordFormChild>> val;
//   final List<ExaminationTypesModel>? examTypes;
//   final List<DiagnosisTypesModel>? diagnosisTypes;
//   final List<ManagementTypesModel>? managementTypes;
//   final List<ManagementRoleModel>? managementRole;
//   final int index;
//   final String unitId;
//   final AffectedPart affectedPart;

//   const ClinicalRecordFormChild({
//     super.key,
//     required this.unitId,
//     required this.val,
//     required this.index,
//     required this.clinicalRecordData,
//     required this.clinicalRecordSectionType,
//     required this.title,
//     required this.affectedPart,
//     this.examTypes,
//     this.diagnosisTypes,
//     this.managementRole,
//     this.managementTypes,
//   });

//   @override
//   State<ClinicalRecordFormChild> createState() =>
//       _ClinicalRecordFormChildState();
// }

// class _ClinicalRecordFormChildState extends State<ClinicalRecordFormChild> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     widget.clinicalRecordData.addData(
//       type: widget.clinicalRecordSectionType,
//       affectedPart: widget.affectedPart,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Expanded(
//           child: SpacingColumn(
//             spacing: 8,
//             children: [
//               BlocBuilder<ClinicalRecordCubit, ClinicalRecordState>(
//                 builder: (context, state) {
//                   if (widget.clinicalRecordSectionType ==
//                       ClinicalRecordSectionType.examination) {
//                     widget.clinicalRecordData.addData(
//                       type: widget.clinicalRecordSectionType,
//                       affectedPart: widget.affectedPart,
//                       id: widget.examTypes![0].id,
//                     );
//                     print("call ${widget.examTypes}");
//                     return DropdownButtonFormField(
//                       hint: Text('${widget.title} Type (${widget.index + 1})'),
//                       items: widget.examTypes!
//                           .map(
//                             (e) => DropdownMenuItem(
//                               child: Text(e.typeName!),
//                               value: e,
//                             ),
//                           )
//                           .toList(),
//                       onChanged: (v) {
//                         widget.clinicalRecordData.addData(
//                           type: widget.clinicalRecordSectionType,
//                           affectedPart: widget.affectedPart,
//                           id: v!.id,
//                         );
//                       },
//                       value: widget.examTypes!.isNotEmpty
//                           ? widget.examTypes![0]
//                           : null,
//                     );
//                   } else if (widget.clinicalRecordSectionType ==
//                       ClinicalRecordSectionType.diagnosis) {
//                     widget.clinicalRecordData.addData(
//                       type: widget.clinicalRecordSectionType,
//                       affectedPart: widget.affectedPart,
//                       id: widget.diagnosisTypes![0].id,
//                     );
//                     return DropdownButtonFormField(
//                       hint: Text('${widget.title} Type (${widget.index + 1})'),
//                       items: widget.diagnosisTypes!
//                           .map(
//                             (e) => DropdownMenuItem(
//                               child: Text(e.typeName!),
//                               value: e,
//                             ),
//                           )
//                           .toList(),
//                       onChanged: (v) {
//                         widget.clinicalRecordData.addData(
//                           type: widget.clinicalRecordSectionType,
//                           affectedPart: widget.affectedPart,
//                           id: v!.id,
//                         );
//                       },
//                       value: widget.diagnosisTypes!.isNotEmpty
//                           ? widget.diagnosisTypes![0]
//                           : null,
//                     );
//                   } else if (widget.clinicalRecordSectionType ==
//                       ClinicalRecordSectionType.management) {
//                     String type = widget.managementTypes![0].id!;
//                     String role = widget.managementRole![0].id!;
//                     widget.clinicalRecordData.addData(
//                       type: widget.clinicalRecordSectionType,
//                       affectedPart: widget.affectedPart,
//                       id: type,
//                       roleId: role,
//                     );
//                     return SpacingColumn(
//                       spacing: 8,
//                       children: [
//                         DropdownButtonFormField(
//                           hint: Text(
//                               '${widget.title} Role (${widget.index + 1})'),
//                           items: widget.managementRole!
//                               .map(
//                                 (e) => DropdownMenuItem(
//                                   child: Text(e.roleName!),
//                                   value: e,
//                                 ),
//                               )
//                               .toList(),
//                           onChanged: (v) {
//                             type = v!.id!;
//                             widget.clinicalRecordData.addData(
//                               type: widget.clinicalRecordSectionType,
//                               affectedPart: widget.affectedPart,
//                               id: v.id,
//                               roleId: role,
//                             );
//                           },
//                           value: widget.managementRole!.isNotEmpty
//                               ? widget.managementRole![0]
//                               : null,
//                         ),
//                         DropdownButtonFormField(
//                           hint: Text(
//                               '${widget.title} Type (${widget.index + 1})'),
//                           items: widget.managementTypes!
//                               .map(
//                                 (e) => DropdownMenuItem(
//                                   child: Text(e.typeName!),
//                                   value: e,
//                                 ),
//                               )
//                               .toList(),
//                           onChanged: (v) {
//                             role = v!.id!;
//                             widget.clinicalRecordData.addData(
//                               type: widget.clinicalRecordSectionType,
//                               affectedPart: widget.affectedPart,
//                               id: type,
//                               roleId: v.id,
//                             );
//                           },
//                           value: widget.managementTypes!.isNotEmpty
//                               ? widget.managementTypes![0]
//                               : null,
//                         ),
//                       ],
//                     );
//                   } else {
//                     return SizedBox.shrink();
//                   }
//                 },
//               ),
//             ],
//           ),
//         ),
//         IconButton(
//           onPressed: () {
//             widget.val.value
//                 .removeWhere((element) => element.index == widget.index);
//             widget.val.notifyListeners();
//           },
//           icon: Icon(
//             Icons.delete_outline_rounded,
//             color: primaryColor,
//           ),
//         )
//       ],
//     );
//   }
// }
