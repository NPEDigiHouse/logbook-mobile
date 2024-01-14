import 'package:core/context/navigation_extension.dart';
import 'package:data/models/clinical_records/detail_clinical_record_model.dart';
import 'package:data/models/clinical_records/diagnosis_types_model.dart';
import 'package:data/models/clinical_records/examination_types_model.dart';
import 'package:data/models/clinical_records/management_role_model.dart';
import 'package:data/models/clinical_records/management_types_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main/blocs/clinical_record_cubit/clinical_record_cubit.dart';
import 'package:main/widgets/dividers/section_divider.dart';

import '../providers/clinical_record_data_notifier.dart';
import '../providers/clinical_record_data_temp.dart';
import '../widgets/diagnostics_adaptive_form.dart';
import '../widgets/examination_adaptive_form.dart';
import '../widgets/management_adaptive_form.dart';
import 'create_clinical_record_third_page.dart';

class CreateClinicalRecordSecondPage extends StatefulWidget {
  final String unitId;
  final ClinicalRecordData clinicalRecordData;
  final DetailClinicalRecordModel? detail;
  const CreateClinicalRecordSecondPage(
      {super.key,
      required this.unitId,
      required this.clinicalRecordData,
      this.detail});

  @override
  State<CreateClinicalRecordSecondPage> createState() =>
      _CreateClinicalRecordSecondPageState();
}

class _CreateClinicalRecordSecondPageState
    extends State<CreateClinicalRecordSecondPage> {
  List<ExaminationTypesModel> examTypes = [];
  List<ManagementTypesModel> managementTypes = [];
  List<ManagementRoleModel> managementRoles = [];
  List<DiagnosisTypesModel> diagnosisTypes = [];

  @override
  void initState() {
    Future.microtask(() {
      BlocProvider.of<ClinicalRecordCubit>(context)
        ..getExaminationTypes(unitId: widget.unitId)
        ..getDiagnosisTypes(unitId: widget.unitId)
        ..getManagementTypes(unitId: widget.unitId)
        ..getManagementRoles();
      context.read<ClinicalRecordDataNotifier>().reset();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.detail != null
            ? 'Edit Clinical Record'
            : "Add Clinical Record"),
      ).variant(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 20),
          child: BlocBuilder<ClinicalRecordCubit, ClinicalRecordState>(
            builder: (context, state) {
              if (state.examinationTypes != null) {
                if (examTypes.isEmpty) {
                  examTypes.addAll(state.examinationTypes!);
                } else {
                  examTypes = state.examinationTypes!;
                }
              }
              if (state.diagnosisTypes != null) {
                if (diagnosisTypes.isEmpty) {
                  diagnosisTypes.addAll(state.diagnosisTypes!);
                } else {
                  diagnosisTypes = state.diagnosisTypes!;
                }
              }
              if (state.managementTypes != null &&
                  state.managementRoles != null) {
                if (managementTypes.isEmpty && managementRoles.isEmpty) {
                  managementTypes.addAll(state.managementTypes!);
                  managementRoles.addAll(state.managementRoles!);
                } else {
                  managementTypes = state.managementTypes!;
                  managementRoles = state.managementRoles!;
                }
              }

              return Column(
                children: [
                  const SizedBox(
                    height: 4,
                  ),
                  if (examTypes.isNotEmpty)
                    ExaminationAdaptiveForm(
                      iconPath: 'icon_examination.svg',
                      title: 'Examination',
                      clinicalRecordData: widget.clinicalRecordData,
                      unitId: widget.unitId,
                      examTypes: examTypes,
                    ),
                  const SectionDivider(),
                  if (state.diagnosisTypes != null)
                    DiagnosticsAdaptiveForm(
                      iconPath: 'icon_diagnosis.svg',
                      title: 'Diagnosis',
                      clinicalRecordData: widget.clinicalRecordData,
                      unitId: widget.unitId,
                      diagnosisTypes: diagnosisTypes,
                    ),
                  const SectionDivider(),
                  if (state.managementTypes != null &&
                      state.managementRoles != null)
                    ManagementAdaptiveForm(
                      iconPath: 'icon_management.svg',
                      unitId: widget.unitId,
                      title: 'Management',
                      clinicalRecordData: widget.clinicalRecordData,
                      managementRole: managementRoles,
                      managementTypes: managementTypes,
                    ),
                  const SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: FilledButton(
                      onPressed: () {
                        final data = context.read<ClinicalRecordDataNotifier>();
                        widget.clinicalRecordData.tempAddSecondData(
                          data.getManagementsPost(),
                          data.getDiagnosticsPost(),
                          data.getExaminationPost(),
                        );
                        context.navigateTo(
                          CreateClinicalRecordThirdPage(
                            clinicalRecordData: widget.clinicalRecordData,
                            detail: widget.detail,
                          ),
                        );
                      },
                      child: const Text('Next'),
                    ).fullWidth(),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
