import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/src/presentation/widgets/dividers/section_divider.dart';
import 'package:elogbook/src/presentation/widgets/header/form_section_header.dart';
import 'package:elogbook/src/presentation/widgets/input/build_text_field.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:flutter/material.dart';

class CreateProfessionalActivityPage extends StatefulWidget {
  const CreateProfessionalActivityPage({super.key});

  @override
  State<CreateProfessionalActivityPage> createState() =>
      _CreateProfessionalActivityPageState();
}

class _CreateProfessionalActivityPageState
    extends State<CreateProfessionalActivityPage> {
  final ValueNotifier<bool> isSaveAsDraft = ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Professional Activity"),
      ).variant(),
      body: SafeArea(
        child: SingleChildScrollView(
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
              SpacingColumn(
                spacing: 16,
                horizontalPadding: 16,
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      label: Text('Datetime'),
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
                    height: 8,
                  ),
                ],
              ),
              SectionDivider(),
              SizedBox(
                height: 8,
              ),
              FormSectionHeader(
                label: 'Professional Activity',
                pathPrefix: 'health_metrics_rounded.svg',
                padding: 16,
              ),
              SpacingColumn(
                spacing: 16,
                horizontalPadding: 16,
                children: [
                  BuildTextField(
                    onChanged: (v) {},
                    label: 'Activity',
                  ),
                  BuildTextField(
                    onChanged: (v) {},
                    label: 'Reference',
                  ),
                  Builder(builder: (context) {
                    List<String> _type = ['Presenter', 'Audience'];
                    return DropdownButtonFormField(
                      hint: Text('Role'),
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
                    maxLines: 4,
                    minLines: 4,
                    decoration: InputDecoration(
                      label: Text(
                        'Additional notes',
                      ),
                    ),
                  ),
                  FilledButton(
                    onPressed: () => context.back(),
                    child: Text('Next'),
                  ).fullWidth(),
                ],
              ),
              SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
