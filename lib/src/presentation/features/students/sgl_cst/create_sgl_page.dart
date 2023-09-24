import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/helpers/utils.dart';
import 'package:elogbook/src/data/models/sglcst/sglcst_post_model.dart';
import 'package:elogbook/src/data/models/sglcst/topic_model.dart';
import 'package:elogbook/src/data/models/supervisors/supervisor_model.dart';
import 'package:elogbook/src/data/models/units/active_unit_model.dart';
import 'package:elogbook/src/presentation/blocs/sgl_cst_cubit/sgl_cst_cubit.dart';
import 'package:elogbook/src/presentation/blocs/supervisor_cubit/supervisors_cubit.dart';
import 'package:elogbook/src/presentation/widgets/dividers/section_divider.dart';
import 'package:elogbook/src/presentation/widgets/headers/form_section_header.dart';
import 'package:elogbook/src/presentation/widgets/inputs/custom_dropdown.dart';
import 'package:elogbook/src/presentation/widgets/inputs/input_date_time_field.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:elogbook/src/presentation/widgets/verify_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class CreateSglPage extends StatefulWidget {
  final ActiveDepartmentModel model;
  const CreateSglPage({super.key, required this.model});

  @override
  State<CreateSglPage> createState() => _CreateSglPageState();
}

class _CreateSglPageState extends State<CreateSglPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final ValueNotifier<String?> supervisorVal = ValueNotifier(null);
  final ValueNotifier<String?> topicVal = ValueNotifier(null);
  final ValueNotifier<List<int>> topics = ValueNotifier<List<int>>([-1]);
  String? supervisorId;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<SupervisorsCubit>(context, listen: false)
      ..getAllSupervisors();
    BlocProvider.of<SglCstCubit>(context, listen: false)
      ..getTopicsByDepartmentId(unitId: widget.model.unitId!);
    dateController.text = Utils.datetimeToString(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New SGL"),
      ).variant(),
      body: BlocListener<SglCstCubit, SglCstState>(
        listener: (context, state) {
          if (state.isSglPostSuccess) {
            BlocProvider.of<SglCstCubit>(context)..getStudentSglDetail();
            Navigator.pop(context);
          }
        },
        child: SafeArea(
            child: SingleChildScrollView(
          child: FormBuilder(
            key: _formKey,
            child: Column(
              children: [
                FormSectionHeader(
                  label: 'General Info',
                  pathPrefix: 'icon_info.svg',
                  padding: 16,
                ),
                SpacingColumn(
                  horizontalPadding: 16,
                  spacing: 14,
                  children: [
                    TextField(
                      controller: dateController,
                      decoration: InputDecoration(enabled: false),
                    ),
                    BlocBuilder<SupervisorsCubit, SupervisorsState>(
                        builder: (context, state) {
                      List<SupervisorModel> _supervisors = [];
                      if (state is FetchSuccess) {
                        _supervisors.clear();
                        _supervisors.addAll(state.supervisors);
                      }
                      return CustomDropdown<SupervisorModel>(
                          errorNotifier: supervisorVal,
                          onSubmit: (text, controller) {
                            if (_supervisors.indexWhere((element) =>
                                    element.fullName?.trim() == text.trim()) ==
                                -1) {
                              controller.clear();
                              supervisorId = '';
                            }
                          },
                          hint: 'Supervisor',
                          onCallback: (pattern) {
                            final temp = _supervisors
                                .where((competence) =>
                                    (competence.fullName ?? 'unknown')
                                        .toLowerCase()
                                        .trim()
                                        .contains(pattern.toLowerCase()))
                                .toList();

                            return pattern.isEmpty ? _supervisors : temp;
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
                    }),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                SectionDivider(),
                FormSectionHeader(
                  label: 'Activity',
                  pathPrefix: 'icon_activity.svg',
                  padding: 16,
                ),
                SpacingColumn(
                  horizontalPadding: 16,
                  spacing: 12,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: InputDateTimeField(
                              action: (d) {},
                              validator: FormBuilderValidators.required(
                                errorText: 'This field is required',
                              ),
                              initialDate: dateController.text.isEmpty
                                  ? DateTime.now()
                                  : Utils.stringToDateTime(dateController.text),
                              controller: startTimeController,
                              hintText: 'Start Time'),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: InputDateTimeField(
                              action: (d) {},
                              validator: FormBuilderValidators.required(
                                errorText: 'This field is required',
                              ),
                              initialDate: dateController.text.isEmpty
                                  ? DateTime.now()
                                  : Utils.stringToDateTime(dateController.text),
                              controller: endTimeController,
                              hintText: 'End Time'),
                        ),
                      ],
                    ),
                    BlocBuilder<SglCstCubit, SglCstState>(
                        builder: (context, state) {
                      List<TopicModel> _topics = [];
                      if (state.topics != null) {
                        _topics.clear();
                        _topics.addAll(state.topics!);
                        if (_topics.isNotEmpty)
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ValueListenableBuilder(
                                valueListenable: topics,
                                builder: (context, value, child) {
                                  return Column(
                                    children: [
                                      for (int i = 0;
                                          i < value.length;
                                          i++) ...[
                                        CustomDropdown<TopicModel>(
                                          errorNotifier: topicVal,
                                          onSubmit: (text, controller) {
                                            if (_topics.indexWhere((element) =>
                                                    element.name?.trim() ==
                                                    text.trim()) ==
                                                -1) {
                                              controller.clear();
                                              topics.value[i] = -1;
                                            }
                                          },
                                          hint: 'Topics',
                                          onCallback: (pattern) {
                                            final temp = _topics
                                                .where((competence) =>
                                                    (competence.name ??
                                                            'unknown')
                                                        .toLowerCase()
                                                        .trim()
                                                        .contains(pattern
                                                            .toLowerCase()))
                                                .toList();

                                            return pattern.isEmpty
                                                ? _topics
                                                : temp;
                                          },
                                          child: (suggestion) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 12.0,
                                                vertical: 16,
                                              ),
                                              child:
                                                  Text(suggestion?.name ?? ''),
                                            );
                                          },
                                          onItemSelect: (v, controller) {
                                            print(v);
                                            if (v != null) {
                                              topics.value[i] = v.id!;
                                              controller.text = v.name!;
                                            }
                                          },
                                        ),
                                      ],
                                    ],
                                  );
                                },
                              ),
                            ],
                          );
                        return SizedBox.shrink();
                      }
                      return CircularProgressIndicator();
                    }),
                    TextFormField(
                      maxLines: 4,
                      minLines: 4,
                      controller: noteController,
                      decoration: InputDecoration(
                        label: Text(
                          'Additional notes',
                        ),
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
                    onPressed: onSubmit,
                    child: Text('Submit'),
                  ).fullWidth(),
                ),
                SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }

  void onSubmit() {
    FocusScope.of(context).unfocus();
    supervisorVal.value = supervisorId == null
        ? 'This field is required, please select again.'
        : null;
    topicVal.value = topics.value.first == -1
        ? 'This Field is required, please check agian.'
        : null;
    if (_formKey.currentState!.saveAndValidate() &&
        supervisorId != null &&
        topics.value.isNotEmpty) {
      showDialog(
        context: context,
        barrierLabel: '',
        barrierDismissible: false,
        builder: (_) => VerifyDialog(
          onTap: () {
            final date = Utils.stringToDateTime(dateController.text);
            final start = startTimeController.text.split(':');
            final end = endTimeController.text.split(':');
            final startTime = DateTime(date.year, date.month, date.day,
                int.parse(start[0]), int.parse(start[1]));
            final endTime = DateTime(date.year, date.month, date.day,
                int.parse(end[0]), int.parse(end[1]));
            BlocProvider.of<SglCstCubit>(context)
              ..uploadSgl(
                model: SglCstPostModel(
                  supervisorId: supervisorId,
                  topicId:
                      topics.value.where((element) => element != -1).toList(),
                  startTime: startTime.millisecondsSinceEpoch ~/ 1000,
                  endTime: endTime.millisecondsSinceEpoch ~/ 1000,
                ),
              );
            Navigator.pop(context);
          },
        ),
      );
    }
  }
}
