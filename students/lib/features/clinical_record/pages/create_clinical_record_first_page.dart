import 'package:core/context/navigation_extension.dart';
import 'package:data/models/clinical_records/detail_clinical_record_model.dart';
import 'package:data/models/supervisors/supervisor_model.dart';
import 'package:data/models/units/active_unit_model.dart';
import 'package:data/repository/repository_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:main/blocs/supervisor_cubit/supervisors_cubit.dart';
import 'package:main/widgets/dividers/section_divider.dart';
import 'package:main/widgets/headers/form_section_header.dart';
import 'package:main/widgets/inputs/build_text_field.dart';
import 'package:main/widgets/inputs/custom_dropdown.dart';
import 'package:main/widgets/spacing_column.dart';
import 'create_clinical_record_second_page.dart';
import '../providers/clinical_record_data_temp.dart';

class CreateClinicalRecordFirstPage extends StatefulWidget {
  final ActiveDepartmentModel activeDepartmentModel;
  final DetailClinicalRecordModel? detail;
  const CreateClinicalRecordFirstPage(
      {super.key, required this.activeDepartmentModel, this.detail});

  @override
  State<CreateClinicalRecordFirstPage> createState() =>
      _CreateClinicalRecordFirstPageState();
}

class _CreateClinicalRecordFirstPageState
    extends State<CreateClinicalRecordFirstPage> {
  final TextEditingController patientNameController = TextEditingController();
  final TextEditingController patientAgeController = TextEditingController();
  final TextEditingController recordIdController = TextEditingController();
  final ValueNotifier<String?> supervisorVal = ValueNotifier(null);
  String? supervisorId;
  String gender = 'MALE';
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (RepositoryData.supervisors.isEmpty) {
        BlocProvider.of<SupervisorsCubit>(context, listen: false)
            .getAllSupervisors();
      }
    });
    if (widget.detail != null) {
      patientNameController.text = widget.detail?.patientName ?? '';
      patientAgeController.text = (widget.detail?.patientAge ?? "").toString();
      recordIdController.text = widget.detail?.recordId ?? '';
      supervisorId = widget.detail?.supervisorId;
      gender = (widget.detail?.patientSex ?? 'MALE').toUpperCase();
    }
  }

  @override
  void dispose() {
    super.dispose();
    patientAgeController.dispose();
    patientNameController.dispose();
    recordIdController.dispose();
    supervisorVal.dispose();
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
          child: Builder(builder: (context) {
            return FormBuilder(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  SpacingColumn(
                    horizontalPadding: 16,
                    spacing: 14,
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          label: Text('Datetime'),
                          enabled: false,
                        ),
                        initialValue: DateFormat('dd/MM/yyyy HH:mm:ss')
                            .format(DateTime.now()),
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          label: Text('Department'),
                          enabled: false,
                        ),
                        initialValue: widget.activeDepartmentModel.unitName,
                      ),
                      if (RepositoryData.supervisors.isNotEmpty)
                        CustomDropdown<SupervisorModel>(
                            errorNotifier: supervisorVal,
                            onSubmit: (text, controller) {
                              if (RepositoryData.supervisors.indexWhere(
                                      (element) =>
                                          element.fullName?.trim() ==
                                          text.trim()) ==
                                  -1) {
                                controller.clear();
                                supervisorId = '';
                              }
                            },
                            hint: 'Supervisor',
                            onCallback: (pattern) {
                              final temp = RepositoryData.supervisors
                                  .where((competence) =>
                                      (competence.fullName ?? 'unknown')
                                          .toLowerCase()
                                          .trim()
                                          .contains(pattern.toLowerCase()))
                                  .toList();

                              return pattern.isEmpty
                                  ? RepositoryData.supervisors
                                  : temp;
                            },
                            child: (suggestion) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0,
                                  vertical: 16,
                                ),
                                child: Text(suggestion?.fullName ?? ''),
                              );
                            },
                            onItemSelect: (v, controller) {
                              if (v != null) {
                                supervisorId = v.id!;
                                controller.text = v.fullName!;
                              }
                            })
                      else
                        BlocBuilder<SupervisorsCubit, SupervisorsState>(
                            builder: (context, state) {
                          if (state is SupervisorFetchSuccess) {
                            RepositoryData.supervisors.clear();
                            RepositoryData.supervisors
                                .addAll(state.supervisors);
                            return CustomDropdown<SupervisorModel>(
                                errorNotifier: supervisorVal,
                                onSubmit: (text, controller) {
                                  if (RepositoryData.supervisors.indexWhere(
                                          (element) =>
                                              element.fullName?.trim() ==
                                              text.trim()) ==
                                      -1) {
                                    controller.clear();
                                    supervisorId = '';
                                  }
                                },
                                hint: 'Supervisor',
                                onCallback: (pattern) {
                                  final temp = RepositoryData.supervisors
                                      .where((competence) =>
                                          (competence.fullName ?? 'unknown')
                                              .toLowerCase()
                                              .trim()
                                              .contains(pattern.toLowerCase()))
                                      .toList();

                                  return pattern.isEmpty
                                      ? RepositoryData.supervisors
                                      : temp;
                                },
                                child: (suggestion) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0,
                                      vertical: 16,
                                    ),
                                    child: Text(suggestion?.fullName ?? ''),
                                  );
                                },
                                onItemSelect: (v, controller) {
                                  if (v != null) {
                                    supervisorId = v.id!;
                                    controller.text = v.fullName!;
                                  }
                                });
                          }
                          return const CircularProgressIndicator();
                        }),
                     
                      BuildTextField(
                        onChanged: (v) {},
                        controller: recordIdController,
                        label: 'Record Id/No.RM (required)',
                        validator: FormBuilderValidators.required(
                          errorText: 'This field is required',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const SectionDivider(),
                  const FormSectionHeader(
                    label: 'Patient',
                    pathPrefix: 'icon_patient.svg',
                    padding: 16,
                  ),
                  SpacingColumn(
                    horizontalPadding: 16,
                    spacing: 14,
                    children: [
                      BuildTextField(
                        onChanged: (v) {},
                        label: 'Patient Name (Required)',
                        controller: patientNameController,
                        validator: FormBuilderValidators.required(
                          errorText: 'This field is required',
                        ),
                      ),
                      Builder(builder: (context) {
                        List<String> genderType = ['MALE', 'FEMALE'];
                        return DropdownButtonFormField(
                          isExpanded: true,
                          decoration: const InputDecoration(
                            labelText: 'Gender (Required)',
                          ),
                          validator: FormBuilderValidators.required(
                            errorText: 'This field is required',
                          ),
                          items: genderType
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e),
                                ),
                              )
                              .toList(),
                          onChanged: (v) {
                            // Patient Male
                            gender = v!;
                          },
                          value: genderType[0],
                        );
                      }),
                      BuildTextField(
                        onChanged: (v) {},
                        label: 'Patient Age (required)',
                        controller: patientAgeController,
                        isOnlyNumber: true,
                        isOnlyDigit: true,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter patient age';
                          }
                          final age = int.tryParse(value);
                          if (age == null) {
                            return 'Please enter a valid number';
                          }
                          if (age < 0 || age > 200) {
                            return 'Please enter an age between 1 and 200';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      FilledButton(
                        onPressed: onSubmit,
                        child: const Text('Next'),
                      ).fullWidth(),
                    ],
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  void onSubmit() {
    FocusScope.of(context).unfocus();
    supervisorVal.value = supervisorId == null
        ? 'This field is required, please select again.'
        : null;
    if (_formKey.currentState!.saveAndValidate() && supervisorId != null) {
      final clinicalRecord = ClinicalRecordData();
      clinicalRecord.clear();
      clinicalRecord.addSupervisorId(supervisorId!);
      if (patientAgeController.text.isNotEmpty) {
        clinicalRecord.addPatientData(patientNameController.text,
            int.parse(patientAgeController.text), gender);
      }
      clinicalRecord.addRecordId(recordIdController.text);

      if (clinicalRecord.isFirstDataComplete()) {
        context.navigateTo(
          CreateClinicalRecordSecondPage(
            unitId: widget.activeDepartmentModel.unitId!,
            clinicalRecordData: clinicalRecord,
            detail: widget.detail,
          ),
        );
      }
    }
  }
}
