import 'package:device_info_plus/device_info_plus.dart';
import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/helpers/utils.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/presentation/blocs/clinical_record_cubit/clinical_record_cubit.dart';
import 'package:elogbook/src/presentation/blocs/clinical_record_supervisor_cubit/clinical_record_supervisor_cubit.dart';
import 'package:elogbook/src/presentation/widgets/custom_alert.dart';
import 'package:elogbook/src/presentation/widgets/custom_loading.dart';
import 'package:elogbook/src/presentation/widgets/dividers/item_divider.dart';
import 'package:elogbook/src/presentation/widgets/dividers/section_divider.dart';
import 'package:elogbook/src/presentation/widgets/headers/form_section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';

class DetailClinicalRecordPage extends StatefulWidget {
  final String id;
  const DetailClinicalRecordPage({super.key, required this.id});

  @override
  State<DetailClinicalRecordPage> createState() =>
      _DetailClinicalRecordPageState();
}

class _DetailClinicalRecordPageState extends State<DetailClinicalRecordPage> {
  final TextEditingController fController = TextEditingController();

  Future<bool> checkAndRequestPermission() async {
    final plugin = DeviceInfoPlugin();
    final android = await plugin.androidInfo;

    var status = android.version.sdkInt < 33
        ? await Permission.storage.request()
        : PermissionStatus.granted;
    if (!status.isGranted) {
      status = await Permission.storage.request();
    }
    return status.isGranted;
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ClinicalRecordSupervisorCubit>(context)
      ..getDetailClinicalRecord(id: widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Entry Detail"),
        // actions: [
        //   IconButton(
        //     onPressed: () {},
        //     icon: Icon(
        //       Icons.more_vert_rounded,
        //       color: Colors.white,
        //     ),
        //   )
        // ],
      ).variant(),
      body: BlocListener<ClinicalRecordCubit, ClinicalRecordState>(
        listener: (context, state) {
          if (state.isPostFeedbackSuccess) {
            BlocProvider.of<ClinicalRecordSupervisorCubit>(context)
              ..getDetailClinicalRecord(id: widget.id);
          }
          if (state.crDownloadPath != null) {
            CustomAlert.success(
                message: 'Success download data ${state.crDownloadPath}',
                context: context);
          }
        },
        child: SafeArea(
          child: BlocBuilder<ClinicalRecordSupervisorCubit,
              ClinicalRecordSupervisorState>(
            builder: (context, state) {
              if (state.detailClinicalRecordModel == null) {
                return CustomLoading();
              }
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 24),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: primaryColor.withOpacity(.2),
                            ),
                            child: SvgPicture.asset(
                                'assets/icons/clinical_notes_rounded.svg'),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Clinical Record',
                                style: textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '#${state.detailClinicalRecordModel!.recordId}',
                                style: textTheme.bodyMedium?.copyWith(
                                  color: primaryColor,
                                  height: 1,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              // SizedBox(
                              //   height: 4,
                              // ),
                              // Text(
                              //   ReusableFunctionHelper.datetimeToString(state.detailClinicalRecordModel!.,),
                              //   style: textTheme.bodyMedium?.copyWith(
                              //     color: secondaryTextColor,
                              //   ),
                              // )
                            ],
                          ),
                        ],
                      ),
                    ),
                    SectionDivider(),
                    SizedBox(
                      height: 24,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 24),
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(0, 0),
                              spreadRadius: 0,
                              blurRadius: 6,
                              color: Color(0xFFD4D4D4).withOpacity(.25)),
                          BoxShadow(
                              offset: Offset(0, 4),
                              spreadRadius: 0,
                              blurRadius: 24,
                              color: Color(0xFFD4D4D4).withOpacity(.25)),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Student',
                            style: textTheme.bodyMedium?.copyWith(
                              color: secondaryTextColor,
                            ),
                          ),
                          Text(
                            state.detailClinicalRecordModel!.studentName ?? '',
                            style: textTheme.titleMedium?.copyWith(
                              color: primaryTextColor,
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            'Supervisor',
                            style: textTheme.bodyMedium?.copyWith(
                              color: secondaryTextColor,
                            ),
                          ),
                          Text(
                            state.detailClinicalRecordModel!.supervisorName ??
                                '',
                            style: textTheme.titleMedium?.copyWith(
                              color: primaryTextColor,
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          ItemDivider(),
                          FormSectionHeader(
                              label: 'Patient',
                              pathPrefix: 'icon_patient.svg',
                              padding: 0),
                          ItemDivider(),
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                            'Patient Names',
                            style: textTheme.bodyMedium?.copyWith(
                              color: secondaryTextColor,
                            ),
                          ),
                          Text(
                            state.detailClinicalRecordModel!.patientName ?? '',
                            style: textTheme.titleMedium?.copyWith(
                              color: primaryTextColor,
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            'Sex',
                            style: textTheme.bodyMedium?.copyWith(
                              color: secondaryTextColor,
                            ),
                          ),
                          Text(
                            state.detailClinicalRecordModel!.patientSex ?? '',
                            style: textTheme.titleMedium?.copyWith(
                              color: primaryTextColor,
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            'Age',
                            style: textTheme.bodyMedium?.copyWith(
                              color: secondaryTextColor,
                            ),
                          ),
                          Text(
                            '18th',
                            style: textTheme.titleMedium?.copyWith(
                              color: primaryTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 24),
                      padding: EdgeInsets.only(
                        bottom: 20,
                        left: 20,
                        right: 20,
                      ),
                      decoration: BoxDecoration(
                        color: scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(0, 0),
                              spreadRadius: 0,
                              blurRadius: 6,
                              color: Color(0xFFD4D4D4).withOpacity(.25)),
                          BoxShadow(
                              offset: Offset(0, 4),
                              spreadRadius: 0,
                              blurRadius: 24,
                              color: Color(0xFFD4D4D4).withOpacity(.25)),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FormSectionHeader(
                              label: 'Examination',
                              pathPrefix: 'icon_examination.svg',
                              padding: 0),
                          ItemDivider(),
                          SizedBox(
                            height: 16,
                          ),
                          ...state.detailClinicalRecordModel!.examinations!
                              .map((e) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (e.examinationType != null)
                                  ...e.examinationType!
                                      .map(
                                        (b) => Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(top: 8),
                                              width: 6,
                                              height: 6,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: secondaryTextColor,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 4,
                                            ),
                                            Expanded(
                                              child: Text(
                                                b,
                                                style: textTheme.bodyMedium
                                                    ?.copyWith(
                                                  color: primaryTextColor,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                      .toList(),
                              ],
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 24),
                      padding: EdgeInsets.only(
                        bottom: 20,
                        left: 20,
                        right: 20,
                      ),
                      decoration: BoxDecoration(
                        color: scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(0, 0),
                              spreadRadius: 0,
                              blurRadius: 6,
                              color: Color(0xFFD4D4D4).withOpacity(.25)),
                          BoxShadow(
                              offset: Offset(0, 4),
                              spreadRadius: 0,
                              blurRadius: 24,
                              color: Color(0xFFD4D4D4).withOpacity(.25)),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FormSectionHeader(
                              label: 'Diagnosis',
                              pathPrefix: 'icon_diagnosis.svg',
                              padding: 0),
                          ItemDivider(),
                          SizedBox(
                            height: 16,
                          ),
                          ...state.detailClinicalRecordModel!.diagnosess!
                              .map((e) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (e.diagnosesType != null)
                                  ...e.diagnosesType!
                                      .map(
                                        (b) => Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(top: 8),
                                              width: 6,
                                              height: 6,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: secondaryTextColor,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 4,
                                            ),
                                            Expanded(
                                              child: Text(
                                                b,
                                                style: textTheme.bodyMedium
                                                    ?.copyWith(
                                                  color: primaryTextColor,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                      .toList(),
                              ],
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 24),
                      padding: EdgeInsets.only(
                        bottom: 20,
                        left: 20,
                        right: 20,
                      ),
                      decoration: BoxDecoration(
                        color: scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(0, 0),
                              spreadRadius: 0,
                              blurRadius: 6,
                              color: Color(0xFFD4D4D4).withOpacity(.25)),
                          BoxShadow(
                              offset: Offset(0, 4),
                              spreadRadius: 0,
                              blurRadius: 24,
                              color: Color(0xFFD4D4D4).withOpacity(.25)),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FormSectionHeader(
                              label: 'Management',
                              pathPrefix: 'icon_management.svg',
                              padding: 0),
                          ItemDivider(),
                          SizedBox(
                            height: 16,
                          ),
                          ...state.detailClinicalRecordModel!.managements!
                              .map((e) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (e.management != null)
                                  ...e.management!
                                      .map(
                                        (b) => Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(top: 8),
                                              width: 6,
                                              height: 6,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: secondaryTextColor,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 4,
                                            ),
                                            Expanded(
                                              child: Text(
                                                '${b.managementType} (${b.managementRole})',
                                                style: textTheme.bodyMedium
                                                    ?.copyWith(
                                                  color: primaryTextColor,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                      .toList(),
                              ],
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    if (state.detailClinicalRecordModel!.attachments !=
                        null) ...[
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 24),
                        padding: EdgeInsets.only(
                          bottom: 20,
                          left: 20,
                          right: 20,
                        ),
                        decoration: BoxDecoration(
                          color: scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0, 0),
                                spreadRadius: 0,
                                blurRadius: 6,
                                color: Color(0xFFD4D4D4).withOpacity(.25)),
                            BoxShadow(
                                offset: Offset(0, 4),
                                spreadRadius: 0,
                                blurRadius: 24,
                                color: Color(0xFFD4D4D4).withOpacity(.25)),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FormSectionHeader(
                                label: 'Upload File',
                                pathPrefix: 'icon_attachment.svg',
                                padding: 0),
                            ItemDivider(),
                            SizedBox(
                              height: 16,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.file_present_outlined,
                                  color: secondaryTextColor,
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Expanded(
                                  child: Text(
                                    state.detailClinicalRecordModel!.filename ??
                                        'data.pdf',
                                    style: textTheme.bodyMedium?.copyWith(
                                      color: secondaryTextColor,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                SizedBox(
                                  height: 24,
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8),
                                    ),
                                    onPressed: () async {
                                      final hasPermission =
                                          await checkAndRequestPermission();
                                      if (hasPermission) {
                                        BlocProvider.of<ClinicalRecordCubit>(
                                            context)
                                          ..crDownloadPath(
                                              id: widget.id,
                                              filaname: state
                                                      .detailClinicalRecordModel!
                                                      .filename ??
                                                  'data');
                                      }
                                    },
                                    child: Text(
                                      'Download',
                                      style: textTheme.bodySmall?.copyWith(
                                        color: primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                    ],
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 24),
                      padding: EdgeInsets.only(
                        bottom: 20,
                        left: 20,
                        right: 20,
                      ),
                      decoration: BoxDecoration(
                        color: scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(0, 0),
                              spreadRadius: 0,
                              blurRadius: 6,
                              color: Color(0xFFD4D4D4).withOpacity(.25)),
                          BoxShadow(
                              offset: Offset(0, 4),
                              spreadRadius: 0,
                              blurRadius: 24,
                              color: Color(0xFFD4D4D4).withOpacity(.25)),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FormSectionHeader(
                              label: 'Notes',
                              pathPrefix: 'icon_note.svg',
                              padding: 0),
                          ItemDivider(),
                          SizedBox(
                            height: 16,
                          ),
                          Text(state.detailClinicalRecordModel?.notes ?? '-'),
                          SizedBox(
                            height: 8,
                          ),
                          // if(state.detailClinicalRecordModel?.notes.)
                          // Row(
                          //   crossAxisAlignment: CrossAxisAlignment.center,
                          //   children: [
                          //     SizedBox(
                          //       height: 24,
                          //       child: Text(
                          //         'Show more',
                          //         style: textTheme.bodyMedium?.copyWith(
                          //           color: primaryColor,
                          //         ),
                          //       ),
                          //     ),
                          //     Icon(
                          //       Icons.keyboard_arrow_down_rounded,
                          //       color: primaryColor,
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    SectionDivider(),
                    SizedBox(
                      height: 24,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 24),
                      padding: EdgeInsets.only(
                        bottom: 20,
                        left: 20,
                        right: 20,
                      ),
                      decoration: BoxDecoration(
                        color: scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(0, 0),
                              spreadRadius: 0,
                              blurRadius: 6,
                              color: Color(0xFFD4D4D4).withOpacity(.25)),
                          BoxShadow(
                              offset: Offset(0, 4),
                              spreadRadius: 0,
                              blurRadius: 24,
                              color: Color(0xFFD4D4D4).withOpacity(.25)),
                        ],
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Status Verification',
                                  textAlign: TextAlign.center,
                                  style: textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  'Entry details have been verified by supervisor',
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: secondaryTextColor,
                                    height: 1.1,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(56),
                              color: state.detailClinicalRecordModel!
                                          .verificationStatus ==
                                      'VERIFIED'
                                  ? Colors.green
                                  : errorColor,
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 12,
                            ),
                            child: state.detailClinicalRecordModel!
                                        .verificationStatus ==
                                    'VERIFIED'
                                ? Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.verified,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        'Verified',
                                        style: textTheme.bodyMedium?.copyWith(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  )
                                : Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(4.0),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white),
                                        child: Icon(
                                          Icons.close_rounded,
                                          color: errorColor,
                                          size: 12,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        'Unverified',
                                        style: textTheme.bodyMedium?.copyWith(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          ItemDivider(),
                          SizedBox(
                            height: 16,
                          ),
                          if (state.detailClinicalRecordModel!
                                  .verificationStatus ==
                              'VERIFIED') ...[
                            Text(
                              'Rating',
                              style: textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            RatingBar.builder(
                              initialRating:
                                  state.detailClinicalRecordModel?.rating ?? 0,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: false,
                              ignoreGestures: true,
                              itemCount: 5,
                              unratedColor: Color(0xFFCED8EE),
                              itemPadding:
                                  EdgeInsets.symmetric(horizontal: 4.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: primaryColor,
                              ),
                              onRatingUpdate: (rating) {
                                print(rating);
                              },
                            ),
                            Text(
                              Utils.rateToText(state
                                  .detailClinicalRecordModel!.rating!
                                  .toInt()),
                              style: textTheme.bodyLarge
                                  ?.copyWith(color: primaryColor),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            ItemDivider(),
                            SizedBox(
                              height: 16,
                            ),
                            Text(
                              'Feedback',
                              style: textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            if (state.detailClinicalRecordModel!
                                    .supervisorFeedback !=
                                null)
                              Align(
                                alignment: Alignment.centerLeft,
                                child: RichText(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(
                                    style: textTheme.bodyMedium?.copyWith(
                                      color: primaryTextColor,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text:
                                            '${state.detailClinicalRecordModel?.supervisorName} :\t',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      TextSpan(
                                          text: state.detailClinicalRecordModel!
                                                  .supervisorFeedback ??
                                              '-'),
                                    ],
                                  ),
                                ),
                              ),
                            SizedBox(
                              height: 12,
                            ),
                            if (state.detailClinicalRecordModel!
                                    .studentFeedback ==
                                null)
                              Container(
                                height: 56,
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: dividerColor,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: fController,
                                        decoration: InputDecoration(
                                          hintText: 'Reply',
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                          ),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        BlocProvider.of<ClinicalRecordCubit>(
                                            context)
                                          ..addFeedback(
                                              id: widget.id,
                                              feedback: fController.text);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.grey,
                                        ),
                                        child: Icon(
                                          Icons.arrow_upward_rounded,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            if (state.detailClinicalRecordModel!
                                    .studentFeedback !=
                                null)
                              Align(
                                alignment: Alignment.centerLeft,
                                child: RichText(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(
                                    style: textTheme.bodyMedium?.copyWith(
                                      color: primaryTextColor,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text:
                                            '${state.detailClinicalRecordModel?.studentName} :\t',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      TextSpan(
                                          text: state.detailClinicalRecordModel!
                                              .studentFeedback),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
