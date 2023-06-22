import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/src/presentation/features/students/clinical_record/pages/create_clinical_record_second_page.dart';
import 'package:elogbook/src/presentation/widgets/dividers/section_divider.dart';
import 'package:elogbook/src/presentation/widgets/header/form_section_header.dart';
import 'package:elogbook/src/presentation/widgets/input/build_text_field.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:flutter/material.dart';

class CreateClinicalRecordFirstPage extends StatefulWidget {
  const CreateClinicalRecordFirstPage({super.key});

  @override
  State<CreateClinicalRecordFirstPage> createState() =>
      _CreateClinicalRecordFirstPageState();
}

class _CreateClinicalRecordFirstPageState
    extends State<CreateClinicalRecordFirstPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Clinical Record"),
      ).variant(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 20),
          child: Column(
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
                    initialValue: '02/20/2023 23:11:26',
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      label: Text('Unit'),
                      enabled: false,
                    ),
                    initialValue: 'Pediatric Opthalmology',
                  ),
                  BuildTextField(
                    onChanged: (v) {},
                    label: 'Supervisor',
                  ),
                  BuildTextField(
                    onChanged: (v) {},
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
                  ),
                  Builder(builder: (context) {
                    List<String> _genderType = ['Male', 'Female'];
                    return DropdownButtonFormField(
                      items: _genderType
                          .map(
                            (e) => DropdownMenuItem(
                              child: Text(e),
                              value: e,
                            ),
                          )
                          .toList(),
                      onChanged: (v) {},
                      value: _genderType[0],
                    );
                  }),
                  BuildTextField(
                    onChanged: (v) {},
                    label: 'Patient Age',
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  FilledButton(
                    onPressed: () => context.navigateTo(
                      CreateClinicalRecordSecondPage(),
                    ),
                    child: Text('Next'),
                  ).fullWidth(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
