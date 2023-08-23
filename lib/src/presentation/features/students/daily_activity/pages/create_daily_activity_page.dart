import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/src/presentation/features/students/clinical_record/pages/create_clinical_record_third_page.dart';
import 'package:elogbook/src/presentation/features/students/clinical_record/providers/clinical_record_data_notifier.dart';
import 'package:elogbook/src/presentation/widgets/dividers/section_divider.dart';
import 'package:elogbook/src/presentation/widgets/headers/form_section_header.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:flutter/material.dart';

class CreateDailyActivityPage extends StatefulWidget {
  const CreateDailyActivityPage({super.key});

  @override
  State<CreateDailyActivityPage> createState() =>
      _CreateDailyActivityPageState();
}

class _CreateDailyActivityPageState extends State<CreateDailyActivityPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Daily Activity"),
      ).variant(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 20),
          child: Column(
            children: [
              SizedBox(
                height: 4,
              ),
              FormSectionHeader(
                label: 'General Info',
                pathPrefix: 'icon_info.svg',
                padding: 16,
              ),
              SpacingColumn(spacing: 16, horizontalPadding: 16, children: [
                TextFormField(
                  decoration: InputDecoration(
                    label: Text('Date'),
                    enabled: false,
                  ),
                  initialValue: '02/20/2023 23:11:26',
                ),
                TextFormField(
                  decoration: InputDecoration(
                    label: Text('Time'),
                    enabled: false,
                  ),
                  initialValue: '02/20/2023 23:11:26',
                ),
                Builder(builder: (context) {
                  List<String> _type = ['Noor', 'Jasmine'];
                  return DropdownButtonFormField(
                    hint: Text('Supervisor'),
                    items: _type
                        .map(
                          (e) => DropdownMenuItem(
                            child: Text(e),
                            value: e,
                          ),
                        )
                        .toList(),
                    onChanged: (v) {},
                  );
                }),
                SizedBox(
                  height: 12,
                ),
              ]),
              SectionDivider(),
              FormSectionHeader(
                label: 'Activity',
                pathPrefix: 'icon_diagnosis.svg',
                padding: 16,
              ),
              SizedBox(
                height: 4,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Builder(builder: (context) {
                  List<String> _type = ['Attend', 'Not Attend'];
                  return DropdownButtonFormField(
                    hint: Text('Status'),
                    items: _type
                        .map(
                          (e) => DropdownMenuItem(
                            child: Text(e),
                            value: e,
                          ),
                        )
                        .toList(),
                    onChanged: (v) {},
                  );
                }),
              ),
              SizedBox(
                height: 16,
              ),
              SpacingColumn(
                spacing: 16,
                horizontalPadding: 16,
                children: [
                  Builder(builder: (context) {
                    List<String> _type = ['Hospital', 'Puskesmas'];
                    return DropdownButtonFormField(
                      hint: Text('Location'),
                      items: _type
                          .map(
                            (e) => DropdownMenuItem(
                              child: Text(e),
                              value: e,
                            ),
                          )
                          .toList(),
                      onChanged: (v) {},
                    );
                  }),
                  Builder(builder: (context) {
                    List<String> _type = ['2', '23'];
                    return DropdownButtonFormField(
                      hint: Text('Activity'),
                      items: _type
                          .map(
                            (e) => DropdownMenuItem(
                              child: Text(e),
                              value: e,
                            ),
                          )
                          .toList(),
                      onChanged: (v) {},
                    );
                  }),
                  TextFormField(
                    maxLines: 5,
                    minLines: 5,
                    decoration: InputDecoration(
                      label: Text('Activity Detail'),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: FilledButton(
                  onPressed: () => context.navigateTo(
                    CreateClinicalRecordThirdPage(
                      clinicalRecordData: ClinicalRecordData(),
                    ),
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
