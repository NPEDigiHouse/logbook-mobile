// ignore_for_file: use_build_context_synchronously

import 'dart:ui' as ui;

import 'package:common/pdf_helper/pdf_helper.dart';
import 'package:core/helpers/asset_path.dart';
import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:data/models/supervisors/supervisor_student_model.dart';
import 'package:main/blocs/student_cubit/student_cubit.dart';
import 'package:main/helpers/helper.dart';
import 'package:main/widgets/custom_alert.dart';
import 'package:main/widgets/custom_loading.dart';
import 'package:main/widgets/inkwell_container.dart';
import 'package:main/widgets/spacing_column.dart';
import 'package:main/widgets/statistics/unit_statistics_card.dart';
import 'package:main/widgets/statistics/unit_statistics_section.dart';

import '../widgets/head_resident_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DetailProfileStudentPage extends StatefulWidget {
  final SupervisorStudent student;
  const DetailProfileStudentPage({super.key, required this.student});

  @override
  State<DetailProfileStudentPage> createState() =>
      _DetailProfileStudentPageState();
}

class _DetailProfileStudentPageState extends State<DetailProfileStudentPage> {
  final GlobalKey keyCase = GlobalKey(debugLabel: 'keyCase');
  final GlobalKey keySkill = GlobalKey(debugLabel: 'keySkill');
  late ScrollController _scrollController;
  final ValueNotifier<String> title = ValueNotifier('Entry Details');
  late Uint8List image;

  void loadImageFromAssets(String path) async {
    final ByteData data = await rootBundle.load(path);
    final List<int> listBytes = data.buffer.asUint8List();
    final Uint8List bytes = Uint8List.fromList(listBytes);
    image = bytes;
  }

  Future<Uint8List> captureWidget(GlobalKey k) async {
    RenderRepaintBoundary boundary =
        k.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();
    return pngBytes;
  }

  @override
  void initState() {
    super.initState();
    loadImageFromAssets(AssetPath.getImage('logo_umi.png'));
    BlocProvider.of<StudentCubit>(context)
        .getStudentDetailById(studentId: widget.student.studentId!);
    // ..getStatisticByStudentId(studentId: widget.student.studentId!);
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels < 160) {
        title.value = 'Entry Details';
      } else if (_scrollController.position.pixels >= 160) {
        title.value = widget.student.studentId ?? '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            ...getHeadSection(
                title: title,
                subtitle: 'Detail Profile',
                student: widget.student),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          offset: const Offset(0, 0),
                          spreadRadius: 0,
                          blurRadius: 6,
                          color: const Color(0xFFD4D4D4).withOpacity(.25),
                        ),
                        BoxShadow(
                          offset: const Offset(0, 4),
                          spreadRadius: 0,
                          blurRadius: 24,
                          color: const Color(0xFFD4D4D4).withOpacity(.25),
                        ),
                      ],
                    ),
                    child: BlocBuilder<StudentCubit, StudentState>(
                      builder: (context, state) {
                        if (state.studentDetail != null) {
                          return SpacingColumn(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Student Name',
                                style: textTheme.bodyMedium?.copyWith(
                                  color: secondaryTextColor,
                                ),
                              ),
                              Text(
                                widget.student.studentName ?? '',
                                style: textTheme.titleMedium?.copyWith(
                                  color: primaryTextColor,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                'Email',
                                style: textTheme.bodyMedium?.copyWith(
                                  color: secondaryTextColor,
                                ),
                              ),
                              Text(
                                state.studentDetail!.email ?? '-',
                                style: textTheme.titleMedium?.copyWith(
                                  color: primaryTextColor,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                            ],
                          );
                        }
                        return const CustomLoading();
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 16,
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverToBoxAdapter(
                child: BlocBuilder<StudentCubit, StudentState>(
                    builder: (context, state) {
                  if (state.studentStatistic != null) {
                    final stData = state.studentStatistic!;
                    return Column(
                      children: [
                        InkWellContainer(
                          onTap: () async {
                            final caseImage = await captureWidget(keyCase);
                            final skillImage = await captureWidget(keySkill);
                            final data = await PdfHelper.generate(
                                image: image,
                                profilePhoto: widget.student.profileImage,
                                caseStat: caseImage,
                                skillStat: skillImage,
                                data: state.studentStatistic,
                                activeUnitName:
                                    widget.student.activeDepartmentName);
                            if (data != null) {
                              CustomAlert.success(
                                  message: 'Success Download Student Statistic',
                                  context: context);
                            }
                          },
                          color: scaffoldBackgroundColor,
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              offset: const Offset(0, 1),
                              blurRadius: 16,
                              color: Colors.black.withOpacity(.1),
                            ),
                          ],
                          radius: 12,
                          padding: const EdgeInsets.fromLTRB(12, 16, 6, 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Icon(Icons.print_rounded),
                              const SizedBox(
                                width: 12,
                              ),
                              Text(
                                'Download Statistic',
                                style: textTheme.bodyLarge?.copyWith(),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        DepartmentStatisticsCard(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              if (stData.finalScore != null) ...[
                                const SizedBox(
                                  height: 12,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24.0),
                                  child: Row(
                                    children: <Widget>[
                                      SvgPicture.asset(
                                        AssetPath.getIcon(
                                            'icon_final_grade.svg'),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          'Final Score',
                                          style:
                                              textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Builder(builder: (context) {
                                  final scoreData = getTotalGrades(
                                      (stData.finalScore?.finalScore ?? 0.0)
                                          .toDouble());
                                  return Container(
                                    width: double.infinity,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 24),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 12),
                                    decoration: BoxDecoration(
                                      color: scoreData?.gradientScore.color,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Text(
                                            scoreData!.gradientScore.title,
                                            style:
                                                textTheme.titleLarge?.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            scoreData.value.toInt().toString(),
                                            style:
                                                textTheme.bodyMedium?.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  child: Divider(
                                    height: 6,
                                    thickness: 6,
                                    color: onDisableColor,
                                  ),
                                ),
                              ],
                              DepartmentStatisticsSection(
                                repaintKey: keySkill,
                                titleText: 'Diagnosis Skills',
                                titleIconPath: 'skill_outlined.svg',
                                percentage: (stData.verifiedSkills! /
                                        stData.totalSkills!) *
                                    100,
                                statistics: {
                                  'Total Diagnosis Skill': stData.totalSkills!,
                                  'Performed': stData.verifiedSkills,
                                  'Not Performed': stData.totalSkills! -
                                      stData.verifiedSkills!,
                                },
                                detailStatistics: {
                                  1: [
                                    ...stData.skills!
                                        .map((e) => e.skillName ?? '')
                                        .toList(),
                                  ],
                                },
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Divider(
                                  height: 6,
                                  thickness: 6,
                                  color: onDisableColor,
                                ),
                              ),
                              DepartmentStatisticsSection(
                                repaintKey: keyCase,
                                titleText: 'Acquired Cases',
                                titleIconPath:
                                    'attach_resume_male_outlined.svg',
                                percentage: (stData.verifiedCases! /
                                        stData.totalCases!) *
                                    100,
                                statistics: {
                                  'Total Acquired Case': stData.totalCases,
                                  'Identified Case': stData.verifiedCases,
                                  'Unidentified Case': stData.totalCases! -
                                      stData.verifiedCases!,
                                },
                                detailStatistics: {
                                  1: [
                                    ...stData.cases!
                                        .map((e) => e.caseName ?? '')
                                        .toList(),
                                  ],
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                  return const CustomLoading();
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
