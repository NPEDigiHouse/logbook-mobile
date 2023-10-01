import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/src/data/models/scientific_session/scientific_roles.dart';
import 'package:elogbook/src/data/models/scientific_session/scientific_session_post_model.dart';
import 'package:elogbook/src/data/models/scientific_session/session_types_model.dart';
import 'package:elogbook/src/data/models/supervisors/supervisor_model.dart';
import 'package:elogbook/src/data/models/units/active_unit_model.dart';
import 'package:elogbook/src/presentation/blocs/clinical_record_cubit/clinical_record_cubit.dart';
import 'package:elogbook/src/presentation/blocs/scientific_session_cubit/scientific_session_cubit.dart';
import 'package:elogbook/src/presentation/blocs/student_cubit/student_cubit.dart';
import 'package:elogbook/src/presentation/blocs/supervisor_cubit/supervisors_cubit.dart';
import 'package:elogbook/src/presentation/widgets/custom_alert.dart';
import 'package:elogbook/src/presentation/widgets/dividers/section_divider.dart';
import 'package:elogbook/src/presentation/widgets/headers/form_section_header.dart';
import 'package:elogbook/src/presentation/widgets/inkwell_container.dart';
import 'package:elogbook/src/presentation/widgets/inputs/build_text_field.dart';
import 'package:elogbook/src/presentation/widgets/inputs/custom_dropdown.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:elogbook/src/presentation/widgets/verify_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';

class AddScientificSessionPage extends StatefulWidget {
  final ActiveDepartmentModel activeDepartmentModel;

  const AddScientificSessionPage(
      {super.key, required this.activeDepartmentModel});

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
  List<ScientificRoles> _roles = [];
  List<SessionTypesModel> _sessionTypes = [];

  Future<void> uploadFile(BuildContext context) async {
    final plugin = DeviceInfoPlugin();
    final android = await plugin.androidInfo;

    final status = android.version.sdkInt < 33
        ? await Permission.storage.request()
        : PermissionStatus.granted;

    if (status.isGranted) {
      // Izin diberikan, lanjutkan dengan tindakan yang diperlukan
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          allowedExtensions: ['pdf', 'jpg', 'png'], type: FileType.custom);

      if (result != null) {
        File file = File(result.files.single.path!);
        int maxSizeInBytes = 5 * 1024 * 1024; // 5MB dalam byte
        print(result.files.first.size);

        if (result.files.first.size > maxSizeInBytes) {
          CustomAlert.error(message: 'Max file size is 5mb', context: context);
          return;
        }
        try {
          BlocProvider.of<ScientificSessionCubit>(context)
            ..uploadAttachment(path: file.path);
        } catch (e) {
          print('Error uploading file: $e');
        }
      }
    } else if (status.isDenied) {
      // Pengguna menolak izin, Anda dapat memberi tahu pengguna untuk mengaktifkannya di pengaturan
      print('Storage permission is denied');
    } else if (status.isPermanentlyDenied) {
      // Pengguna secara permanen menolak izin, arahkan pengguna ke pengaturan aplikasi
      openAppSettings();
    }
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      BlocProvider.of<SupervisorsCubit>(context, listen: false)
        ..getAllSupervisors();
      BlocProvider.of<ScientificSessionCubit>(context)
        ..getListSessionTypes()
        ..getScientificSessionRoles();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Scientific Session"),
      ).variant(),
      body: BlocConsumer<ScientificSessionCubit, ScientifcSessionState>(
        listener: (context, state) {
          if (state.postSuccess) {
            BlocProvider.of<StudentCubit>(context)
              ..getStudentScientificSessionOfActiveDepartment();
            BlocProvider.of<ScientificSessionCubit>(context)..reset();
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
              padding: EdgeInsets.only(bottom: 20),
              child: FormBuilder(
                key: _formKey,
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
                            label: Text('Department'),
                            enabled: false,
                          ),
                          initialValue: widget.activeDepartmentModel.unitName,
                        ),
                        BlocBuilder<SupervisorsCubit, SupervisorsState>(
                            builder: (context, state) {
                          List<SupervisorModel> _supervisors = [];
                          if (state is FetchSuccess) {
                            _supervisors.clear();
                            _supervisors.addAll(state.supervisors);
                          }
                          return CustomDropdown<SupervisorModel>(
                              errorNotifier: supervisorValue,
                              onSubmit: (text, controller) {
                                if (_supervisors.indexWhere((element) =>
                                        element.fullName?.trim() ==
                                        text.trim()) ==
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
                          hint: Text('Session Type'),
                          items: _sessionTypes
                              .map(
                                (e) => DropdownMenuItem(
                                  child: Text(e.name!),
                                  value: e,
                                ),
                              )
                              .toList(),
                          onChanged: (v) {
                            if (v != null) sesionType = v.id!;
                          },
                          value: null,
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
                          hint: Text('Role'),
                          validator: FormBuilderValidators.required(
                            errorText: 'This field is required',
                          ),
                          items: _roles
                              .map(
                                (e) => DropdownMenuItem(
                                  child: Text(e.name!),
                                  value: e,
                                ),
                              )
                              .toList(),
                          onChanged: (v) {
                            if (v != null) role = v.id!;
                          },
                          value: null,
                        ),
                        InkWellContainer(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 24),
                          radius: 12,
                          color: Color(0xFF29C5F6).withOpacity(.2),
                          onTap: () => uploadFile(context),
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
                                    padding: new EdgeInsets.all(0.0),
                                    iconSize: 14,
                                    onPressed: () => uploadFile(context),
                                    icon: Icon(
                                      Icons.add_rounded,
                                      color: backgroundColor,
                                      size: 16,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text('Upload image or PDF'),
                                Spacer(),
                                Text('(max. 5 MB)')
                              ],
                              if (state.attachState == RequestState.loading)
                                Expanded(
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
                                        ..resetAttachment();
                                    },
                                    child: Center(
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
                          decoration: InputDecoration(
                            label: Text('Additional Notes'),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        FilledButton(
                          onPressed: () => onSubmit(state.attachment),
                          child: Text('Submit'),
                        ).fullWidth(),
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
                  BlocProvider.of<ScientificSessionCubit>(context,
                      listen: false)
                    ..uploadScientificSession(
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
                  Navigator.pop(context);
                },
              ));
    }
  }
}
