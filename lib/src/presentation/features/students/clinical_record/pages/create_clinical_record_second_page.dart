import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/src/data/models/clinical_records/clinical_record_post_model.dart';
import 'package:elogbook/src/presentation/features/students/clinical_record/pages/create_clinical_record_third_page.dart';
import 'package:elogbook/src/presentation/features/students/clinical_record/widgets/build_examination.dart';
import 'package:elogbook/src/presentation/widgets/dividers/section_divider.dart';
import 'package:flutter/material.dart';

class CreateClinicalRecordSecondPage extends StatefulWidget {
  final ClinicalRecordPostModel clinicalRecord;
  const CreateClinicalRecordSecondPage(
      {super.key, required this.clinicalRecord});

  @override
  State<CreateClinicalRecordSecondPage> createState() =>
      _CreateClinicalRecordSecondPageState();
}

class _CreateClinicalRecordSecondPageState
    extends State<CreateClinicalRecordSecondPage> {
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
                height: 4,
              ),
              ClinicalRecordAdaptiveForm(
                clinicalRecordSectionType:
                    ClinicalRecordSectionType.examination,
                iconPath: 'icon_examination.svg',
                title: 'Examination',
              ),
              SectionDivider(),
              ClinicalRecordAdaptiveForm(
                clinicalRecordSectionType: ClinicalRecordSectionType.diagnosis,
                iconPath: 'icon_diagnosis.svg',
                title: 'Diagnosis',
              ),
              SectionDivider(),
              ClinicalRecordAdaptiveForm(
                clinicalRecordSectionType: ClinicalRecordSectionType.management,
                iconPath: 'icon_management.svg',
                title: 'Management',
              ),
              SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: FilledButton(
                  onPressed: () => context.navigateTo(
                    CreateClinicalRecordThirdPage(),
                  ),
                  child: Text('Next'),
                ).fullWidth(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
