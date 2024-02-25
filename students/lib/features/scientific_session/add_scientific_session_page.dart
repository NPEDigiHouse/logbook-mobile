// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'package:common/features/file/file_management.dart';
import 'package:core/context/navigation_extension.dart';
import 'package:core/styles/color_palette.dart';
import 'package:data/models/scientific_session/scientific_roles.dart';
import 'package:data/models/scientific_session/scientific_session_detail_model.dart';
import 'package:data/models/scientific_session/scientific_session_post_model.dart';
import 'package:data/models/scientific_session/session_types_model.dart';
import 'package:data/models/supervisors/supervisor_model.dart';
import 'package:data/models/units/active_unit_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:main/blocs/clinical_record_cubit/clinical_record_cubit.dart';
import 'package:main/blocs/scientific_session_cubit/scientific_session_cubit.dart';
import 'package:main/blocs/scientific_session_supervisor_cubit/scientific_session_supervisor_cubit.dart';
import 'package:main/blocs/student_cubit/student_cubit.dart';
import 'package:main/blocs/supervisor_cubit/supervisors_cubit.dart';
import 'package:main/widgets/dividers/section_divider.dart';
import 'package:main/widgets/headers/form_section_header.dart';
import 'package:main/widgets/inkwell_container.dart';
import 'package:main/widgets/inputs/build_text_field.dart';
import 'package:main/widgets/inputs/custom_dropdown.dart';
import 'package:main/widgets/spacing_column.dart';
import 'package:main/widgets/verify_dialog.dart';
import 'package:path/path.dart' as path;

class AddScientificSessionPage extends StatefulWidget {
  final ActiveDepartmentModel activeDepartmentModel;
  final ScientificSessionDetailModel? detail;

  const AddScientificSessionPage({
    super.key,
    required this.activeDepartmentModel,
    this.detail,
  });

  @override
  State<AddScientificSessionPage> createState() =>
      _AddScientificSessionPageState();
}

class _AddScientificSessionPageState extends State<AddScientificSessionPage> {
  String? supervisorId;
  int role = -1;
  final _formKey = GlobalKey<FormBuilderState>();
  int sesionType = -1;
  final topicController = TextEditingController();
  final titleController = TextEditingController();
  final referenceController = TextEditingController();
  final additionalNotesController = TextEditingController();
  ValueNotifier<String?> supervisorValue = ValueNotifier(null);
  final List<ScientificRoles> _roles = [];
  final List<SessionTypesModel> _sessionTypes = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      BlocProvider.of<SupervisorsCubit>(context, listen: false)
          .getAllSupervisors();
      BlocProvider.of<ScientificSessionCubit>(context)
        ..getListSessionTypes()
        ..getScientificSessionRoles();
    });

    if (widget.detail != null) {
      supervisorId = widget.detail?.supervisorId;
      role = widget.detail?.roleId ?? -1;
      sesionType = widget.detail?.sessionTypeId ?? -1;
      titleController.text = widget.detail?.title ?? '';
      topicController.text = widget.detail?.topic ?? '';
      referenceController.text = widget.detail?.reference ?? '';
      additionalNotesController.text = widget.detail?.note ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Scientific Session"),
      ).variant(),
      body: BlocConsumer<ScientificSessionCubit, ScientifcSessionState>(
        listener: (context, state) {
          if (state.postSuccess) {
            BlocProvider.of<StudentCubit>(context)
                .getStudentScientificSessionOfActiveDepartment();
            BlocProvider.of<ScientificSessionCubit>(context).reset();
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          if (state.listSessionTypes != null) {
            _sessionTypes.clear();
            _sessionTypes.addAll(state.listSessionTypes!);
          }
          if (state.scientificRoles != null) {
            _roles.clear();
            _roles.addAll(state.scientificRoles!);
          }
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 20),
              child: FormBuilder(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 16,
                    ),
                    const FormSectionHeader(
                      label: 'General Info',
                      pathPrefix: 'icon_info.svg',
                      padding: 16,
                    ),
                    SpacingColumn(
                      horizontalPadding: 16,
                      spacing: 14,
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            label: Text('Date'),
                            enabled: false,
                          ),
                          initialValue: '02/20/2023 23:11:26',
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            label: Text('Department'),
                            enabled: false,
                          ),
                          initialValue: widget.activeDepartmentModel.unitName,
                        ),
                        BlocBuilder<SupervisorsCubit, SupervisorsState>(
                            builder: (context, state) {
                          List<SupervisorModel> supervisors = [];
                          if (state is SupervisorFetchSuccess) {
                            supervisors.clear();
                            supervisors.addAll(state.supervisors);
                            return CustomDropdown<SupervisorModel>(
                                errorNotifier: supervisorValue,
                                onSubmit: (text, controller) {
                                  if (supervisors.indexWhere((element) =>
                                          element.fullName?.trim() ==
                                          text.trim()) ==
                                      -1) {
                                    controller.clear();
                                    supervisorId = '';
                                  }
                                },
                                hint: 'Supervisor',
                                init: widget.detail?.supervisorName,
                                onCallback: (pattern) {
                                  final temp = supervisors
                                      .where((competence) =>
                                          (competence.fullName ?? 'unknown')
                                              .toLowerCase()
                                              .trim()
                                              .contains(pattern.toLowerCase()))
                                      .toList();

                                  return pattern.isEmpty ? supervisors : temp;
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
                      label: 'Scientific Session',
                      pathPrefix: 'biotech_rounded.svg',
                      padding: 16,
                    ),
                    SpacingColumn(
                      horizontalPadding: 16,
                      spacing: 14,
                      children: [
                        DropdownButtonFormField(
                          validator: FormBuilderValidators.required(
                            errorText: 'This field is required',
                          ),
                          isExpanded: true,
                          hint: const Text('Session Type'),
                          items: _sessionTypes
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e.name!),
                                ),
                              )
                              .toList(),
                          onChanged: (v) {
                            if (v != null) sesionType = v.id!;
                          },
                          value: sesionType != -1 && _sessionTypes.isNotEmpty
                              ? _sessionTypes.firstWhere(
                                  (element) => element.id == sesionType)
                              : null,
                        ),
                        BuildTextField(
                          onChanged: (v) {},
                          label: 'Title',
                          controller: titleController,
                          validator: FormBuilderValidators.required(
                            errorText: 'This field is required',
                          ),
                        ),
                        BuildTextField(
                          onChanged: (v) {},
                          label: 'Topics',
                          controller: topicController,
                          validator: FormBuilderValidators.required(
                            errorText: 'This field is required',
                          ),
                        ),
                        BuildTextField(
                          onChanged: (v) {},
                          label: 'Reference',
                          controller: referenceController,
                        ),
                        DropdownButtonFormField(
                          isExpanded: true,
                          hint: const Text('Role'),
                          validator: FormBuilderValidators.required(
                            errorText: 'This field is required',
                          ),
                          items: _roles
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e.name!),
                                ),
                              )
                              .toList(),
                          onChanged: (v) {
                            if (v != null) role = v.id!;
                          },
                          value: role != -1
                              ? _roles
                                  .firstWhere((element) => element.id == role)
                              : null,
                        ),
                        InkWellContainer(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 24),
                          radius: 12,
                          color: const Color(0xFF29C5F6).withOpacity(.2),
                          onTap: () => FileManagement.uploadFile(
                            context,
                            (path) {
                              BlocProvider.of<ScientificSessionCubit>(context)
                                  .uploadAttachment(path: path);
                            },
                          ),
                          child: Row(
                            children: [
                              if (state.attachState == RequestState.init) ...[
                                SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: IconButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              primaryColor),
                                    ),
                                    padding: const EdgeInsets.all(0.0),
                                    iconSize: 14,
                                    onPressed: () => FileManagement.uploadFile(
                                      context,
                                      (path) {
                                        BlocProvider.of<ScientificSessionCubit>(
                                                context)
                                            .uploadAttachment(path: path);
                                      },
                                    ),
                                    icon: const Icon(
                                      Icons.add_rounded,
                                      color: backgroundColor,
                                      size: 16,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                const Text('Upload image or PDF'),
                                const Spacer(),
                                const Text('(max. 5 MB)')
                              ],
                              if (state.attachState == RequestState.loading)
                                const Expanded(
                                    child:
                                        Center(child: Text('Processing...'))),
                              if (state.attachment != null &&
                                  state.attachState == RequestState.data) ...[
                                Expanded(
                                  child: Text(
                                    path.basename(state.attachment!),
                                    maxLines: 1,
                                  ),
                                ),
                                SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: InkWell(
                                    onTap: () {
                                      BlocProvider.of<ScientificSessionCubit>(
                                              context)
                                          .resetAttachment();
                                    },
                                    child: const Center(
                                        child: Icon(Icons.close_rounded)),
                                  ),
                                )
                              ],
                            ],
                          ),
                        ),
                        TextFormField(
                          maxLines: 5,
                          minLines: 5,
                          controller: additionalNotesController,
                          decoration: const InputDecoration(
                            label: Text('Additional Notes'),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        BlocSelector<ScientificSessionCubit,
                            ScientifcSessionState, bool>(
                          selector: (state) =>
                              state.createState == RequestState.loading,
                          builder: (context, isLoading) {
                            return FilledButton(
                              onPressed: isLoading
                                  ? null
                                  : () => onSubmit(state.attachment),
                              child: const Text('Submit'),
                            ).fullWidth();
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void onSubmit(String? attachment) {
    FocusScope.of(context).unfocus();
    supervisorValue.value = supervisorId == null
        ? 'This field is required, please select again.'
        : null;
    if (_formKey.currentState!.saveAndValidate() && supervisorId != null) {
      showDialog(
          context: context,
          barrierLabel: '',
          barrierDismissible: false,
          builder: (_) => VerifyDialog(
                onTap: () {
                  if (widget.detail != null) {
                    BlocProvider.of<ScientificSessionCubit>(context,
                            listen: false)
                        .updateScientificSession(
                      model: ScientificSessionPostModel(
                        attachment: attachment,
                        role: role,
                        id: widget.detail!.id,
                        title: titleController.text,
                        topic: topicController.text,
                        reference: referenceController.text,
                        sessionType: sesionType,
                        supervisorId: supervisorId,
                        notes: additionalNotesController.text.isEmpty
                            ? null
                            : additionalNotesController.text,
                      ),
                    );
                    BlocProvider.of<ScientificSessionSupervisorCubit>(context)
                        .getScientificSessionDetail(id: widget.detail!.id!);
                  } else {
                    BlocProvider.of<ScientificSessionCubit>(context,
                            listen: false)
                        .uploadScientificSession(
                      model: ScientificSessionPostModel(
                        attachment: attachment,
                        role: role,
                        title: titleController.text,
                        topic: topicController.text,
                        reference: referenceController.text,
                        sessionType: sesionType,
                        supervisorId: supervisorId,
                        notes: additionalNotesController.text.isEmpty
                            ? null
                            : additionalNotesController.text,
                      ),
                    );
                  }

                  Navigator.pop(context);
                },
              ));
    }
  }
}
