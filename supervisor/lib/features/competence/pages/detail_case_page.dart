import 'package:core/helpers/app_size.dart';
import 'package:core/helpers/utils.dart';
import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:main/blocs/clinical_record_cubit/clinical_record_cubit.dart';
import 'package:main/blocs/competence_cubit/competence_cubit.dart';
import 'package:main/widgets/chip_verified.dart';
import 'package:main/widgets/custom_alert.dart';
import 'package:main/widgets/custom_loading.dart';
import 'package:main/widgets/dividers/item_divider.dart';
import 'package:main/widgets/headers/unit_student_header.dart';
import 'package:main/widgets/spacing_column.dart';
import 'package:supervisor/features/competence/pages/widgets/verify_case_dialog.dart';
import 'widgets/verify_skill_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailCasePage extends StatefulWidget {
  final String studentId;
  final String unitName;
  final String studentName;
  final bool isStudent;
  final String id;
  const DetailCasePage(
      {super.key,
      required this.id,
      this.isStudent = false,
      required this.studentName,
      required this.unitName,
      required this.studentId});

  @override
  State<DetailCasePage> createState() => _DetailCasePageState();
}

class _DetailCasePageState extends State<DetailCasePage> {
  @override
  void initState() {
    Future.microtask(() {
      BlocProvider.of<CompetenceCubit>(context).getCaseById(
        id: widget.id,
      );
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CompetenceCubit, CompetenceState>(
      listener: (context, state) {
        if (state.isSkillSuccessVerify) {
          BlocProvider.of<CompetenceCubit>(context).getCaseById(
            id: widget.id,
          );
          BlocProvider.of<CompetenceCubit>(context).getCaseStudents(
            page: 1,
          );
          CustomAlert.success(message: "Success Verify Case", context: context);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Submitted Case"),
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              await Future.wait([
                BlocProvider.of<CompetenceCubit>(context).getCaseById(
                  id: widget.id,
                ),
              ]);
            },
            child: SafeArea(
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    sliver: Builder(
                      builder: (context) {
                        if (state.requestState == RequestState.loading) {
                          return const SliverFillRemaining(
                              child: CustomLoading());
                        } else if (state.caseDetailModel != null) {
                          final data = state.caseDetailModel!;
                          return SliverToBoxAdapter(
                            child: SpacingColumn(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              onlyPading: true,
                              horizontalPadding: 16,
                              children: [
                                StudentDepartmentHeader(
                                    unitName: widget.unitName,
                                    studentId: widget.studentId,
                                    studentName: widget.studentName),
                                const SizedBox(
                                  height: 12,
                                ),
                                const ItemDivider(),
                                TestGradeScoreCard(
                                  id: data.caseId!,
                                  studentId: widget.studentId,
                                  skillName: data.caseName ?? '',
                                  skillType: data.caseType!,
                                  isVerified:
                                      data.verificationStatus == 'VERIFIED',
                                  createdAt: data.createdAt ?? 0,
                                  isStudent: widget.isStudent,
                                ),
                                const SizedBox(
                                  height: 48,
                                ),
                              ],
                            ),
                          );
                        } else {
                          return const SliverFillRemaining(
                            child: CustomLoading(),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class TestGradeScoreCard extends StatelessWidget {
  const TestGradeScoreCard({
    super.key,
    required this.skillName,
    required this.skillType,
    required this.isVerified,
    required this.id,
    required this.createdAt,
    required this.studentId,
    required this.isStudent,
  });

  final String skillName;
  final String id;
  final String studentId;
  final String skillType;
  final int createdAt;
  final bool isVerified;
  final bool isStudent;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 65,
      ),
      child: Container(
        width: AppSize.getAppWidth(context),
        padding: const EdgeInsets.all(12),
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
            ]),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 2),
                width: 5,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      skillName,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                    ),
                    Text(
                      skillType,
                      style: textTheme.bodySmall?.copyWith(
                        color: primaryColor,
                      ),
                    ),
                    Text(
                      'Submitted at : ${Utils.epochToStringDate(startTime: createdAt ~/ 1000)}',
                      style: textTheme.bodySmall?.copyWith(
                        color: secondaryTextColor,
                      ),
                    ),
                    if (isVerified) ...[
                      const SizedBox(
                        height: 4,
                      ),
                      const ChipVerified(),
                    ],
                    if (!isVerified && !isStudent) ...[
                      const SizedBox(
                        height: 4,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: FilledButton(
                          onPressed: () => showDialog(
                              context: context,
                              barrierLabel: '',
                              barrierDismissible: false,
                              builder: (_) => VerifyCaseDialog(
                                    id: id,
                                  )).then((value) {}),
                          child: const Text('Verify Skill'),
                        ),
                      ),
                    ]
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
