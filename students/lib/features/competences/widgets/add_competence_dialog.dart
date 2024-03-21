import 'package:core/context/navigation_extension.dart';
import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:data/models/competences/case_post_model.dart';
import 'package:data/models/competences/skill_post_model.dart';
import 'package:data/models/supervisors/supervisor_model.dart';
import 'package:data/repository/repository_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:main/blocs/clinical_record_cubit/clinical_record_cubit.dart';
import 'package:main/blocs/competence_cubit/competence_cubit.dart';
import 'package:main/blocs/supervisor_cubit/supervisors_cubit.dart';
import 'package:main/widgets/custom_alert.dart';
import 'package:main/widgets/inputs/custom_dropdown.dart';
import 'package:main/widgets/spacing_column.dart';
import 'package:main/widgets/verify_dialog.dart';

enum CompetenceType {
  caseType,
  skillType,
}

class AddCompetenceDialog extends StatefulWidget {
  final CompetenceType type;
  final String unitId;
  final VoidCallback onAddUpdate;

  const AddCompetenceDialog(
      {super.key,
      required this.type,
      required this.unitId,
      required this.onAddUpdate});

  @override
  State<AddCompetenceDialog> createState() => _AddTopicDialogState();
}

class _AddTopicDialogState extends State<AddCompetenceDialog> {
  int? caseId;
  String? descSelect;
  String? supervisorId;
  final ValueNotifier<String?> supervisorVal = ValueNotifier(null);
  final ValueNotifier<String?> competenceVal = ValueNotifier(null);
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    if (widget.type == CompetenceType.caseType) {
      if (RepositoryData.cases.isEmpty) {
        BlocProvider.of<CompetenceCubit>(context)
            .getStudentCases(unitId: widget.unitId);
      }
    } else {
      if (RepositoryData.skills.isEmpty) {
        BlocProvider.of<CompetenceCubit>(context)
            .getStudentSkills(unitId: widget.unitId);
      }
    }
    if (RepositoryData.supervisors.isEmpty) {
      BlocProvider.of<SupervisorsCubit>(context, listen: false)
          .getAllSupervisors();
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CompetenceCubit, CompetenceState>(
      listener: (context, state) {
        if (state.isCaseSuccessAdded) {
          CustomAlert.success(
              message: "Success create new case", context: context);
          widget.onAddUpdate.call();
        }
        if (state.isSkillSuccessAdded) {
          CustomAlert.success(
              message: "Success create new skills", context: context);
          widget.onAddUpdate.call();
        }
      },
      child: Dialog(
        elevation: 0,
        insetPadding: const EdgeInsets.symmetric(
          horizontal: 36.0,
          vertical: 24.0,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: SingleChildScrollView(
          child: FormBuilder(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 8, left: 4),
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.close_rounded,
                          color: onFormDisableColor,
                        ),
                        tooltip: 'Close',
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              widget.type == CompetenceType.caseType
                                  ? 'Add Cases'
                                  : 'Add Skills',
                              textAlign: TextAlign.center,
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 44,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                SpacingColumn(
                  horizontalPadding: 16,
                  spacing: 12,
                  children: [
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
                    if (widget.type == CompetenceType.skillType)
                      if (RepositoryData.skills.isNotEmpty)
                        CustomDropdown<dynamic>(
                            errorNotifier: competenceVal,
                            onSubmit: (text, controller) {
                              if (RepositoryData.skills.indexWhere((element) =>
                                      element.name?.trim() == text.trim()) ==
                                  -1) {
                                controller.clear();
                                caseId = null;
                              }
                            },
                            hint: 'Skills',
                            onCallback: (pattern) {
                              final temp = RepositoryData.skills
                                  .where((competence) => (competence.name ?? '')
                                      .toLowerCase()
                                      .trim()
                                      .contains(pattern.toLowerCase()))
                                  .toList();

                              return pattern.isEmpty
                                  ? RepositoryData.skills
                                  : temp;
                            },
                            child: (suggestion) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0,
                                  vertical: 16,
                                ),
                                child: Text(suggestion.name),
                              );
                            },
                            onItemSelect: (v, controller) {
                              if (v != null) {
                                caseId = v.id;
                                controller.text = v.name!;
                              }
                            })
                      else
                        BlocBuilder<CompetenceCubit, CompetenceState>(
                          builder: (context, state) {
                            if (state.studentSkillsModel != null) {
                              RepositoryData.skills.clear();
                              RepositoryData.skills
                                  .addAll(state.studentSkillsModel!);
                              return CustomDropdown<dynamic>(
                                  errorNotifier: competenceVal,
                                  onSubmit: (text, controller) {
                                    if (RepositoryData.skills.indexWhere(
                                            (element) =>
                                                element.name?.trim() ==
                                                text.trim()) ==
                                        -1) {
                                      controller.clear();
                                      caseId = null;
                                    }
                                  },
                                  hint: 'Skills',
                                  onCallback: (pattern) {
                                    final temp = RepositoryData.skills
                                        .where((competence) => (competence
                                                    .name ??
                                                '')
                                            .toLowerCase()
                                            .trim()
                                            .contains(pattern.toLowerCase()))
                                        .toList();

                                    return pattern.isEmpty
                                        ? RepositoryData.skills
                                        : temp;
                                  },
                                  child: (suggestion) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0,
                                        vertical: 16,
                                      ),
                                      child: Text(suggestion.name),
                                    );
                                  },
                                  onItemSelect: (v, controller) {
                                    if (v != null) {
                                      caseId = v.id;
                                      controller.text = v.name!;
                                    }
                                  });
                            }
                            return const CircularProgressIndicator();
                          },
                        )
                    else if (RepositoryData.cases.isNotEmpty)
                      CustomDropdown<dynamic>(
                          errorNotifier: competenceVal,
                          onSubmit: (text, controller) {
                            if (RepositoryData.cases.indexWhere((element) =>
                                    element.name?.trim() == text.trim()) ==
                                -1) {
                              controller.clear();
                              caseId = null;
                            }
                          },
                          hint: 'Cases',
                          onCallback: (pattern) {
                            final temp = RepositoryData.cases
                                .where((competence) => (competence.name ?? '')
                                    .toLowerCase()
                                    .trim()
                                    .contains(pattern.toLowerCase()))
                                .toList();

                            return pattern.isEmpty
                                ? RepositoryData.cases
                                : temp;
                          },
                          child: (suggestion) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                                vertical: 16,
                              ),
                              child: Text(suggestion.name),
                            );
                          },
                          onItemSelect: (v, controller) {
                            if (v != null) {
                              caseId = v.id;
                              controller.text = v.name!;
                            }
                          })
                    else
                      BlocBuilder<CompetenceCubit, CompetenceState>(
                        builder: (context, state) {
                          if (state.studentCasesModel != null) {
                            RepositoryData.cases.clear();
                            RepositoryData.cases
                                .addAll(state.studentCasesModel!);
                            return CustomDropdown<dynamic>(
                                errorNotifier: competenceVal,
                                onSubmit: (text, controller) {
                                  if (RepositoryData.cases.indexWhere(
                                          (element) =>
                                              element.name?.trim() ==
                                              text.trim()) ==
                                      -1) {
                                    controller.clear();
                                    caseId = null;
                                  }
                                },
                                hint: 'Cases',
                                onCallback: (pattern) {
                                  final temp = RepositoryData.cases
                                      .where((competence) =>
                                          (competence.name ?? '')
                                              .toLowerCase()
                                              .trim()
                                              .contains(pattern.toLowerCase()))
                                      .toList();

                                  return pattern.isEmpty
                                      ? RepositoryData.cases
                                      : temp;
                                },
                                child: (suggestion) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0,
                                      vertical: 16,
                                    ),
                                    child: Text(suggestion.name),
                                  );
                                },
                                onItemSelect: (v, controller) {
                                  if (v != null) {
                                    caseId = v.id;
                                    controller.text = v.name!;
                                  }
                                });
                          }
                          return const CircularProgressIndicator();
                        },
                      ),
                    Builder(
                      builder: (context) {
                        List<String> desc = [];
                        if (widget.type == CompetenceType.caseType) {
                          desc.clear();
                          desc.addAll(['DISCUSSED', 'OBTAINED']);
                        } else {
                          desc.clear();
                          desc.addAll(['OBSERVER', 'PERFORM']);
                        }

                        return DropdownButtonFormField(
                          isExpanded: true,
                          hint: const Text('Type'),
                          validator: FormBuilderValidators.required(
                            errorText: 'This field is required',
                          ),
                          decoration: const InputDecoration(
                              label: Text('Type (Required)')),
                          items: desc
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e),
                                ),
                              )
                              .toList(),
                          onChanged: (v) {
                            if (v != null) {
                              descSelect = v;
                            }
                          },
                          value: null,
                        );
                      },
                    )
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: BlocSelector<CompetenceCubit, CompetenceState, bool>(
                    selector: (state) =>
                        state.caseState == RequestState.loading ||
                        state.skillState == RequestState.loading,
                    builder: (context, isLoading) {
                      return FilledButton(
                        onPressed: isLoading ? null : onSubmit,
                        child: const Text('Submit'),
                      ).fullWidth();
                    },
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onSubmit() {
    FocusScope.of(context).unfocus();
    supervisorVal.value = supervisorId == null
        ? 'This field is required, please select again.'
        : null;
    competenceVal.value =
        caseId == null ? 'This field is required, please select again.' : null;
    if (_formKey.currentState!.saveAndValidate() &&
        supervisorId != null &&
        supervisorId!.isNotEmpty &&
        caseId != null) {
      showDialog(
          context: context,
          barrierLabel: '',
          barrierDismissible: false,
          builder: (_) => VerifyDialog(
                onTap: () {
                  if (widget.type == CompetenceType.caseType) {
                    BlocProvider.of<CompetenceCubit>(context).uploadNewCase(
                        model: CasePostModel(
                            caseTypeId: caseId,
                            type: descSelect,
                            supervisorId: supervisorId));
                  } else {
                    BlocProvider.of<CompetenceCubit>(context).uploadNewSkills(
                        model: SkillPostModel(
                            skillTypeId: caseId,
                            type: descSelect,
                            supervisorId: supervisorId));
                  }
                  Navigator.pop(context);
                },
              ));
    }
  }
}
