// ignore_for_file: use_build_context_synchronously

import 'package:common/features/file/file_management.dart';
import 'package:core/context/navigation_extension.dart';
import 'package:core/helpers/utils.dart';
import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:data/models/units/active_unit_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:main/blocs/scientific_session_cubit/scientific_session_cubit.dart';
import 'package:main/blocs/scientific_session_supervisor_cubit/scientific_session_supervisor_cubit.dart';
import 'package:main/blocs/student_cubit/student_cubit.dart';
import 'package:main/widgets/custom_loading.dart';
import 'package:main/widgets/dividers/item_divider.dart';
import 'package:main/widgets/dividers/section_divider.dart';
import 'package:main/widgets/headers/form_section_header.dart';
import 'package:main/widgets/verify_dialog.dart';
import 'package:path/path.dart' as p;
import 'package:students/features/scientific_session/add_scientific_session_page.dart';

class DetailScientificSessionPage extends StatefulWidget {
  final String id;
  final ActiveDepartmentModel? activeDepartmentModel;
  const DetailScientificSessionPage(
      {super.key, required this.id, this.activeDepartmentModel});

  @override
  State<DetailScientificSessionPage> createState() =>
      _DetailScientificSessionPageState();
}

class _DetailScientificSessionPageState
    extends State<DetailScientificSessionPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ScientificSessionSupervisorCubit>(context)
        .getScientificSessionDetail(id: widget.id);
  }

  @override
  Widget build(BuildContext context) {
    final cr = context.watch<ScientificSessionSupervisorCubit>().state;

    return BlocListener<ScientificSessionCubit, ScientifcSessionState>(
      listener: (context, state) {
        if (state.postSuccess) {
          Future.microtask(() =>
              BlocProvider.of<ScientificSessionSupervisorCubit>(context)
                  .getScientificSessionDetail(id: widget.id));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Entry Detail"),
          actions: [
            if (cr.detail != null &&
                cr.detail?.verificationStatus != "VERIFIED" &&
                widget.activeDepartmentModel != null)
              PopupMenuButton<String>(
                icon: const Icon(
                  Icons.more_vert_rounded,
                ),
                onSelected: (value) {
                  if (value == 'Delete') {
                    showDialog(
                      context: context,
                      barrierLabel: '',
                      barrierDismissible: false,
                      builder: (_) => VerifyDialog(
                        onTap: () {
                          BlocProvider.of<ScientificSessionCubit>(context)
                              .deleteScientificSessionById(id: widget.id);
                          BlocProvider.of<StudentCubit>(context)
                              .getStudentScientificSessionOfActiveDepartment();
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                      ),
                    );
                  }

                  if (value == 'Edit') {
                    cr.detail?.id = widget.id;
                    context.navigateTo(AddScientificSessionPage(
                      activeDepartmentModel: widget.activeDepartmentModel!,
                      detail: cr.detail,
                    ));
                  }
                },
                itemBuilder: (BuildContext context) {
                  return <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'Edit',
                      child: Text('Edit'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'Delete',
                      child: Text('Delete'),
                    ),
                  ];
                },
              ),
          ],
        ).variant(),
        body: SafeArea(
          child: BlocBuilder<ScientificSessionSupervisorCubit,
              ScientificSessionSupervisorState>(
            builder: (context, state) {
              if (state.detail == null) {
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
                                'assets/icons/biotech_rounded.svg'),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Scientific Session',
                                style: textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                state.detail!.sessionType ?? '',
                                style: textTheme.bodyMedium?.copyWith(
                                  color: primaryColor,
                                  height: 1,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                Utils.datetimeToString(
                                  state.detail!.updatedAt ?? DateTime.now(),
                                ),
                                style: textTheme.bodyMedium?.copyWith(
                                  color: secondaryTextColor,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SectionDivider(),
                    const SizedBox(
                      height: 24,
                    ),
                    Container(
                      width: double.infinity,
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
                          Text(
                            'Student',
                            style: textTheme.bodyMedium?.copyWith(
                              color: secondaryTextColor,
                            ),
                          ),
                          Text(
                            state.detail!.studentName ?? '',
                            style: textTheme.titleMedium?.copyWith(
                              color: primaryTextColor,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            'Supervisor',
                            style: textTheme.bodyMedium?.copyWith(
                              color: secondaryTextColor,
                            ),
                          ),
                          Text(
                            state.detail!.supervisorName ?? '',
                            style: textTheme.titleMedium?.copyWith(
                              color: primaryTextColor,
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Text(
                            'Role',
                            style: textTheme.bodyMedium?.copyWith(
                              color: secondaryTextColor,
                            ),
                          ),
                          Text(
                            state.detail!.role ?? '',
                            style: textTheme.titleMedium?.copyWith(
                              color: primaryTextColor,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            'Topic',
                            style: textTheme.bodyMedium?.copyWith(
                              color: secondaryTextColor,
                            ),
                          ),
                          Text(
                            state.detail!.topic ?? '',
                            style: textTheme.titleMedium?.copyWith(
                              color: primaryTextColor,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            'Title',
                            style: textTheme.bodyMedium?.copyWith(
                              color: secondaryTextColor,
                            ),
                          ),
                          Text(
                            state.detail!.title ?? '',
                            style: textTheme.titleMedium?.copyWith(
                              color: primaryTextColor,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            'Reference',
                            style: textTheme.bodyMedium?.copyWith(
                              color: secondaryTextColor,
                            ),
                          ),
                          Text(
                            state.detail!.reference ?? '',
                            style: textTheme.titleMedium?.copyWith(
                              color: primaryTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (state.detail!.attachment != null) ...[
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
                                label: 'Attachment',
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
                                        BlocProvider.of<ScientificSessionCubit>(
                                                context)
                                            .downloadAttachment(
                                                id: widget.id,
                                                filename:
                                                    '${p.basename(state.detail!.attachment!)}.pdf');
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
                    ],
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
                        children: [
                          Container(
                            width: double.infinity,
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
                                  state.detail!.verificationStatus == 'VERIFIED'
                                      ? 'Entry details have been verified by supervisor'
                                      : 'Waiting for verification from the supervisor',
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
                              color:
                                  state.detail!.verificationStatus == 'VERIFIED'
                                      ? Colors.green
                                      : errorColor,
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 12,
                            ),
                            child: state.detail!.verificationStatus ==
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
                          if (state.detail!.verificationStatus ==
                              'VERIFIED') ...[
                            const SizedBox(
                              height: 12,
                            ),
                            const ItemDivider(),
                            const SizedBox(
                              height: 16,
                            ),
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
                              initialRating: state.detail!.rating!.toDouble(),
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              ignoreGestures: true,
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
                              '"Good"',
                              style: textTheme.bodyLarge
                                  ?.copyWith(color: primaryColor),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                          ],
                        ],
                      ),
                    ),
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
