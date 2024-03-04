import 'package:core/context/navigation_extension.dart';
import 'package:core/helpers/utils.dart';
import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:main/blocs/clinical_record_cubit/clinical_record_cubit.dart';
import 'package:main/blocs/scientific_session_supervisor_cubit/scientific_session_supervisor_cubit.dart';
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

class SupervisorDetailScientificSessionPage extends StatefulWidget {
  final String id;
  final String? unitName;
  const SupervisorDetailScientificSessionPage(
      {super.key, required this.id, this.unitName});

  @override
  State<SupervisorDetailScientificSessionPage> createState() =>
      _SupervisorDetailScientificSessionPageState();
}

class _SupervisorDetailScientificSessionPageState
    extends State<SupervisorDetailScientificSessionPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ScientificSessionSupervisorCubit>(context)
        .getScientificSessionDetail(id: widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Entry Detail"),
      ).variant(),
      body: SafeArea(
        child: BlocBuilder<ScientificSessionSupervisorCubit,
            ScientificSessionSupervisorState>(
          builder: (context, state) {
            if (state.detailState == RequestState.loading) {
              return const CustomLoading();
            } else if (state.detail != null) {
              return RefreshIndicator(
                onRefresh: () async {
                  await Future.wait([
                    BlocProvider.of<ScientificSessionSupervisorCubit>(context)
                        .getScientificSessionDetail(id: widget.id),
                  ]);
                },
                child: SingleChildScrollView(
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
                          studentName: state.detail?.studentName ?? '',
                          unitName: state.detail?.unit ?? '',
                          supervisorName: state.detail?.supervisorName ?? '',
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
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
                                label: 'Session',
                                pathPrefix: 'biotech_rounded.svg',
                                padding: 0),
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
                            const SizedBox(
                              height: 20,
                            ),
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
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
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
                                ],
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(56),
                                color: state.detail!.verificationStatus ==
                                        'VERIFIED'
                                    ? Colors.green
                                    : errorColor,
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 12,
                              ),
                              child: state.detail!.verificationStatus ==
                                      'VERIFIED'
                                  ? Center(
                                      child: Row(
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
                                            style:
                                                textTheme.bodyMedium?.copyWith(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Center(
                                      child: Row(
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
                                            style:
                                                textTheme.bodyMedium?.copyWith(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
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
                                Utils.rateToText(state.detail?.rating ?? 0),
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
                      if (state.detail!.verificationStatus != 'VERIFIED') ...[
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
                                builder: (_) => VerifyScientificSessionDialog(
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
                ),
              );
            }
            return const CustomLoading();
          },
        ),
      ),
    );
  }
}
