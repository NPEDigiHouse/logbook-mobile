import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/src/presentation/features/students/clinical_record/create_clinical_record_second_page.dart';
import 'package:elogbook/src/presentation/widgets/dividers/section_divider.dart';
import 'package:elogbook/src/presentation/widgets/header/form_section_header.dart';
import 'package:elogbook/src/presentation/widgets/input/build_text_field.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:flutter/material.dart';

class AddScientificSessionPage extends StatelessWidget {
  const AddScientificSessionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Scientific Session"),
      ).variant(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 20),
          child: Column(
            children: [
              SizedBox(
                height: 16,
              ),
              FormSectionHeader(
                label: 'General Info',
                pathPrefix: 'icon_info.svg',
                padding: 16,
              ),
              SpacingColumn(
                horizontalPadding: 16,
                spacing: 14,
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      label: Text('Date'),
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
                ],
              ),
              SizedBox(
                height: 16,
              ),
              SectionDivider(),
              FormSectionHeader(
                label: 'Scientific Session',
                pathPrefix: 'biotech_rounded.svg',
                padding: 16,
              ),
              SpacingColumn(
                horizontalPadding: 16,
                spacing: 14,
                children: [
                  Builder(builder: (context) {
                    List<String> _genderType = [
                      'Journal Reading',
                      'Discussion'
                    ];
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
                      hint: Text('Session Type'),
                    );
                  }),
                  BuildTextField(
                    onChanged: (v) {},
                    label: 'Topic',
                  ),
                  BuildTextField(
                    onChanged: (v) {},
                    label: 'Clinical rotation',
                  ),
                  BuildTextField(
                    onChanged: (v) {},
                    label: 'Title',
                  ),
                  BuildTextField(
                    onChanged: (v) {},
                    label: 'Reference',
                  ),
                  Builder(builder: (context) {
                    List<String> _genderType = ['Participant', 'Handler'];
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
                      hint: Text('Role'),
                    );
                  }),
                  TextFormField(
                    maxLines: 5,
                    minLines: 5,
                    decoration: InputDecoration(
                      label: Text('Additional Notes'),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  FilledButton(
                    onPressed: () {},
                    child: Text('Submit'),
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
