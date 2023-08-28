import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/helpers/app_size.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/data/models/assessment/mini_cex_detail_model.dart';
import 'package:elogbook/src/presentation/features/students/assesment/pages/widgets/clip_donut_painter.dart';
import 'package:elogbook/src/presentation/features/supervisor/assesment/providers/mini_cex_provider.dart';
import 'package:elogbook/src/presentation/widgets/dividers/item_divider.dart';
import 'package:elogbook/src/presentation/widgets/dividers/section_divider.dart';
import 'package:elogbook/src/presentation/widgets/headers/unit_header.dart';
import 'package:elogbook/src/presentation/widgets/inputs/build_text_field.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:semicircle_indicator/semicircle_indicator.dart';

import '../../../../blocs/assesment_cubit/assesment_cubit.dart';

class SupervisorMiniCexDetailPage extends StatefulWidget {
  final String id;
  final String unitName;
  const SupervisorMiniCexDetailPage(
      {super.key, required this.unitName, required this.id});

  @override
  State<SupervisorMiniCexDetailPage> createState() =>
      _SupervisorMiniCexDetailPageState();
}

class _SupervisorMiniCexDetailPageState
    extends State<SupervisorMiniCexDetailPage> {
  @override
  void initState() {
    Future.microtask(
      () {
        BlocProvider.of<AssesmentCubit>(context)
          ..getMiniCexStudentDetail(
            id: widget.id,
          );
        context.read<MiniCexProvider>()..reset();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final itemRating = context.read<MiniCexProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text("Mini Cex"),
      ).variant(),
      floatingActionButton: SizedBox(
        width: AppSize.getAppWidth(context) - 32,
        child: FilledButton.icon(
          onPressed: () {
            itemRating.getMiniCexData();
            BlocProvider.of<AssesmentCubit>(context)
              ..assesmentMiniCex(
                id: widget.id,
                miniCex: {
                  'scores': itemRating.getMiniCexData(),
                },
              );
          },
          icon: Icon(Icons.check_circle),
          label: Text('Update Changed'),
        ),
      ),
      body: SingleChildScrollView(
        child: SpacingColumn(
            crossAxisAlignment: CrossAxisAlignment.start,
            horizontalPadding: 16,
            spacing: 12,
            children: [
              SizedBox(
                height: 16,
              ),
              UnitHeader(unitName: 'Unit Name'),
              BlocConsumer<AssesmentCubit, AssesmentState>(
                listener: (context, state) {
                  if (state.isAssesmentMiniCexSuccess) {
                    BlocProvider.of<AssesmentCubit>(context)
                      ..getMiniCexStudentDetail(
                        id: widget.id,
                      );
                    context.read<MiniCexProvider>()..reset();
                  }
                },
                builder: (context, state) {
                  if (state.miniCexStudentDetail != null) {
                    final miniCex = state.miniCexStudentDetail!;

                    return BuildScoreSection(
                      miniCex: miniCex,
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ]),
      ),
    );
  }
}

class BuildScoreSection extends StatefulWidget {
  const BuildScoreSection({
    super.key,
    required this.miniCex,
  });

  final MiniCexStudentDetailModel miniCex;

  @override
  State<BuildScoreSection> createState() => _BuildScoreSectionState();
}

class _BuildScoreSectionState extends State<BuildScoreSection> {
  @override
  void initState() {
    super.initState();
    if (widget.miniCex.scores != null) {
      Provider.of<MiniCexProvider>(context, listen: false)
        ..init(widget.miniCex.scores!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final itemRating = context.watch<MiniCexProvider>();

    return Column(
      children: [
        MiniCexHeadCard(miniCex: widget.miniCex),
        SizedBox(
          height: 12,
        ),
        TopStatCard(
          title: 'Total Grades',
          totalGrade: itemRating.getTotalGrades(),
        ),
        SizedBox(
          height: 16,
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 12,
          ),
          decoration: BoxDecoration(
            color: scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: <BoxShadow>[
              BoxShadow(
                offset: const Offset(0, 1),
                blurRadius: 16,
                color: Colors.black.withOpacity(.1),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Item Ratings',
                    style: textTheme.titleMedium,
                  ),
                  Spacer(),
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
                      onPressed: () {
                        itemRating.addItemRating(
                          ItemRatingModel(
                            gradeItem: '',
                            grade: 0.0,
                            scoreController: TextEditingController(),
                            titleController: TextEditingController(),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.add_rounded,
                        color: backgroundColor,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              ItemDivider(),
              SizedBox(
                height: 16,
              ),
              ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: BuildTextField(
                                controller:
                                    itemRating.items[index].titleController,
                                label: 'Item Name',
                                onChanged: (v) {
                                  itemRating.updateGradeItem(
                                      v, itemRating.items[index].id!);
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: BuildTextField(
                                label: 'Score',
                                controller:
                                    itemRating.items[index].scoreController,
                                onChanged: (v) {
                                  itemRating.updateScore(
                                      v.isNotEmpty ? double.parse(v) : 0.0,
                                      itemRating.items[index].id!);
                                },
                                isOnlyNumber: true,
                              ),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            IconButton(
                              onPressed: () {
                                itemRating.removeItemRating(
                                    itemRating.items[index].id!);
                              },
                              icon: Icon(Icons.delete),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: 12,
                    );
                  },
                  itemCount: itemRating.items.length),
            ],
          ),
        ),
        SizedBox(
          height: 80,
        ),
      ],
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
                SizedBox(
                  height: 12,
                ),
                Text(
                  title,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                SectionDivider(),
                SizedBox(
                  height: 12,
                ),
                SemicircularIndicator(
                  contain: true,
                  radius: 100,
                  progress: totalGrade != null ? totalGrade!.value : 0,
                  strokeCap: StrokeCap.round,
                  color: totalGrade != null
                      ? totalGrade!.gradientScore.color
                      : onDisableColor,
                  bottomPadding: 0,
                  backgroundColor: Color(0xFFB0EAFC),
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
                        totalGrade != null
                            ? 'Avg : ${(totalGrade!.value * 100).toInt().toString()}'
                            : '-',
                        style: textTheme.bodyMedium?.copyWith(
                          color: secondaryColor,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
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

class MiniCexHeadCard extends StatelessWidget {
  const MiniCexHeadCard({
    super.key,
    required this.miniCex,
  });

  final MiniCexStudentDetailModel miniCex;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 12,
      ),
      decoration: BoxDecoration(
        color: scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: <BoxShadow>[
          BoxShadow(
            offset: const Offset(0, 1),
            blurRadius: 16,
            color: Colors.black.withOpacity(.1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Student Name',
            style: textTheme.bodySmall
                ?.copyWith(color: secondaryTextColor, height: 1),
          ),
          Text(
            miniCex.studentName ?? '',
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 12,
          ),
          Text(
            'Student Id',
            style: textTheme.bodySmall
                ?.copyWith(color: secondaryTextColor, height: 1),
          ),
          Text(
            miniCex.studentId ?? '',
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 12,
          ),
          Text(
            'Case Title',
            style: textTheme.bodySmall
                ?.copyWith(color: secondaryTextColor, height: 1),
          ),
          Text(
            miniCex.dataCase ?? '',
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 12,
          ),
          Text(
            'Location',
            style: textTheme.bodySmall
                ?.copyWith(color: secondaryTextColor, height: 1),
          ),
          Text(
            miniCex.location ?? '',
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
