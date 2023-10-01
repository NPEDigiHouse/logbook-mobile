import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/src/presentation/blocs/clinical_record_cubit/clinical_record_cubit.dart';
import 'package:elogbook/src/presentation/blocs/student_cubit/student_cubit.dart';
import 'package:elogbook/src/presentation/features/students/clinical_record/providers/clinical_record_data_notifier2.dart';
import 'package:elogbook/src/presentation/features/students/clinical_record/providers/clinical_record_data_temp.dart';
import 'package:elogbook/src/presentation/widgets/custom_alert.dart';
import 'package:elogbook/src/presentation/widgets/headers/form_section_header.dart';
import 'package:elogbook/src/presentation/widgets/inkwell_container.dart';
import 'package:elogbook/src/presentation/widgets/verify_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';

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
    final plugin = DeviceInfoPlugin();
    final android = await plugin.androidInfo;

    final status = android.version.sdkInt < 33
        ? await Permission.storage.request()
        : PermissionStatus.granted;
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
            ..uploadClinicalRecordAttachment(path: file.path);
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
  void dispose() {
    super.dispose();
    notesController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.clinicalRecordData.clinicalRecordPostModel.examinations);
    return BlocListener<ClinicalRecordCubit, ClinicalRecordState>(
      listener: (context, state) {
        if (state.clinicalRecordPostSuccess) {
          context.read<ClinicalRecordDataNotifier2>()..reset();
          BlocProvider.of<StudentCubit>(context)
            ..getStudentClinicalRecordOfActiveDepartment();

          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Add Clinical Record"),
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
                    SizedBox(
                      height: 4,
                    ),
                    FormSectionHeader(
                      label: 'Attachment (Optional)',
                      pathPrefix: 'icon_attachment.svg',
                      padding: 16,
                    ),
                    InkWellContainer(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 24),
                      radius: 12,
                      color: Color(0xFF29C5F6).withOpacity(.2),
                      margin: EdgeInsets.symmetric(horizontal: 16),
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
                                        ..resetAttachment();
                                    },
                                    child: Center(
                                        child: Icon(Icons.close_rounded)),
                                  ),
                                )
                              ],
                            ))
                          ],
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextFormField(
                        maxLines: 5,
                        minLines: 5,
                        controller: notesController,
                        decoration: InputDecoration(
                          label: Text('Additional Notes'),
                        ),
                      ),
                    ),
                    SizedBox(
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
                                      if (state.pathAttachment != null)
                                        widget.clinicalRecordData.addAttachment(
                                            state.pathAttachment!);
                                      if (notesController.text.isNotEmpty)
                                        widget.clinicalRecordData
                                            .addNotes(notesController.text);

                                      BlocProvider.of<ClinicalRecordCubit>(
                                          context)
                                        ..uploadClinicalRecord(
                                          model: widget.clinicalRecordData
                                              .clinicalRecordPostModel,
                                        );
                                      Navigator.pop(context);
                                    },
                                  ));
                        },
                        child: Text('Submit'),
                      ).fullWidth(),
                    ),
                    SizedBox(
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
