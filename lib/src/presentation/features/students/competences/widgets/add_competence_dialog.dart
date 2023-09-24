import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/data/models/competences/case_post_model.dart';
import 'package:elogbook/src/data/models/competences/list_student_cases_model.dart';
import 'package:elogbook/src/data/models/competences/list_student_skills_model.dart';
import 'package:elogbook/src/data/models/competences/skill_post_model.dart';
import 'package:elogbook/src/data/models/supervisors/supervisor_model.dart';
import 'package:elogbook/src/presentation/blocs/competence_cubit/competence_cubit.dart';
import 'package:elogbook/src/presentation/blocs/supervisor_cubit/supervisors_cubit.dart';
import 'package:elogbook/src/presentation/widgets/inputs/custom_dropdown.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:elogbook/src/presentation/widgets/verify_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

enum CompetenceType {
  caseType,
  skillType,
}

class AddCompetenceDialog extends StatefulWidget {
  final CompetenceType type;
  final String unitId;
  const AddCompetenceDialog(
      {super.key, required this.type, required this.unitId});

  @override
  State<AddCompetenceDialog> createState() => _AddTopicDialogState();
}

class _AddTopicDialogState extends State<AddCompetenceDialog> {
  int? caseId;
  String? desc;
  String? supervisorId;
  final ValueNotifier<String?> supervisorVal = ValueNotifier(null);
  final ValueNotifier<String?> competenceVal = ValueNotifier(null);
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    if (widget.type == CompetenceType.caseType) {
      BlocProvider.of<CompetenceCubit>(context)
        ..getStudentCases(unitId: widget.unitId);
    } else {
      BlocProvider.of<CompetenceCubit>(context)
        ..getStudentSkills(unitId: widget.unitId);
    }
    BlocProvider.of<SupervisorsCubit>(context, listen: false)
      ..getAllSupervisors();
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
          BlocProvider.of<CompetenceCubit>(context)..getListCases();
          Navigator.pop(context);
        }
        if (state.isSkillSuccessAdded) {
          BlocProvider.of<CompetenceCubit>(context)..getListSkills();

          Navigator.pop(context);
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
                    SizedBox(
                      width: 44,
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                SpacingColumn(
                  horizontalPadding: 16,
                  spacing: 12,
                  children: [
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
                    if (widget.type == CompetenceType.skillType)
                      BlocBuilder<CompetenceCubit, CompetenceState>(
                        builder: (context, state) {
                          List<StudentSkillModel> _competences = [];
                          if (state.studentSkillsModel != null) {
                            _competences.clear();
                            _competences.addAll(state.studentSkillsModel!);
                            return CustomDropdown<dynamic>(
                         
                                errorNotifier: competenceVal,
                                onSubmit: (text, controller) {
                                  if (_competences.indexWhere((element) =>
                                          element.name?.trim() ==
                                          text.trim()) ==
                                      -1) {
                                    controller.clear();
                                    caseId = null;
                                  }
                                },
                                hint: 'Skills',
                                onCallback: (pattern) {
                                  final temp = _competences
                                      .where((competence) =>
                                          (competence.name ?? '')
                                              .toLowerCase()
                                              .trim()
                                              .contains(pattern.toLowerCase()))
                                      .toList();

                                  return pattern.isEmpty ? _competences : temp;
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
                          return CircularProgressIndicator();
                        },
                      )
                    else
                      BlocBuilder<CompetenceCubit, CompetenceState>(
                        builder: (context, state) {
                          List<StudentCaseModel> _competences = [];
                          if (state.studentCasesModel != null) {
                            _competences.clear();
                            _competences.addAll(state.studentCasesModel!);
                            return CustomDropdown<dynamic>(
                             
                                errorNotifier: competenceVal,
                                onSubmit: (text, controller) {
                                  if (_competences.indexWhere((element) =>
                                          element.name?.trim() ==
                                          text.trim()) ==
                                      -1) {
                                    controller.clear();
                                    caseId = null;
                                  }
                                },
                                hint: 'Cases',
                                onCallback: (pattern) {
                                  final temp = _competences
                                      .where((competence) =>
                                          (competence.name ?? '')
                                              .toLowerCase()
                                              .trim()
                                              .contains(pattern.toLowerCase()))
                                      .toList();

                                  return pattern.isEmpty ? _competences : temp;
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
                          return CircularProgressIndicator();
                        },
                      ),
                    Builder(
                      builder: (context) {
                        List<String> _desc = [];
                        if (widget.type == CompetenceType.caseType) {
                          _desc.clear();
                          _desc.addAll(['DISCUSSED', 'OBTAINED']);
                        } else {
                          _desc.clear();
                          _desc.addAll(['OBSERVER', 'PERFORM']);
                        }

                        return DropdownButtonFormField(
                          isExpanded: true,
                          hint: Text('Type'),
                          validator: FormBuilderValidators.required(
                            errorText: 'This field is required',
                          ),
                          items: _desc
                              .map(
                                (e) => DropdownMenuItem(
                                  child: Text(e),
                                  value: e,
                                ),
                              )
                              .toList(),
                          onChanged: (v) {
                            if (v != null) {
                              desc = v;
                            }
                          },
                          value: null,
                        );
                      },
                    )
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
                    BlocProvider.of<CompetenceCubit>(context)
                      ..uploadNewCase(
                          model: CasePostModel(
                              caseTypeId: caseId,
                              type: desc,
                              supervisorId: supervisorId));
                  } else {
                    BlocProvider.of<CompetenceCubit>(context)
                      ..uploadNewSkills(
                          model: SkillPostModel(
                              skillTypeId: caseId,
                              type: desc,
                              supervisorId: supervisorId));
                  }
                  Navigator.pop(context);
                },
              ));
    }
  }
}
