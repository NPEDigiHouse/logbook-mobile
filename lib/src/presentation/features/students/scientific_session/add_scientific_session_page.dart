import 'dart:io';

import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/src/data/models/scientific_session/scientific_roles.dart';
import 'package:elogbook/src/data/models/scientific_session/scientific_session_post_model.dart';
import 'package:elogbook/src/data/models/scientific_session/session_types_model.dart';
import 'package:elogbook/src/data/models/supervisors/supervisor_model.dart';
import 'package:elogbook/src/data/models/units/active_unit_model.dart';
import 'package:elogbook/src/presentation/blocs/scientific_session_cubit/scientific_session_cubit.dart';
import 'package:elogbook/src/presentation/blocs/student_cubit/student_cubit.dart';
import 'package:elogbook/src/presentation/blocs/supervisor_cubit/supervisors_cubit.dart';
import 'package:elogbook/src/presentation/widgets/dividers/section_divider.dart';
import 'package:elogbook/src/presentation/widgets/headers/form_section_header.dart';
import 'package:elogbook/src/presentation/widgets/inkwell_container.dart';
import 'package:elogbook/src/presentation/widgets/inputs/build_text_field.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';

class AddScientificSessionPage extends StatefulWidget {
  final ActiveUnitModel activeUnitModel;

  const AddScientificSessionPage({super.key, required this.activeUnitModel});

  @override
  State<AddScientificSessionPage> createState() =>
      _AddScientificSessionPageState();
}

class _AddScientificSessionPageState extends State<AddScientificSessionPage> {
  String supervisorId = '';
  int role = -1;
  int sesionType = -1;
  final topicController = TextEditingController();
  // final clinicalRotationController = TextEditingController();
  final titleController = TextEditingController();
  final referenceController = TextEditingController();
  final additionalNotesController = TextEditingController();
  List<ScientificRoles> _roles = [];
  List<SessionTypesModel> _sessionTypes = [];

  Future<void> uploadFile(BuildContext context) async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      // Izin diberikan, lanjutkan dengan tindakan yang diperlukan
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          allowedExtensions: ['pdf', 'jpg', 'png'], type: FileType.custom);

      if (result != null) {
        File file = File(result.files.single.path!);

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
              ..getStudentScientificSessionOfActiveUnit();
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
                          label: Text('Unit'),
                          enabled: false,
                        ),
                        initialValue: widget.activeUnitModel.unitName,
                      ),
                      BlocBuilder<SupervisorsCubit, SupervisorsState>(
                          builder: (context, state) {
                        List<SupervisorModel> _supervisors = [];
                        if (state is FetchSuccess) {
                          _supervisors.clear();
                          _supervisors.addAll(state.supervisors);
                        }
                        return DropdownButtonFormField(
                          hint: Text('Supervisor'),
                          items: _supervisors
                              .map(
                                (e) => DropdownMenuItem(
                                  child: Text(e.fullName!),
                                  value: e,
                                ),
                              )
                              .toList(),
                          onChanged: (v) {
                            if (v != null) supervisorId = v.id!;
                            ;
                          },
                          value: null,
                        );
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
                        label: 'Topics',
                        controller: topicController,
                      ),
                      // BuildTextField(
                      //   onChanged: (v) {},
                      //   label: 'Clinical rotation',
                      //   controller: clinicalRotationController,
                      // ),
                      BuildTextField(
                        onChanged: (v) {},
                        label: 'Title',
                        controller: titleController,
                      ),
                      BuildTextField(
                        onChanged: (v) {},
                        label: 'Reference',
                        controller: referenceController,
                      ),
                      DropdownButtonFormField(
                        hint: Text('Role'),
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 24),
                        radius: 12,
                        color: Color(0xFF29C5F6).withOpacity(.2),
                        onTap: () => uploadFile(context),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: IconButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(primaryColor),
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
                            if (state.attachment == null) ...[
                              Text('Upload image or PDF'),
                              Spacer(),
                              Text('(max. 5 MB)')
                            ],
                            if (state.attachment != null) ...[
                              Expanded(
                                  child: Text(
                                path.basename(state.attachment!),
                                maxLines: 1,
                              ))
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
                        onPressed: () {
                          BlocProvider.of<ScientificSessionCubit>(context,
                              listen: false)
                            ..uploadScientificSession(
                              model: ScientificSessionPostModel(
                                attachment: state.attachment,
                                role: role,
                                title: titleController.text,
                                topic: topicController.text,
                                // clinicalRotation: clinicalRotationController.text,
                                reference: referenceController.text,
                                sessionType: sesionType,
                                supervisorId: supervisorId,
                                notes: additionalNotesController.text.isEmpty
                                    ? null
                                    : additionalNotesController.text,
                              ),
                            );
                        },
                        child: Text('Submit'),
                      ).fullWidth(),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
