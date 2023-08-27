import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/src/data/models/supervisors/supervisor_model.dart';
import 'package:elogbook/src/data/models/units/active_unit_model.dart';
import 'package:elogbook/src/presentation/blocs/supervisor_cubit/supervisors_cubit.dart';
import 'package:elogbook/src/presentation/features/students/clinical_record/pages/create_clinical_record_second_page.dart';
import 'package:elogbook/src/presentation/features/students/clinical_record/providers/clinical_record_data_temp.dart';
import 'package:elogbook/src/presentation/widgets/dividers/section_divider.dart';
import 'package:elogbook/src/presentation/widgets/headers/form_section_header.dart';
import 'package:elogbook/src/presentation/widgets/inputs/build_text_field.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class CreateClinicalRecordFirstPage extends StatefulWidget {
  final ActiveUnitModel activeUnitModel;
  const CreateClinicalRecordFirstPage(
      {super.key, required this.activeUnitModel});

  @override
  State<CreateClinicalRecordFirstPage> createState() =>
      _CreateClinicalRecordFirstPageState();
}

class _CreateClinicalRecordFirstPageState
    extends State<CreateClinicalRecordFirstPage> {
  final TextEditingController patientNameController = TextEditingController();
  final TextEditingController patientAgeController = TextEditingController();
  final TextEditingController recordIdController = TextEditingController();
  String supervisorId = '';
  String gender = 'MALE';
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      BlocProvider.of<SupervisorsCubit>(context, listen: false)
        ..getAllSupervisors();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    patientAgeController.dispose();
    patientNameController.dispose();
    recordIdController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Clinical Record"),
      ).variant(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 20),
          child: Builder(builder: (context) {
            return Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                SpacingColumn(
                  horizontalPadding: 16,
                  spacing: 14,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        label: Text('Datetime'),
                        enabled: false,
                      ),
                      initialValue: DateFormat('dd/MM/yyyy HH:mm:ss')
                          .format(DateTime.now()),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        label: Text('Unit'),
                        enabled: false,
                      ),
                      initialValue: widget.activeUnitModel.unitName,
                    ),
                    BlocBuilder<SupervisorsCubit, SupervisorsState>(
                        builder: (context, state) {
                      List<SupervisorModel> _supervisors = [];
                      if (state is FetchSuccess) {
                        _supervisors.clear();
                        _supervisors.addAll(state.supervisors);
                      }
                      return DropdownButtonFormField(
                        hint: Text('Supervisor'),
                        items: _supervisors
                            .map(
                              (e) => DropdownMenuItem(
                                child: Text(e.fullName!),
                                value: e,
                              ),
                            )
                            .toList(),
                        onChanged: (v) {
                          if (v != null) supervisorId = v.id!;
                          ;
                        },
                        value: null,
                      );
                    }),
                    BuildTextField(
                      onChanged: (v) {},
                      controller: recordIdController,
                      label: 'Record Id',
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                SectionDivider(),
                FormSectionHeader(
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
                      label: 'Patient Name',
                      controller: patientNameController,
                    ),
                    Builder(builder: (context) {
                      List<String> _genderType = ['MALE', 'FEMALE'];
                      return DropdownButtonFormField(
                        items: _genderType
                            .map(
                              (e) => DropdownMenuItem(
                                child: Text(e),
                                value: e,
                              ),
                            )
                            .toList(),
                        onChanged: (v) {
                          // Patient Male
                          gender = v!;
                        },
                        value: _genderType[0],
                      );
                    }),
                    BuildTextField(
                      onChanged: (v) {},
                      label: 'Patient Age',
                      controller: patientAgeController,
                      isOnlyNumber: true,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    FilledButton(
                      onPressed: () {
                        final clinicalRecord = ClinicalRecordData();
                        clinicalRecord.clear();
                        clinicalRecord.addSupervisorId(supervisorId);
                        if (patientAgeController.text.isNotEmpty)
                          clinicalRecord.addPatientData(
                              patientNameController.text,
                              int.parse(patientAgeController.text),
                              gender);
                        clinicalRecord.addRecordId(recordIdController.text);

                        if (clinicalRecord.isFirstDataComplete())
                          context.navigateTo(
                            CreateClinicalRecordSecondPage(
                              unitId: widget.activeUnitModel.unitId!,
                              clinicalRecordData: clinicalRecord,
                            ),
                          );
                      },
                      child: Text('Next'),
                    ).fullWidth(),
                  ],
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
