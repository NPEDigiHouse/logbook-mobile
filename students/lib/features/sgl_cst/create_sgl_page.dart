import 'package:core/context/navigation_extension.dart';
import 'package:core/helpers/utils.dart';
import 'package:data/models/sglcst/sglcst_post_model.dart';
import 'package:data/models/sglcst/topic_model.dart';
import 'package:data/models/supervisors/supervisor_model.dart';
import 'package:data/models/units/active_unit_model.dart';
import 'package:data/repository/repository_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:main/blocs/clinical_record_cubit/clinical_record_cubit.dart';
import 'package:main/blocs/sgl_cst_cubit/sgl_cst_cubit.dart';
import 'package:main/blocs/supervisor_cubit/supervisors_cubit.dart';
import 'package:main/helpers/helper.dart';
import 'package:main/widgets/dividers/section_divider.dart';
import 'package:main/widgets/headers/form_section_header.dart';
import 'package:main/widgets/inputs/custom_dropdown.dart';
import 'package:main/widgets/inputs/input_date_time_field.dart';
import 'package:main/widgets/spacing_column.dart';
import 'package:main/widgets/verify_dialog.dart';

class CreateSglPage extends StatefulWidget {
  final ActiveDepartmentModel model;
  final DateTime date;
  const CreateSglPage({super.key, required this.model, required this.date});

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
    if (RepositoryData.supervisors.isEmpty) {
      BlocProvider.of<SupervisorsCubit>(context, listen: false)
          .getAllSupervisors();
    }
    if (RepositoryData.sglTopics.isEmpty) {
      BlocProvider.of<SglCstCubit>(context, listen: false)
          .getTopicsByDepartmentId(unitId: widget.model.unitId!);
    }
    dateController.text = Utils.datetimeToString(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New SGL"),
      ).variant(),
      body: BlocListener<SglCstCubit, SglCstState>(
        listener: (context, state) {
          if (state.isSglPostSuccess) {
            Navigator.pop(context);
          }
        },
        child: SafeArea(
            child: SingleChildScrollView(
          child: FormBuilder(
            key: _formKey,
            child: Column(
              children: [
                const FormSectionHeader(
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
                      decoration: const InputDecoration(
                          enabled: false, labelText: 'Date Created'),
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
                          RepositoryData.supervisors.addAll(state.supervisors);
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
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                const SectionDivider(),
                const FormSectionHeader(
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
                        const SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: InputDateTimeField(
                              validator: (data) {
                                if (data == null || data.toString().isEmpty) {
                                  return 'This field is required';
                                }
                                if (Utils.stringTimeToDateTime(
                                        widget.date, startTimeController.text)
                                    .isAfter(Utils.stringTimeToDateTime(
                                        widget.date, data))) {
                                  return 'end data cannot be before the start date';
                                }
                                return null;
                              },
                              action: (d) {},
                              initialDate: dateController.text.isEmpty
                                  ? DateTime.now()
                                  : Utils.stringToDateTime(dateController.text),
                              controller: endTimeController,
                              hintText: 'End Time'),
                        ),
                      ],
                    ),
                    if (RepositoryData.sglTopics.isNotEmpty)
                      CustomDropdown<TopicModel>(
                          errorNotifier: topicVal,
                          onSubmit: (text, controller) {
                            if (RepositoryData.sglTopics.indexWhere((element) =>
                                    element.name?.trim() == text.trim()) ==
                                -1) {
                              controller.clear();
                              topics.value[0] = -1;
                            }
                          },
                          hint: 'Topics',
                          onCallback: (pattern) {
                            final temp = RepositoryData.sglTopics
                                .where((competence) =>
                                    (competence.name ?? 'unknown')
                                        .toLowerCase()
                                        .trim()
                                        .contains(pattern.toLowerCase()))
                                .toList();

                            return pattern.isEmpty
                                ? RepositoryData.sglTopics
                                : temp;
                          },
                          child: (suggestion) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                                vertical: 16,
                              ),
                              child: Text(suggestion?.name ?? ''),
                            );
                          },
                          onItemSelect: (v, controller) {
                            if (v != null) {
                              topics.value[0] = v.id!;
                              controller.text = v.name!;
                            }
                          })
                    else
                      BlocBuilder<SglCstCubit, SglCstState>(
                          builder: (context, state) {
                        if (state.topics != null) {
                          RepositoryData.sglTopics.clear();
                          RepositoryData.sglTopics.addAll(
                              ParseHelper.filterTopic(
                                  listData: state.topics!, isSGL: true));
                          if (RepositoryData.sglTopics.isNotEmpty) {
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
                                                if (RepositoryData.sglTopics
                                                        .indexWhere((element) =>
                                                            element.name
                                                                ?.trim() ==
                                                            text.trim()) ==
                                                    -1) {
                                                  controller.clear();
                                                  topics.value[i] = -1;
                                                }
                                              },
                                              hint: 'Topics',
                                              onCallback: (pattern) {
                                                final temp = RepositoryData
                                                    .sglTopics
                                                    .where((competence) =>
                                                        (competence.name ??
                                                                'unknown')
                                                            .toLowerCase()
                                                            .trim()
                                                            .contains(pattern
                                                                .toLowerCase()))
                                                    .toList();

                                                return pattern.isEmpty
                                                    ? RepositoryData.sglTopics
                                                    : temp;
                                              },
                                              child: (suggestion) {
                                                return Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 12.0,
                                                    vertical: 16,
                                                  ),
                                                  child: Text(
                                                      suggestion?.name ?? ''),
                                                );
                                              },
                                              onItemSelect: (v, controller) {
                                                if (v != null) {
                                                  topics.value[i] = v.id!;
                                                  controller.text = v.name!;
                                                }
                                              }),
                                          // SizedBox(
                                          //   height: 12,
                                          // )
                                        ],
                                      ],
                                    );
                                  },
                                ),
                              ],
                            );
                          }
                          return const SizedBox.shrink();
                        }
                        return const CircularProgressIndicator();
                      }),
                    TextFormField(
                      maxLines: 4,
                      minLines: 4,
                      maxLength: 500,
                      controller: noteController,
                      decoration: const InputDecoration(
                        label: Text(
                          'Additional notes',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                BlocSelector<SglCstCubit, SglCstState, bool>(
                  selector: (state) =>
                      state.createState == RequestState.loading,
                  builder: (context, isLoading) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: FilledButton(
                        onPressed: isLoading ? null : onSubmit,
                        child: const Text('Submit'),
                      ).fullWidth(),
                    );
                  },
                ),
                const SizedBox(
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
            BlocProvider.of<SglCstCubit>(context).uploadSgl(
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
