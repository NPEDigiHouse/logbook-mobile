import 'package:core/helpers/utils.dart';
import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:data/models/activity/activity_model.dart';
import 'package:data/models/students/student_profile_post.dart';
import 'package:data/models/supervisors/supervisor_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main/blocs/activity_cubit/activity_cubit.dart';
import 'package:main/blocs/profile_cubit/profile_cubit.dart';
import 'package:main/blocs/student_cubit/student_cubit.dart';
import 'package:main/blocs/supervisor_cubit/supervisors_cubit.dart';
import 'package:main/widgets/inputs/custom_dropdown.dart';
import 'package:main/widgets/inputs/input_date_field.dart';
import 'personal_data_field.dart';
import 'personal_data_text_field.dart';

class PersonalDataForm extends StatefulWidget {
  final String title;
  final Map<String, String?> dataMap;
  final int section;

  const PersonalDataForm({
    super.key,
    required this.title,
    required this.dataMap,
    required this.section,
  });

  @override
  State<PersonalDataForm> createState() => _PersonalDataFormState();
}

class _PersonalDataFormState extends State<PersonalDataForm> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ValueNotifier<String?> supervisorVal = ValueNotifier(null);
  final List<TextEditingController> editingControllers = [];

  late final ValueNotifier<Map<String, String?>> formNotifier;
  late final ValueNotifier<bool> isEditNotifier;

  @override
  void initState() {
    formNotifier = ValueNotifier({});
    isEditNotifier = ValueNotifier(false);
    for (var i = 0; i < widget.dataMap.length; i++) {
      editingControllers.add(TextEditingController());
    }
    if (widget.section == 3) {
      BlocProvider.of<SupervisorsCubit>(context).getAllSupervisors();
    }
    if (widget.section == 4) {
      BlocProvider.of<ActivityCubit>(context).getActivityLocations();
    }
    super.initState();
  }

  @override
  void dispose() {
    formNotifier.dispose();
    isEditNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final labels = widget.dataMap.keys.toList();
    final values = widget.dataMap.values.toList();

    return ValueListenableBuilder(
      valueListenable: isEditNotifier,
      builder: (context, isEdit, child) {
        return BlocListener<StudentCubit, StudentState>(
          listener: (context, state) {
            if (state.successUpdateStudentProfile) {
              isEditNotifier.value = false;
              BlocProvider.of<UserCubit>(context).getUserCredential();
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                color: onDisableColor,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 4, 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        widget.title,
                        style: textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      ValueListenableBuilder(
                        valueListenable: formNotifier,
                        builder: (context, data, child) {
                          return IconButton(
                            icon: Icon(
                              isEdit ? Icons.check_rounded : Icons.edit_rounded,
                              size: 18,
                            ),
                            onPressed: () {
                              if (isEdit) {
                                formKey.currentState!.save();
                                late StudentProfile data;
                                switch (widget.section) {
                                  case 1:
                                    data = StudentProfile(
                                      clinicId:
                                          editingControllers[1].text.isEmpty
                                              ? null
                                              : editingControllers[1].text,
                                      preclinicId:
                                          editingControllers[2].text.isEmpty
                                              ? null
                                              : editingControllers[2].text,
                                      graduationDate: editingControllers[3]
                                              .text
                                              .isEmpty
                                          ? null
                                          : (Utils.stringToDateTime(
                                                      editingControllers[3]
                                                          .text)
                                                  .millisecondsSinceEpoch) ~/
                                              1000,
                                    );
                                    if (editingControllers[0].text.isNotEmpty) {
                                      BlocProvider.of<UserCubit>(context)
                                          .updateFullName(
                                              fullname:
                                                  editingControllers[0].text);
                                    }
                                    break;
                                  case 2:
                                    data = StudentProfile(
                                      phoneNumber:
                                          editingControllers[0].text.isEmpty
                                              ? null
                                              : editingControllers[0].text,
                                      address:
                                          editingControllers[2].text.isEmpty
                                              ? null
                                              : editingControllers[2].text,
                                    );
                                    break;
                                  case 3:
                                    data = StudentProfile(
                                      academicSupervisor:
                                          editingControllers[0].text.isEmpty
                                              ? null
                                              : editingControllers[0].text,
                                      supervisingDpk:
                                          editingControllers[1].text.isEmpty
                                              ? null
                                              : editingControllers[1].text,
                                      examinerDpk:
                                          editingControllers[2].text.isEmpty
                                              ? null
                                              : editingControllers[2].text,
                                    );
                                    break;
                                  case 4:
                                    data = StudentProfile(
                                      periodLengthStation:
                                          editingControllers[0].text.isEmpty
                                              ? null
                                              : int.parse(
                                                  editingControllers[0].text),
                                      rsStation:
                                          editingControllers[1].text.isEmpty
                                              ? null
                                              : editingControllers[1].text,
                                      pkmStation:
                                          editingControllers[2].text.isEmpty
                                              ? null
                                              : editingControllers[2].text,
                                    );
                                    break;
                                  default:
                                }
                                // Save the data to database
                                BlocProvider.of<StudentCubit>(context)
                                    .updateStudentData(
                                  studentProfile: data,
                                );
                              }
                              if (!isEditNotifier.value) {
                                isEditNotifier.value = true;
                              }
                            },
                            tooltip: isEdit ? 'Save' : 'Edit',
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    for (var i = 0; i < widget.dataMap.length; i++) ...[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                        child: isEdit
                            ? Builder(
                                builder: (context) {
                                  if (widget.section == 1 && i == 3) {
                                    return InputDateField(
                                      action: (v) {
                                        editingControllers[i].text =
                                            Utils.datetimeToString(v);
                                      },
                                      controller: editingControllers[i],
                                      hintText: 'S.Ked Graduation Date',
                                      initialValue: values[i],
                                    );
                                  }

                                  if (widget.section == 3) {
                                    return BlocBuilder<SupervisorsCubit,
                                            SupervisorsState>(
                                        builder: (context, state) {
                                      List<SupervisorModel> supervisors = [];
                                      if (state is FetchSuccess) {
                                        supervisors.clear();
                                        supervisors.addAll(state.supervisors);
                                        if (values[i] != null) {
                                          editingControllers[i].text =
                                              supervisors
                                                  .where((element) =>
                                                      element.fullName ==
                                                      values[i])
                                                  .first
                                                  .id!;
                                        }
                                        return CustomDropdown<SupervisorModel>(
                                            errorNotifier: supervisorVal,
                                            onSubmit: (text, controller) {
                                              if (supervisors.indexWhere(
                                                      (element) =>
                                                          element.fullName
                                                              ?.trim() ==
                                                          text.trim()) ==
                                                  -1) {
                                                controller.clear();
                                                editingControllers[i].text = '';
                                              }
                                            },
                                            init: supervisors
                                                    .map((e) => e.fullName)
                                                    .toList()
                                                    .contains(values[i])
                                                ? supervisors
                                                    .where((element) =>
                                                        element.fullName ==
                                                        values[i])
                                                    .first
                                                    .fullName
                                                : null,
                                            hint: labels[i],
                                            onCallback: (pattern) {
                                              final temp = supervisors
                                                  .where((competence) =>
                                                      (competence.fullName ??
                                                              'unknown')
                                                          .toLowerCase()
                                                          .trim()
                                                          .contains(pattern
                                                              .toLowerCase()))
                                                  .toList();

                                              return pattern.isEmpty
                                                  ? supervisors
                                                  : temp;
                                            },
                                            child: (suggestion) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 12.0,
                                                  vertical: 16,
                                                ),
                                                child: Text(
                                                    suggestion?.fullName ?? ''),
                                              );
                                            },
                                            onItemSelect: (v, controller) {
                                              if (v != null) {
                                                editingControllers[i].text =
                                                    v.id!;
                                                controller.text = v.fullName!;
                                              }
                                            });
                                      }
                                      return const CircularProgressIndicator();
                                    });
                                  }
                                  if (widget.section == 4 && i != 0) {
                                    return BlocBuilder<ActivityCubit,
                                            ActivityState>(
                                        builder: (context, state) {
                                      List<ActivityModel> locations = [];
                                      if (state.activityLocations != null) {
                                        locations.clear();
                                        locations
                                            .addAll(state.activityLocations!);
                                        if (values[i] != null) {
                                          editingControllers[i].text =
                                              locations.indexWhere((element) =>
                                                          element.name ==
                                                          values[i]) !=
                                                      -1
                                                  ? values[i]!
                                                  : '';
                                        }
                                      }
                                      return DropdownButtonFormField(
                                        isExpanded: true,
                                        hint: Text(labels[i]),
                                        items: locations
                                            .map(
                                              (e) => DropdownMenuItem(
                                                value: e,
                                                child: Text(e.name!),
                                              ),
                                            )
                                            .toList(),
                                        onChanged: (v) {
                                          if (v != null) {
                                            editingControllers[i].text =
                                                (v).name!;
                                          }
                                        },
                                        value: locations
                                                .map((e) => e.name)
                                                .toList()
                                                .contains(values[i])
                                            ? locations
                                                .where((element) =>
                                                    element.name == values[i])
                                                .first
                                            : null,
                                      );
                                    });
                                  }
                                  return PersonalDataTextField(
                                    label: labels[i],
                                    value: values[i],
                                    isNumberOnly: widget.section == 4 && i == 0,
                                    isDisable: widget.section == 2 && i == 1,
                                    onSaved: (value) {
                                      formNotifier.value[labels[i]] = value;
                                    },
                                    controller: editingControllers[i],
                                  );
                                },
                              )
                            : PersonalDataField(
                                label: labels[i],
                                value: values[i],
                              ),
                      ),
                    ],
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
