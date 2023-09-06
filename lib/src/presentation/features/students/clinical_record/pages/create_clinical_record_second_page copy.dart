// import 'package:elogbook/core/context/navigation_extension.dart';
// import 'package:elogbook/src/data/models/clinical_records/affected_part_model.dart';
// import 'package:elogbook/src/data/models/clinical_records/diagnosis_types_model.dart';
// import 'package:elogbook/src/data/models/clinical_records/examination_types_model.dart';
// import 'package:elogbook/src/data/models/clinical_records/management_role_model.dart';
// import 'package:elogbook/src/data/models/clinical_records/management_types_model.dart';
// import 'package:elogbook/src/presentation/blocs/clinical_record_cubit/clinical_record_cubit.dart';
// import 'package:elogbook/src/presentation/features/students/clinical_record/pages/create_clinical_record_third_page.dart';
// import 'package:elogbook/src/presentation/features/students/clinical_record/providers/clinical_record_data_notifier.dart';
// import 'package:elogbook/src/presentation/features/students/clinical_record/providers/clinical_record_data_temp.dart';
// import 'package:elogbook/src/presentation/features/students/clinical_record/widgets/diagnostics_adaptive_form.dart';
// import 'package:elogbook/src/presentation/features/students/clinical_record/widgets/examination_adaptive_form.dart';
// import 'package:elogbook/src/presentation/features/students/clinical_record/widgets/management_adaptive_form.dart';
// import 'package:elogbook/src/presentation/widgets/dividers/section_divider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class CreateClinicalRecordSecondPage extends StatefulWidget {
//   final String unitId;
//   final ClinicalRecordData clinicalRecordData;
//   const CreateClinicalRecordSecondPage(
//       {required this.unitId, required this.clinicalRecordData});

//   @override
//   State<CreateClinicalRecordSecondPage> createState() =>
//       _CreateClinicalRecordSecondPageState();
// }

// class _CreateClinicalRecordSecondPageState
//     extends State<CreateClinicalRecordSecondPage> {
//   List<AffectedPart> affectedParts = [];
//   List<ExaminationTypesModel> examTypes = [];
//   List<ManagementTypesModel> managementTypes = [];
//   List<ManagementRoleModel> managementRoles = [];
//   List<DiagnosisTypesModel> diagnosisTypes = [];

//   @override
//   void initState() {
//     Future.microtask(() {
//       BlocProvider.of<ClinicalRecordCubit>(context)
//         ..getAffectedParts(unitId: widget.unitId)
//         ..getExaminationTypes(unitId: widget.unitId)
//         ..getDiagnosisTypes(unitId: widget.unitId)
//         ..getManagementTypes(unitId: widget.unitId)
//         ..getManagementRoles();
//     });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Add Clinical Record"),
//       ).variant(),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.only(bottom: 20),
//           child: BlocBuilder<ClinicalRecordCubit, ClinicalRecordState>(
//             builder: (context, state) {
//               if (state.affectedParts != null) {
//                 if (affectedParts.isEmpty) {
//                   affectedParts.addAll(state.affectedParts!);
//                 } else {
//                   affectedParts = state.affectedParts!;
//                 }
//                 ;
//               }
//               if (state.examinationTypes != null) {
//                 if (examTypes.isEmpty) {
//                   examTypes.addAll(state.examinationTypes!);
//                 } else {
//                   examTypes = state.examinationTypes!;
//                 }
//               }
//               if (state.diagnosisTypes != null) {
//                 if (diagnosisTypes.isEmpty) {
//                   diagnosisTypes.addAll(state.diagnosisTypes!);
//                 } else {
//                   diagnosisTypes = state.diagnosisTypes!;
//                 }
//               }
//               if (state.managementTypes != null &&
//                   state.managementRoles != null) {
//                 if (managementTypes.isEmpty && managementRoles.isEmpty) {
//                   managementTypes.addAll(state.managementTypes!);
//                   managementRoles.addAll(state.managementRoles!);
//                 } else {
//                   managementTypes = state.managementTypes!;
//                   managementRoles = state.managementRoles!;
//                 }
//               }

//               return Column(
//                 children: [
//                   SizedBox(
//                     height: 4,
//                   ),
//                   if (examTypes.isNotEmpty)
//                     ExaminationAdaptiveForm(
//                       affectedParts: affectedParts,
//                       iconPath: 'icon_examination.svg',
//                       title: 'Examination',
//                       clinicalRecordData: widget.clinicalRecordData,
//                       unitId: widget.unitId,
//                       examTypes: examTypes,
//                     ),
//                   SectionDivider(),
//                   if (state.diagnosisTypes != null)
//                     DiagnosticsAdaptiveForm(
//                       affectedParts: affectedParts,
//                       iconPath: 'icon_diagnosis.svg',
//                       title: 'Diagnosis',
//                       clinicalRecordData: widget.clinicalRecordData,
//                       unitId: widget.unitId,
//                       diagnosisTypes: diagnosisTypes,
//                     ),
//                   SectionDivider(),
//                   if (state.managementTypes != null &&
//                       state.managementRoles != null)
//                     ManagementAdaptiveForm(
//                       iconPath: 'icon_management.svg',
//                       unitId: widget.unitId,
//                       title: 'Management',
//                       affectedParts: affectedParts,
//                       clinicalRecordData: widget.clinicalRecordData,
//                       managementRole: managementRoles,
//                       managementTypes: managementTypes,
//                     ),
//                   SizedBox(
//                     height: 16,
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                     child: FilledButton(
//                       onPressed: () {
//                         final data = context.read<ClinicalRecordDataNotifier>();
//                         widget.clinicalRecordData.tempAddSecondData(
//                           data.getManagementPost(),
//                           data.getDiagnosisPost(),
//                           data.getExaminationPost(),
//                         );
//                         context.navigateTo(
//                           CreateClinicalRecordThirdPage(
//                             clinicalRecordData: widget.clinicalRecordData,
//                           ),
//                         );
//                       },
//                       child: Text('Next'),
//                     ).fullWidth(),
//                   ),
//                 ],
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
