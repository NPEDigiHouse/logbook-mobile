import 'package:core/context/navigation_extension.dart';
import 'package:core/helpers/app_size.dart';
import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:data/models/assessment/mini_cex_detail_model.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:main/blocs/assesment_cubit/assesment_cubit.dart';
import 'package:main/helpers/helper.dart';
import 'package:main/widgets/clip_donut_painter.dart';
import 'package:main/widgets/custom_loading.dart';
import 'package:main/widgets/dividers/item_divider.dart';
import 'package:main/widgets/dividers/section_divider.dart';
import 'package:main/widgets/headers/form_section_header.dart';
import 'package:main/widgets/headers/unit_student_header.dart';
import 'package:main/widgets/inputs/build_text_field.dart';
import 'package:main/widgets/spacing_column.dart';

import '../providers/mini_cex_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:semicircle_indicator/semicircle_indicator.dart';

class SupervisorMiniCexDetailPage extends StatefulWidget {
  final String id;
  final String supervisorId;
  const SupervisorMiniCexDetailPage(
      {super.key, required this.id, required this.supervisorId});

  @override
  State<SupervisorMiniCexDetailPage> createState() =>
      _SupervisorMiniCexDetailPageState();
}

class _SupervisorMiniCexDetailPageState
    extends State<SupervisorMiniCexDetailPage> {
  late GlobalKey<FormBuilderState> _formKey;

  @override
  void initState() {
    _formKey = GlobalKey<FormBuilderState>();

    Future.microtask(
      () {
        BlocProvider.of<AssesmentCubit>(context).getMiniCexStudentDetail(
          id: widget.id,
        );
        context.read<MiniCexProvider>().reset();
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _formKey.currentState?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final itemRating = context.read<MiniCexProvider>();
    return FormBuilder(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Mini Cex"),
        ).variant(),
        floatingActionButton: BlocBuilder<AssesmentCubit, AssesmentState>(
          builder: (context, state) {
            if (state.miniCexStudentDetail != null &&
                state.miniCexStudentDetail!.examinerDPKId ==
                    widget.supervisorId) {
              return SizedBox(
                width: AppSize.getAppWidth(context) - 32,
                child: FilledButton.icon(
                  onPressed: () {
                    if (_formKey.currentState!.saveAndValidate()) {
                      itemRating.getMiniCexData();
                      BlocProvider.of<AssesmentCubit>(context).assesmentMiniCex(
                        id: widget.id,
                        miniCex: {
                          'scores': itemRating.getMiniCexData(),
                        },
                      );
                    }
                  },
                  icon: const Icon(Icons.check_circle),
                  label: const Text('Update Changed'),
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await Future.wait([
              BlocProvider.of<AssesmentCubit>(context).getMiniCexStudentDetail(
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
                      if (state.isAssesmentMiniCexSuccess) {
                        BlocProvider.of<AssesmentCubit>(context)
                            .getMiniCexStudentDetail(
                          id: widget.id,
                        );
                        context.read<MiniCexProvider>().reset();
                      }
                    },
                    builder: (context, state) {
                      if (state.miniCexStudentDetail != null) {
                        final miniCex = state.miniCexStudentDetail!;
                        return BuildScoreSection(
                          miniCex: miniCex,
                          supervisorId: widget.supervisorId,
                        );
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

class BuildScoreSection extends StatefulWidget {
  const BuildScoreSection({
    super.key,
    required this.miniCex,
    required this.supervisorId,
  });

  final MiniCexStudentDetailModel miniCex;
  final String supervisorId;

  @override
  State<BuildScoreSection> createState() => _BuildScoreSectionState();
}

class _BuildScoreSectionState extends State<BuildScoreSection> {
  @override
  void initState() {
    super.initState();
    if (widget.miniCex.scores != null) {
      Provider.of<MiniCexProvider>(context, listen: false)
          .init(widget.miniCex.scores!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final itemRating = context.watch<MiniCexProvider>();

    return Column(
      children: [
        StudentDepartmentHeader(
          unitName: widget.miniCex.unitName ?? '',
          studentId: widget.miniCex.studentId,
          studentName: widget.miniCex.studentName ?? '',
        ),
        const SizedBox(
          height: 12,
        ),
        MiniCexHeadCard(miniCex: widget.miniCex),
        const SizedBox(
          height: 12,
        ),
        TopStatCard(
          title: 'Total Grades',
          totalGrade: itemRating.getTotalGrades(),
        ),
        const SizedBox(
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
                  const Spacer(),
                  if (widget.supervisorId == widget.miniCex.examinerDPKId)
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: IconButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(primaryColor),
                        ),
                        padding: const EdgeInsets.all(0.0),
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
                        icon: const Icon(
                          Icons.add_rounded,
                          color: backgroundColor,
                          size: 16,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              const ItemDivider(),
              const SizedBox(
                height: 16,
              ),
              ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    if (widget.miniCex.examinerDPKId == widget.supervisorId) {
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
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: BuildTextField(
                                  label: 'Score',
                                  controller:
                                      itemRating.items[index].scoreController,
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.max(100),
                                    FormBuilderValidators.min(0),
                                  ]),
                                  onChanged: (v) {
                                    itemRating.updateScore(
                                        v.isNotEmpty ? double.parse(v) : 0.0,
                                        itemRating.items[index].id!);
                                  },
                                  isOnlyNumber: true,
                                ),
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              IconButton(
                                onPressed: () {
                                  itemRating.removeItemRating(
                                      itemRating.items[index].id!);
                                },
                                icon: const Icon(Icons.delete),
                              ),
                            ],
                          ),
                        ],
                      );
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: itemRating.items[index].titleController,
                          decoration: const InputDecoration(
                            label: Text('Item Name'),
                          ),
                          readOnly: true,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        TextFormField(
                          controller: itemRating.items[index].scoreController,
                          decoration: const InputDecoration(
                            label: Text('Score'),
                          ),
                          readOnly: true,
                        ),
                      ],
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Column(
                      children: [
                        SizedBox(
                          height: 12,
                        ),
                        ItemDivider(),
                        SizedBox(
                          height: 12,
                        ),
                      ],
                    );
                  },
                  itemCount: itemRating.items.length),
            ],
          ),
        ),
        const SizedBox(
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
                SemicircularIndicator(
                  contain: true,
                  radius: 100,
                  progress: totalGrade != null ? totalGrade!.value : 0,
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
                        totalGrade != null
                            ? 'Avg : ${(totalGrade!.value * 100).toStringAsFixed(2)}'
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

class MiniCexHeadCard extends StatelessWidget {
  const MiniCexHeadCard({
    super.key,
    required this.miniCex,
  });

  final MiniCexStudentDetailModel miniCex;

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
              label: 'Mini-CEX Detail',
              pathPrefix: 'icon_test.svg',
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
                  miniCex.dataCase ?? '',
                  style: textTheme.titleMedium?.copyWith(
                    color: primaryTextColor,
                    height: 1,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  'Examiner DPK',
                  style:
                      textTheme.bodyMedium?.copyWith(color: secondaryTextColor),
                ),
                Text(
                  miniCex.examinerDPKName ?? '',
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
                  miniCex.location ?? '',
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
