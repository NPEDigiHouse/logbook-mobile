// ignore_for_file: empty_catches, use_build_context_synchronously

import 'dart:io';

import 'package:core/context/navigation_extension.dart';
import 'package:core/styles/color_palette.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main/blocs/clinical_record_cubit/clinical_record_cubit.dart';
import 'package:main/blocs/student_cubit/student_cubit.dart';
import 'package:main/widgets/custom_alert.dart';
import 'package:main/widgets/headers/form_section_header.dart';
import 'package:main/widgets/inkwell_container.dart';
import 'package:main/widgets/verify_dialog.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:students/features/clinical_record/providers/clinical_record_data_notifier2.dart';
import 'package:students/features/clinical_record/providers/clinical_record_data_temp.dart';

class CreateClinicalRecordThirdPage extends StatefulWidget {
  final ClinicalRecordData clinicalRecordData;

  const CreateClinicalRecordThirdPage(
      {super.key, required this.clinicalRecordData});

  @override
  State<CreateClinicalRecordThirdPage> createState() =>
      _CreateClinicalRecordThirdPageState();
}

class _CreateClinicalRecordThirdPageState
    extends State<CreateClinicalRecordThirdPage> {
  ValueNotifier<String> fileName = ValueNotifier('');
  final TextEditingController notesController = TextEditingController();
  Future<void> uploadFile(BuildContext context) async {
    PermissionStatus? status;

    if (Platform.isAndroid) {
      final plugin = DeviceInfoPlugin();
      final android = await plugin.androidInfo;

      status = android.version.sdkInt < 33
          ? await Permission.storage.request()
          : PermissionStatus.granted;
    } else {
      status = await Permission.storage.request();
    }
    if (status.isGranted) {
      // Izin diberikan, lanjutkan dengan tindakan yang diperlukan
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowedExtensions: ['pdf', 'jpg', 'png'],
        type: FileType.custom,
      );

      if (result != null) {
        int maxSizeInBytes = 5 * 1024 * 1024; // 5MB dalam byte
        if (result.files.first.size > maxSizeInBytes) {
          CustomAlert.error(context: context, message: 'Max file size is 5mb');
          return;
        }
        File file = File(result.files.single.path!);

        fileName.value = basename(file.path);

        try {
          BlocProvider.of<ClinicalRecordCubit>(context)
              .uploadClinicalRecordAttachment(path: file.path);
        } catch (e) {}
      }
    } else if (status.isDenied) {
      // Pengguna menolak izin, Anda dapat memberi tahu pengguna untuk mengaktifkannya di pengaturan
    } else if (status.isPermanentlyDenied) {
      // Pengguna secara permanen menolak izin, arahkan pengguna ke pengaturan aplikasi
      openAppSettings();
    }
  }

  @override
  void dispose() {
    super.dispose();
    notesController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ClinicalRecordCubit, ClinicalRecordState>(
      listener: (context, state) {
        if (state.clinicalRecordPostSuccess) {
          context.read<ClinicalRecordDataNotifier2>().reset();
          BlocProvider.of<StudentCubit>(context)
              .getStudentClinicalRecordOfActiveDepartment();

          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Add Clinical Record"),
        ).variant(),
        body: SafeArea(
          child: SingleChildScrollView(
            child: BlocConsumer<ClinicalRecordCubit, ClinicalRecordState>(
              listener: (context, state) {
                if (state.pathAttachment != null) {
                  widget.clinicalRecordData
                      .addAttachment(state.pathAttachment!);
                } else {
                  widget.clinicalRecordData.removeAttachment();
                }
              },
              builder: (context, state) {
                return Column(
                  children: [
                    const SizedBox(
                      height: 4,
                    ),
                    const FormSectionHeader(
                      label: 'Attachment (Optional)',
                      pathPrefix: 'icon_attachment.svg',
                      padding: 16,
                    ),
                    InkWellContainer(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 24),
                      radius: 12,
                      color: const Color(0xFF29C5F6).withOpacity(.2),
                      margin: const EdgeInsets.symmetric(horizontal: 16),
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
                                      MaterialStateProperty.all(primaryColor),
                                ),
                                padding: const EdgeInsets.all(0.0),
                                iconSize: 14,
                                onPressed: () => uploadFile(context),
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
                                child: Center(child: Text('Processing...'))),
                          if (state.pathAttachment != null &&
                              state.attachState == RequestState.data) ...[
                            Expanded(
                                child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    basename(state.pathAttachment!),
                                    maxLines: 1,
                                  ),
                                ),
                                SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: InkWell(
                                    onTap: () {
                                      BlocProvider.of<ClinicalRecordCubit>(
                                              context)
                                          .resetAttachment();
                                    },
                                    child: const Center(
                                        child: Icon(Icons.close_rounded)),
                                  ),
                                )
                              ],
                            ))
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextFormField(
                        maxLines: 5,
                        minLines: 5,
                        controller: notesController,
                        decoration: const InputDecoration(
                          label: Text('Additional Notes'),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: FilledButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              barrierLabel: '',
                              barrierDismissible: false,
                              builder: (_) => VerifyDialog(
                                    onTap: () {
                                      if (state.pathAttachment != null) {
                                        widget.clinicalRecordData.addAttachment(
                                            state.pathAttachment!);
                                      }
                                      if (notesController.text.isNotEmpty) {
                                        widget.clinicalRecordData
                                            .addNotes(notesController.text);
                                      }

                                      BlocProvider.of<ClinicalRecordCubit>(
                                              context)
                                          .uploadClinicalRecord(
                                        model: widget.clinicalRecordData
                                            .clinicalRecordPostModel,
                                      );
                                      Navigator.pop(context);
                                    },
                                  ));
                        },
                        child: const Text('Submit'),
                      ).fullWidth(),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
