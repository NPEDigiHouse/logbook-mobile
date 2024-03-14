import 'package:core/context/navigation_extension.dart';
import 'package:core/helpers/app_size.dart';
import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:data/models/assessment/list_scientific_assignment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:main/blocs/assesment_cubit/assesment_cubit.dart';
import 'package:main/blocs/clinical_record_cubit/clinical_record_cubit.dart';
import 'package:main/widgets/clip_donut_painter.dart';
import 'package:main/widgets/custom_loading.dart';
import 'package:main/widgets/dividers/item_divider.dart';
import 'package:main/widgets/dividers/section_divider.dart';
import 'package:main/widgets/empty_data.dart';
import 'package:main/widgets/headers/form_section_header.dart';
import 'package:main/widgets/headers/unit_student_header.dart';
import 'package:main/widgets/spacing_column.dart';
import 'package:semicircle_indicator/semicircle_indicator.dart';

import '../providers/scientific_assignment_provider.dart';

class SupervisorScientificAssignmentDetailPage extends StatefulWidget {
  final String id;
  final String supervisorId;

  const SupervisorScientificAssignmentDetailPage(
      {super.key, required this.id, required this.supervisorId});

  @override
  State<SupervisorScientificAssignmentDetailPage> createState() =>
      _SupervisorScientificAssignmentDetailPageState();
}

class _SupervisorScientificAssignmentDetailPageState
    extends State<SupervisorScientificAssignmentDetailPage> {
  late GlobalKey<FormBuilderState> _formKey;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _formKey.currentState?.dispose();
  }

  @override
  void initState() {
    _formKey = GlobalKey<FormBuilderState>();
    Future.microtask(() => {
          BlocProvider.of<AssesmentCubit>(context)
            ..getScientiicAssignmentDetail(
              id: widget.id,
            )
            ..getScientificGradeItems(),
          context.read<ScientificAssignmentProvider>().reset()
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ScientificAssignmentProvider>();
    return FormBuilder(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Scientific Assignment"),
        ).variant(),
        floatingActionButton: BlocBuilder<AssesmentCubit, AssesmentState>(
          builder: (context, state) {
            if (state.scientificAssignmentDetail != null &&
                state.scientificAssignmentDetail!.supervisingDPKId ==
                    widget.supervisorId) {
              return SizedBox(
                width: AppSize.getAppWidth(context) - 32,
                child: FilledButton.icon(
                  onPressed: () {
                    if (_formKey.currentState!.saveAndValidate()) {
                      BlocProvider.of<AssesmentCubit>(context)
                          .assesmentScientificAssignment(
                        id: widget.id,
                        sa: {
                          'scores': provider.getScientificAssignmentData(),
                        },
                      );
                    }
                  },
                  icon: const Icon(Icons.check_circle),
                  label: const Text('Update Changed'),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await Future.wait([
              BlocProvider.of<AssesmentCubit>(context)
                  .getScientiicAssignmentDetail(
                id: widget.id,
              ),
            ]);
          },
          child: SingleChildScrollView(
            child: SpacingColumn(
                crossAxisAlignment: CrossAxisAlignment.start,
                horizontalPadding: 16,
                spacing: 12,
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  // DepartmentHeader(unitName: widget.unitName),
                  BlocConsumer<AssesmentCubit, AssesmentState>(
                    listener: (context, state) {
                      if (state.isAssementScientificAssignmentSuccess) {
                        provider.reset();
                        BlocProvider.of<AssesmentCubit>(context)
                            .getScientiicAssignmentDetail(
                          id: widget.id,
                        );
                        setState(() {});
                      }
                      if (state.scientificAssignmentDetail != null &&
                          state.stateSa == RequestState.data &&
                          state.scientificGradeItems != null) {
                        if (!provider.isAlreadyInit) {
                          if (state
                              .scientificAssignmentDetail!.scores!.isNotEmpty) {
                            provider.init(
                                state.scientificAssignmentDetail!.scores!);
                          } else {
                            provider.firstInit(state.scientificGradeItems!);
                          }
                        }
                      }
                    },
                    builder: (context, state) {
                      if (state.scientificAssignmentDetail != null &&
                          provider.isAlreadyInit) {
                        return Builder(builder: (context) {
                          if (state.stateSaItem == RequestState.loading) {
                            return const CustomLoading();
                          } else if (state.scientificGradeItems != null) {
                            if (state.scientificGradeItems!.isNotEmpty) {
                              return SpacingColumn(
                                spacing: 12,
                                children: [
                                  StudentDepartmentHeader(
                                    unitName: state.scientificAssignmentDetail!
                                            .unitName ??
                                        '',
                                    studentId: state
                                        .scientificAssignmentDetail!.studentId,
                                    studentName: state
                                            .scientificAssignmentDetail!
                                            .studentName ??
                                        '',
                                  ),
                                  ScientificAssignmentHeadCard(
                                      scientificAssignment:
                                          state.scientificAssignmentDetail!),
                                  TopStatCard(
                                      totalGrade: provider.getTotalGrades(),
                                      title: 'Total Grades'),
                                  ScientificGradeCard(
                                    formKey: _formKey,
                                    title: 'Presentation',
                                    iconPath:
                                        'assets/icons/presentation_icon.svg',
                                    saScores: provider.presentationList,
                                    type: ScientificType.presentation,
                                    canAccess: state.scientificAssignmentDetail!
                                            .supervisingDPKId ==
                                        widget.supervisorId,
                                  ),
                                  ScientificGradeCard(
                                    formKey: _formKey,
                                    title: 'Presentation Style',
                                    iconPath:
                                        'assets/icons/presentation_style_icon.svg',
                                    saScores: provider.presentationStyleList,
                                    type: ScientificType.presentation_style,
                                    canAccess: state.scientificAssignmentDetail!
                                            .supervisingDPKId ==
                                        widget.supervisorId,
                                  ),
                                  ScientificGradeCard(
                                    formKey: _formKey,
                                    title: 'Discussion',
                                    iconPath:
                                        'assets/icons/discussion_icon.svg',
                                    saScores: provider.discussionList,
                                    type: ScientificType.discussion,
                                    canAccess: state.scientificAssignmentDetail!
                                            .supervisingDPKId ==
                                        widget.supervisorId,
                                  ),
                                  const SizedBox(
                                    height: 60,
                                  ),
                                ],
                              );
                            }
                            return const EmptyData(
                              title: 'No Assesment Items',
                              subtitle: 'No Assesment Items',
                            );
                          }
                          return const CustomLoading();
                        });
                      } else {
                        return const CustomLoading();
                      }
                    },
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}

class ScientificGradeCard extends StatelessWidget {
  const ScientificGradeCard({
    super.key,
    required this.title,
    required this.iconPath,
    required this.saScores,
    required this.type,
    required this.canAccess,
    required this.formKey,
  });

  final ScientificType type;
  final List<ItemRatingSA> saScores;
  final String title;
  final String iconPath;
  final bool canAccess;
  final GlobalKey<FormBuilderState> formKey;

  @override
  Widget build(BuildContext context) {
    final pr = context.read<ScientificAssignmentProvider>();
    return Container(
      width: AppSize.getAppWidth(context),
      // padding: EdgeInsets.all(12),
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
          const SizedBox(
            height: 12,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                SvgPicture.asset(iconPath),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  title,
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          const SectionDivider(),
          SpacingColumn(
            horizontalPadding: 16,
            children: [
              for (final data in saScores)
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: primaryColor,
                            ),
                          ),
                          Expanded(child: Text(data.indicator)),
                          SizedBox(
                            width: 50,
                            child: TextFormField(
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.max(100),
                                FormBuilderValidators.min(0),
                              ]),
                              readOnly: !canAccess,
                              textAlign: TextAlign.center,
                              controller: data.scoreController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 6),
                                disabledBorder: InputBorder.none,
                              ),
                              onChanged: (v) {
                                if (v.isNotEmpty) {
                                  pr.updateScore(
                                    grade: double.parse(v),
                                    id: data.id,
                                    type: type,
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const ItemDivider(),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class TopStatCard extends StatelessWidget {
  final String title;
  final TotalGradeHelper? totalGrade;
  const TopStatCard({
    super.key,
    required this.totalGrade,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(16),
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          clipBehavior: Clip.antiAlias,
          children: [
            Positioned(
              bottom: 0,
              left: 8,
              child: CustomPaint(
                size: Size(
                    80,
                    (80 * 1.17)
                        .toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                painter: ClipDonutPainter(),
              ),
            ),
            Column(
              children: [
                const SizedBox(
                  height: 12,
                ),
                Text(
                  title,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                const SectionDivider(),
                const SizedBox(
                  height: 12,
                ),
                if (totalGrade != null)
                  SemicircularIndicator(
                    contain: true,
                    radius: 100,
                    progress: totalGrade != null && !totalGrade!.value.isNaN
                        ? totalGrade!.value
                        : 0,
                    strokeCap: StrokeCap.round,
                    color: totalGrade != null
                        ? totalGrade!.gradientScore.color
                        : onDisableColor,
                    bottomPadding: 0,
                    backgroundColor: const Color(0xFFB0EAFC),
                    child: Column(
                      children: [
                        Text(
                          totalGrade != null
                              ? totalGrade!.gradientScore.title
                              : 'Unknown',
                          style: textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          totalGrade != null && !totalGrade!.value.isNaN
                              ? 'Avg : ${((totalGrade?.value ?? 0) * 100).toStringAsFixed(2)}'
                              : '-',
                          style: textTheme.bodyMedium?.copyWith(
                            color: secondaryColor,
                          ),
                        )
                      ],
                    ),
                  ),
                const SizedBox(
                  height: 16,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ScientificAssignmentHeadCard extends StatelessWidget {
  const ScientificAssignmentHeadCard({
    super.key,
    required this.scientificAssignment,
  });

  final ListScientificAssignment scientificAssignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: <BoxShadow>[
          BoxShadow(
            offset: const Offset(0, 1),
            color: Colors.black.withOpacity(.06),
            blurRadius: 8,
          )
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          iconColor: primaryTextColor,
          collapsedIconColor: primaryTextColor,
          tilePadding: const EdgeInsets.only(
            left: 6,
            right: 10,
          ),
          initiallyExpanded: true,
          childrenPadding: const EdgeInsets.fromLTRB(6, 8, 6, 12),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          expandedAlignment: Alignment.centerLeft,
          title: const FormSectionHeader(
              label: 'Assignment Detail',
              pathPrefix: 'icon_scientific_assignment.svg',
              padding: 0),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Case Title',
                  style:
                      textTheme.bodyMedium?.copyWith(color: secondaryTextColor),
                ),
                Text(
                  scientificAssignment.listScientificAssignmentCase ?? '',
                  style: textTheme.titleMedium?.copyWith(
                    color: primaryTextColor,
                    height: 1,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  'Location',
                  style:
                      textTheme.bodyMedium?.copyWith(color: secondaryTextColor),
                ),
                Text(
                  scientificAssignment.location ?? '',
                  style: textTheme.titleMedium?.copyWith(
                    color: primaryTextColor,
                    height: 1,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  'Supervising DPK',
                  style:
                      textTheme.bodyMedium?.copyWith(color: secondaryTextColor),
                ),
                Text(
                  scientificAssignment.supervisingDPKName ?? '',
                  style: textTheme.titleMedium?.copyWith(
                    color: primaryTextColor,
                    height: 1,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
