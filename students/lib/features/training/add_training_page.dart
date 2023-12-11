import 'package:core/context/navigation_extension.dart';
import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:flutter/material.dart';
import 'package:main/widgets/dividers/section_divider.dart';
import 'package:main/widgets/headers/form_section_header.dart';
import 'package:main/widgets/spacing_column.dart';

class AddTrainingPage extends StatelessWidget {
  const AddTrainingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Training"),
      ).variant(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              SpacingColumn(spacing: 16, horizontalPadding: 16, children: [
                TextFormField(
                  decoration: const InputDecoration(
                    label: Text('Date'),
                    enabled: false,
                  ),
                  initialValue: '02/20/2023 23:11:26',
                ),
                Builder(builder: (context) {
                  List<String> type = ['Noor', 'Jasmine'];
                  return DropdownButtonFormField(
                    isExpanded: true,
                    hint: const Text('Training Type'),
                    items: type
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ),
                        )
                        .toList(),
                    onChanged: (v) {},
                  );
                }),
                Builder(builder: (context) {
                  List<String> type = ['Noor', 'Jasmine'];
                  return DropdownButtonFormField(
                    isExpanded: true,
                    hint: const Text('Supervisor'),
                    items: type
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ),
                        )
                        .toList(),
                    onChanged: (v) {},
                  );
                }),
                Builder(builder: (context) {
                  List<String> type = ['Noor', 'Jasmine'];
                  return DropdownButtonFormField(
                    isExpanded: true,
                    hint: const Text('Assistant'),
                    items: type
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ),
                        )
                        .toList(),
                    onChanged: (v) {},
                  );
                }),
                const SizedBox(
                  height: 12,
                ),
              ]),
              const SectionDivider(),
              const SizedBox(
                height: 16,
              ),
              const TrainingAdaptiveForm(
                iconPath: 'icon_training.svg',
                title: 'Training Schedule',
              ),
              const SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: FilledButton(
                  onPressed: () {},
                  child: const Text('Next'),
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
      ValueNotifier([]);
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
            margin: const EdgeInsets.only(left: 8),
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
            decoration: const InputDecoration(
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
            icon: const Icon(
              Icons.close_rounded,
            ),
          )
        ],
      ),
    );
  }
}
