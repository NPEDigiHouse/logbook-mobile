// ignore_for_file: use_build_context_synchronously

import 'package:common/features/file/file_management.dart';
import 'package:core/context/navigation_extension.dart';
import 'package:core/helpers/utils.dart';
import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:main/blocs/clinical_record_cubit/clinical_record_cubit.dart';
import 'package:main/blocs/clinical_record_supervisor_cubit/clinical_record_supervisor_cubit.dart';
import 'package:main/widgets/custom_loading.dart';
import 'package:main/widgets/dividers/item_divider.dart';
import 'package:main/widgets/dividers/section_divider.dart';
import 'package:main/widgets/headers/form_section_header.dart';
import 'package:main/widgets/headers/unit_student_header.dart';
import 'widgets/verify_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SupervisorDetailClinicalRecordPage extends StatefulWidget {
  final String id;
  final String? unitName;
  const SupervisorDetailClinicalRecordPage(
      {super.key, required this.id, this.unitName});

  @override
  State<SupervisorDetailClinicalRecordPage> createState() =>
      _SupervisorDetailClinicalRecordPageState();
}

class _SupervisorDetailClinicalRecordPageState
    extends State<SupervisorDetailClinicalRecordPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ClinicalRecordSupervisorCubit>(context)
        .getDetailClinicalRecord(id: widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Entry Detail"),
      ).variant(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await Future.wait([
              BlocProvider.of<ClinicalRecordSupervisorCubit>(context)
                  .getDetailClinicalRecord(id: widget.id),
            ]);
          },
          child: BlocBuilder<ClinicalRecordSupervisorCubit,
              ClinicalRecordSupervisorState>(
            builder: (context, state) {
              if (state.detailClinicalRecordModel == null) {
                return const CustomLoading();
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
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: primaryColor.withOpacity(.2),
                            ),
                            child: SvgPicture.asset(
                                'assets/icons/clinical_notes_rounded.svg'),
                          ),
                          const SizedBox(
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
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SectionDivider(),
                    const SizedBox(
                      height: 24,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: StudentDepartmentHeader(
                        studentName:
                            state.detailClinicalRecordModel?.studentName ?? '',
                        unitName: state.detailClinicalRecordModel?.unit ?? '',
                        supervisorName:
                            state.detailClinicalRecordModel?.supervisorName ??
                                '',
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                              offset: const Offset(0, 0),
                              spreadRadius: 0,
                              blurRadius: 6,
                              color: const Color(0xFFD4D4D4).withOpacity(.25)),
                          BoxShadow(
                              offset: const Offset(0, 4),
                              spreadRadius: 0,
                              blurRadius: 24,
                              color: const Color(0xFFD4D4D4).withOpacity(.25)),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const FormSectionHeader(
                              label: 'Patient',
                              pathPrefix: 'icon_patient.svg',
                              padding: 0),
                          const ItemDivider(),
                          const SizedBox(
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
                          const SizedBox(
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
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      padding: const EdgeInsets.only(
                        bottom: 20,
                        left: 20,
                        right: 20,
                      ),
                      decoration: BoxDecoration(
                        color: scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                              offset: const Offset(0, 0),
                              spreadRadius: 0,
                              blurRadius: 6,
                              color: const Color(0xFFD4D4D4).withOpacity(.25)),
                          BoxShadow(
                              offset: const Offset(0, 4),
                              spreadRadius: 0,
                              blurRadius: 24,
                              color: const Color(0xFFD4D4D4).withOpacity(.25)),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const FormSectionHeader(
                              label: 'Examination',
                              pathPrefix: 'icon_examination.svg',
                              padding: 0),
                          const ItemDivider(),
                          const SizedBox(
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
                                              margin:
                                                  const EdgeInsets.only(top: 8),
                                              width: 6,
                                              height: 6,
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: secondaryTextColor,
                                              ),
                                            ),
                                            const SizedBox(
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
                    const SizedBox(
                      height: 24,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      padding: const EdgeInsets.only(
                        bottom: 20,
                        left: 20,
                        right: 20,
                      ),
                      decoration: BoxDecoration(
                        color: scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                              offset: const Offset(0, 0),
                              spreadRadius: 0,
                              blurRadius: 6,
                              color: const Color(0xFFD4D4D4).withOpacity(.25)),
                          BoxShadow(
                              offset: const Offset(0, 4),
                              spreadRadius: 0,
                              blurRadius: 24,
                              color: const Color(0xFFD4D4D4).withOpacity(.25)),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const FormSectionHeader(
                              label: 'Diagnosis',
                              pathPrefix: 'icon_diagnosis.svg',
                              padding: 0),
                          const ItemDivider(),
                          const SizedBox(
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
                                              margin:
                                                  const EdgeInsets.only(top: 8),
                                              width: 6,
                                              height: 6,
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: secondaryTextColor,
                                              ),
                                            ),
                                            const SizedBox(
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
                    const SizedBox(
                      height: 24,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      padding: const EdgeInsets.only(
                        bottom: 20,
                        left: 20,
                        right: 20,
                      ),
                      decoration: BoxDecoration(
                        color: scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                              offset: const Offset(0, 0),
                              spreadRadius: 0,
                              blurRadius: 6,
                              color: const Color(0xFFD4D4D4).withOpacity(.25)),
                          BoxShadow(
                              offset: const Offset(0, 4),
                              spreadRadius: 0,
                              blurRadius: 24,
                              color: const Color(0xFFD4D4D4).withOpacity(.25)),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const FormSectionHeader(
                              label: 'Management',
                              pathPrefix: 'icon_management.svg',
                              padding: 0),
                          const ItemDivider(),
                          const SizedBox(
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
                                              margin:
                                                  const EdgeInsets.only(top: 8),
                                              width: 6,
                                              height: 6,
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: secondaryTextColor,
                                              ),
                                            ),
                                            const SizedBox(
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
                    const SizedBox(
                      height: 24,
                    ),
                    if (state.detailClinicalRecordModel!.attachments !=
                        null) ...[
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        padding: const EdgeInsets.only(
                          bottom: 20,
                          left: 20,
                          right: 20,
                        ),
                        decoration: BoxDecoration(
                          color: scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                                offset: const Offset(0, 0),
                                spreadRadius: 0,
                                blurRadius: 6,
                                color:
                                    const Color(0xFFD4D4D4).withOpacity(.25)),
                            BoxShadow(
                                offset: const Offset(0, 4),
                                spreadRadius: 0,
                                blurRadius: 24,
                                color:
                                    const Color(0xFFD4D4D4).withOpacity(.25)),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const FormSectionHeader(
                                label: 'Upload File',
                                pathPrefix: 'icon_attachment.svg',
                                padding: 0),
                            const ItemDivider(),
                            const SizedBox(
                              height: 16,
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.file_present_outlined,
                                  color: secondaryTextColor,
                                ),
                                const SizedBox(
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
                                const SizedBox(
                                  width: 4,
                                ),
                                SizedBox(
                                  height: 24,
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                    ),
                                    onPressed: () async {
                                      final hasPermission = await FileManagement
                                          .checkAndRequestPermission();
                                      if (hasPermission) {
                                        BlocProvider.of<ClinicalRecordCubit>(
                                                context)
                                            .crDownloadPath(
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
                      const SizedBox(
                        height: 24,
                      ),
                    ],
                    const SizedBox(
                      height: 24,
                    ),
                    const SectionDivider(),
                    const SizedBox(
                      height: 24,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      padding: const EdgeInsets.only(
                        bottom: 20,
                        left: 20,
                        right: 20,
                      ),
                      decoration: BoxDecoration(
                        color: scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                              offset: const Offset(0, 0),
                              spreadRadius: 0,
                              blurRadius: 6,
                              color: const Color(0xFFD4D4D4).withOpacity(.25)),
                          BoxShadow(
                              offset: const Offset(0, 4),
                              spreadRadius: 0,
                              blurRadius: 24,
                              color: const Color(0xFFD4D4D4).withOpacity(.25)),
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
                                const SizedBox(
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
                            padding: const EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 12,
                            ),
                            child: state.detailClinicalRecordModel!
                                        .verificationStatus ==
                                    'VERIFIED'
                                ? Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.verified,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(
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
                                        padding: const EdgeInsets.all(4.0),
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white),
                                        child: const Icon(
                                          Icons.close_rounded,
                                          color: errorColor,
                                          size: 12,
                                        ),
                                      ),
                                      const SizedBox(
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
                          const SizedBox(
                            height: 12,
                          ),
                          const ItemDivider(),
                          const SizedBox(
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
                            const SizedBox(
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
                              unratedColor: const Color(0xFFCED8EE),
                              itemPadding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: primaryColor,
                              ),
                              onRatingUpdate: (rating) {},
                            ),
                            Text(
                              Utils.rateToText(state
                                  .detailClinicalRecordModel!.rating!
                                  .toInt()),
                              style: textTheme.bodyLarge
                                  ?.copyWith(color: primaryColor),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            const ItemDivider(),
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              'Feedback',
                              style: textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
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
                                      style: const TextStyle(
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
                                        style: const TextStyle(
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
                            const SizedBox(
                              height: 24,
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (state.detailClinicalRecordModel!.verificationStatus !=
                        'VERIFIED') ...[
                      const SizedBox(
                        height: 12,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        width: MediaQuery.of(context).size.width,
                        child: FilledButton.icon(
                          onPressed: () => showDialog(
                              context: context,
                              barrierLabel: '',
                              barrierDismissible: false,
                              builder: (_) => VerifyClinicalRecordDialog(
                                    id: widget.id,
                                  )).then((value) {}),
                          icon: const Icon(Icons.verified),
                          label: const Text('Verify'),
                        ),
                      ),
                    ],
                    const SizedBox(
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
