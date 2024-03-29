import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/presentation/blocs/scientific_session_supervisor_cubit/scientific_session_supervisor_cubit.dart';
import 'package:elogbook/src/presentation/features/supervisor/scientific_session/widgets/verify_dialog.dart';
import 'package:elogbook/src/presentation/widgets/custom_loading.dart';
import 'package:elogbook/src/presentation/widgets/dividers/item_divider.dart';
import 'package:elogbook/src/presentation/widgets/dividers/section_divider.dart';
import 'package:elogbook/src/presentation/widgets/headers/form_section_header.dart';
import 'package:elogbook/src/presentation/widgets/headers/unit_student_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DetailScientificSessionPage extends StatefulWidget {
  final String id;
  final String? unitName;
  const DetailScientificSessionPage(
      {super.key, required this.id, this.unitName});

  @override
  State<DetailScientificSessionPage> createState() =>
      _DetailScientificSessionPageState();
}

class _DetailScientificSessionPageState
    extends State<DetailScientificSessionPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<ScientificSessionSupervisorCubit>(context)
      ..getScientificSessionDetail(id: widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Entry Detail"),
        actions: [
          // IconButton(
          //   onPressed: () {},
          //   icon: Icon(
          //     Icons.more_vert_rounded,
          //     color: Colors.white,
          //   ),
          // )
        ],
      ).variant(),
      body: SafeArea(
        child: BlocBuilder<ScientificSessionSupervisorCubit,
            ScientificSessionSupervisorState>(
          builder: (context, state) {
            if (state.detail == null) {
              return CustomLoading();
            }
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
                                'Scientific Session',
                                style: textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${state.detail!.sessionType ?? ''}',
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: StudentDepartmentHeader(
                        studentName: state.detail?.studentName ?? '',
                        unitName: state.detail?.unit ?? '',
                        supervisorName: state.detail?.supervisorName ?? '',
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(horizontal: 24),
                      padding: EdgeInsets.symmetric(horizontal: 20),
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
                          SizedBox(
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
                          SizedBox(
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
                          SizedBox(
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
                          SizedBox(
                            height: 20,
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
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(56),
                              color:
                                  state.detail!.verificationStatus == 'VERIFIED'
                                      ? Colors.green
                                      : errorColor,
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 12,
                            ),
                            child: state.detail!.verificationStatus ==
                                    'VERIFIED'
                                ? Center(
                                    child: Row(
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
                                    ),
                                  )
                                : Center(
                                    child: Row(
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
                          ),
                          if (state.detail!.verificationStatus ==
                              'VERIFIED') ...[
                            SizedBox(
                              height: 12,
                            ),
                            ItemDivider(),
                            SizedBox(
                              height: 16,
                            ),
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
                              initialRating: state.detail!.rating!.toDouble(),
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              ignoreGestures: true,
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
                              '\"Good\"',
                              style: textTheme.bodyLarge
                                  ?.copyWith(color: primaryColor),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (state.detail!.verificationStatus != 'VERIFIED') ...[
                      SizedBox(
                        height: 12,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        width: MediaQuery.of(context).size.width,
                        child: FilledButton.icon(
                          onPressed: () => showDialog(
                              context: context,
                              barrierLabel: '',
                              barrierDismissible: false,
                              builder: (_) => VerifyScientificSessionDialog(
                                    id: widget.id,
                                  )).then((value) {}),
                          icon: Icon(Icons.verified),
                          label: Text('Verify'),
                        ),
                      ),
                    ],
                    SizedBox(
                      height: 24,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
