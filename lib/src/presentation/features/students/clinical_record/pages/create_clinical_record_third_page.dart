import 'dart:io';

import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/src/data/models/clinical_records/clinical_record_post_model.dart';
import 'package:elogbook/src/presentation/blocs/clinical_record_cubit/clinical_record_cubit.dart';
import 'package:elogbook/src/presentation/features/students/clinical_record/providers/clinical_record_data_notifier.dart';
import 'package:elogbook/src/presentation/widgets/header/form_section_header.dart';
import 'package:elogbook/src/presentation/widgets/inkwell_container.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';

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
    final status = await Permission.storage.request();
    if (status.isGranted) {
      // Izin diberikan, lanjutkan dengan tindakan yang diperlukan
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          allowedExtensions: ['pdf', 'jpg', 'png'], type: FileType.custom);

      if (result != null) {
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
    // TODO: implement dispose
    super.dispose();
    notesController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.clinicalRecordData.clinicalRecordPostModel.examinations);
    return BlocListener<ClinicalRecordCubit, ClinicalRecordState>(
      listener: (context, state) {
        if (state.clinicalRecordPostSuccess) {
          Navigator.of(context).popUntil((route) => route.isFirst);
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
                          // ValueListenableBuilder(
                          //   valueListenable: fileName,
                          //   builder: (context, value, child) {
                          //     if (value.isEmpty) {
                          //       return Expanded(
                          //         child: Row(
                          //           children: [
                          //             Text('Upload image or PDF'),
                          //             Spacer(),
                          //             Text('(max. 5 MB)')
                          //           ],
                          //         ),
                          //       );
                          //     } else {
                          //       return Expanded(
                          //           child: Text(
                          //         value,
                          //         maxLines: 1,
                          //         overflow: TextOverflow.ellipsis,
                          //       ));
                          //     }
                          //   },
                          // )
                          if (state.pathAttachment == null) ...[
                            Text('Upload image or PDF'),
                            Spacer(),
                            Text('(max. 5 MB)')
                          ],
                          if (state.pathAttachment != null) ...[
                            Expanded(
                                child: Text(
                              basename(state.pathAttachment!),
                              maxLines: 1,
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
                          if (notesController.text.isNotEmpty) {
                            widget.clinicalRecordData.clinicalRecordPostModel
                                .notes = notesController.text;
                            widget.clinicalRecordData.clinicalRecordPostModel
                                .attachment = '';
                            widget.clinicalRecordData.clinicalRecordPostModel
                                .studentFeedback = 'haha';

                            BlocProvider.of<ClinicalRecordCubit>(context)
                              ..uploadClinicalRecord(
                                model: widget
                                    .clinicalRecordData.clinicalRecordPostModel,
                              );
                            print("berhasil");
                          }
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
