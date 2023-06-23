import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/presentation/widgets/dividers/section_divider.dart';
import 'package:elogbook/src/presentation/widgets/header/form_section_header.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:flutter/material.dart';

class AddTrainingPage extends StatelessWidget {
  const AddTrainingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Training"),
      ).variant(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 20),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              SpacingColumn(spacing: 16, horizontalPadding: 16, children: [
                TextFormField(
                  decoration: InputDecoration(
                    label: Text('Date'),
                    enabled: false,
                  ),
                  initialValue: '02/20/2023 23:11:26',
                ),
                Builder(builder: (context) {
                  List<String> _type = ['Noor', 'Jasmine'];
                  return DropdownButtonFormField(
                    hint: Text('Training Type'),
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
                Builder(builder: (context) {
                  List<String> _type = ['Noor', 'Jasmine'];
                  return DropdownButtonFormField(
                    hint: Text('Assistant'),
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
              SizedBox(
                height: 16,
              ),
              TrainingAdaptiveForm(
                iconPath: 'icon_training.svg',
                title: 'Training Schedule',
              ),
              SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: FilledButton(
                  onPressed: () {},
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

class TrainingAdaptiveForm extends StatefulWidget {
  final String iconPath;
  final String title;
  const TrainingAdaptiveForm({
    super.key,
    required this.iconPath,
    required this.title,
  });

  @override
  State<TrainingAdaptiveForm> createState() => _TrainingAdaptiveFormState();
}

class _TrainingAdaptiveFormState extends State<TrainingAdaptiveForm> {
  final ValueNotifier<List<TrainingCard>> listExaminationAffected =
      new ValueNotifier([]);
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: listExaminationAffected,
      builder: (context, val, _) {
        return SpacingColumn(
          spacing: 12,
          horizontalPadding: 16,
          children: [
            FormSectionHeader(
              label: widget.title,
              pathPrefix: widget.iconPath,
              padding: 0,
              onTap: () {
                listExaminationAffected.value = [
                  ...listExaminationAffected.value,
                  TrainingCard(
                    index: val.length,
                    title: widget.title,
                    listExaminationAffected: listExaminationAffected,
                  )
                ];
              },
            ),
            ...val,
          ],
        );
      },
    );
  }
}

class TrainingCard extends StatelessWidget {
  final int index;
  final String title;
  final ValueNotifier<List<TrainingCard>> listExaminationAffected;
  const TrainingCard({
    super.key,
    required this.index,
    required this.title,
    required this.listExaminationAffected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          width: 1,
          color: dividerColor,
        ),
      ),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(left: 8),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: secondaryColor,
            ),
            child: Center(
                child: Text(
              (index + 1).toString(),
              style: textTheme.bodyMedium?.copyWith(
                color: scaffoldBackgroundColor,
              ),
            )),
          ),
          Expanded(
              child: TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
            ),
            style: textTheme.bodyMedium?.copyWith(
              height: 1.1,
            ),
          )),
          IconButton(
            onPressed: () {
              listExaminationAffected.value.remove(this);
              listExaminationAffected.notifyListeners();
            },
            icon: Icon(
              Icons.close_rounded,
            ),
          )
        ],
      ),
    );
  }
}
