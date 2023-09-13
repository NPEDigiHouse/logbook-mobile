import 'package:elogbook/src/data/models/supervisors/student_unit_model.dart';
import 'package:elogbook/src/presentation/blocs/assesment_cubit/assesment_cubit.dart';
import 'package:elogbook/src/presentation/blocs/supervisor_cubit/supervisors_cubit.dart';
import 'package:elogbook/src/presentation/features/coordinator/weekly_grade/weekly_grade_score_dialog.dart';
import 'package:elogbook/src/presentation/widgets/cards/weekly_grade_card.dart';
import 'package:elogbook/src/presentation/widgets/custom_loading.dart';
import 'package:elogbook/src/presentation/widgets/custom_shimmer.dart';
import 'package:elogbook/src/presentation/widgets/empty_data.dart';
import 'package:elogbook/src/presentation/widgets/profile_pic_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:elogbook/core/helpers/app_size.dart';
import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WeeklyGradeDetailPage extends StatefulWidget {
  final StudentDepartmentModel student;

  const WeeklyGradeDetailPage({super.key, required this.student});

  @override
  State<WeeklyGradeDetailPage> createState() => _WeeklyGradeDetailPageState();
}

class _WeeklyGradeDetailPageState extends State<WeeklyGradeDetailPage> {
  @override
  void initState() {
    BlocProvider.of<AssesmentCubit>(context)
      ..reset()
      ..getWeeklyAssesment(
          studentId: widget.student.studentId!,
          unitId: widget.student.activeDepartmentId!);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: AppSize.getAppHeight(context),
        ),
        child: RefreshIndicator(
          onRefresh: () => Future.wait([
            BlocProvider.of<AssesmentCubit>(context).getWeeklyAssesment(
                studentId: widget.student.studentId!,
                unitId: widget.student.activeDepartmentId!),
          ]),
          child: BlocBuilder<AssesmentCubit, AssesmentState>(
            builder: (context, state) {
              if (state.weeklyAssesment != null) {
                if (state.weeklyAssesment!.assesments!.isNotEmpty)
                  return SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  FutureBuilder(
                                    future: BlocProvider.of<SupervisorsCubit>(
                                            context)
                                        .getImageProfile(
                                            id: widget.student.userId ?? ''),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return CustomShimmer(
                                            child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                          ),
                                          width: 50,
                                          height: 50,
                                        ));
                                      } else if (snapshot.hasError) {
                                        return ProfilePicPlaceholder(
                                            height: 50,
                                            name: widget.student.studentName ??
                                                '-',
                                            isSmall: true,
                                            width: 50);
                                      } else {
                                        return CircleAvatar(
                                          radius: 25,
                                          foregroundImage:
                                              MemoryImage(snapshot.data!),
                                        );
                                      }
                                    },
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          state.weeklyAssesment!.studentName ??
                                              '',
                                          style: textTheme.titleLarge?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          state.weeklyAssesment!.studentId ??
                                              '',
                                          style: const TextStyle(
                                            color: primaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              // const Padding(
                              //   padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                              //   child: Divider(
                              //     height: 1,
                              //     thickness: 1,
                              //     color: Color(0xFFEFF0F9),
                              //   ),
                              // ),
                              // Text(
                              //   'Supervisor',
                              //   style: textTheme.bodySmall?.copyWith(
                              //     fontWeight: FontWeight.bold,
                              //   ),
                              // ),
                              // const SizedBox(height: 4),
                              // Text(
                              //   '',
                              //   style: const TextStyle(
                              //     color: secondaryTextColor,
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          'Weekly Assesments',
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        // const Text(
                        //   'Sort By',
                        //   style: TextStyle(
                        //     fontWeight: FontWeight.bold,
                        //     color: primaryColor,
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: 56,
                        //   child: ListView.separated(
                        //     padding: EdgeInsets.zero,
                        //     scrollDirection: Axis.horizontal,
                        //     itemCount: _menuList.length,
                        //     itemBuilder: (context, index) {
                        //       return ValueListenableBuilder(
                        //         valueListenable: _selectedMenu,
                        //         builder: (context, value, child) {
                        //           final selected = value == _menuList[index];

                        //           return RawChip(
                        //             pressElevation: 0,
                        //             clipBehavior: Clip.antiAlias,
                        //             label: Text(_menuList[index]),
                        //             labelPadding: const EdgeInsets.symmetric(
                        //               horizontal: 6,
                        //             ),
                        //             labelStyle: textTheme.bodyMedium?.copyWith(
                        //               color: selected
                        //                   ? primaryColor
                        //                   : primaryTextColor,
                        //             ),
                        //             side: BorderSide(
                        //               color: selected
                        //                   ? Colors.transparent
                        //                   : borderColor,
                        //             ),
                        //             shape: RoundedRectangleBorder(
                        //               borderRadius: BorderRadius.circular(10),
                        //             ),
                        //             selected: selected,
                        //             selectedColor: primaryColor.withOpacity(.2),
                        //             checkmarkColor: primaryColor,
                        //             onSelected: (_) {
                        //               _selectedMenu.value = _menuList[index];
                        //             },
                        //           );
                        //         },
                        //       );
                        //     },
                        //     separatorBuilder: (_, __) => const SizedBox(width: 8),
                        //   ),
                        // ),

                        const SizedBox(height: 8),
                        ListView.separated(
                          primary: false,
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemBuilder: (_, i) {
                            final grades =
                                state.weeklyAssesment!.assesments![i];
                            return WeeklyGradeCard(
                              attendNum: grades.attendNum??0,
                              notAttendNum: grades.notAttendNum??0,
                              week: grades.weekNum ?? 0,
                              score: grades.score!.toDouble(),
                              onTap: () => showDialog(
                                context: context,
                                barrierLabel: '',
                                barrierDismissible: false,
                                builder: (_) => WeeklyGradeScoreDialog(
                                  week: grades.weekNum ?? 0,
                                  score: grades.score!.toDouble(),
                                  id: grades.id!,
                                  activeDepartmentId:
                                      widget.student.activeDepartmentId!,
                                  studentId: widget.student.studentId!,
                                ),
                              ),
                              status: grades.verificationStatus ?? '',
                            );
                          },
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 16),
                          itemCount: state.weeklyAssesment!.assesments!.length,
                        ),
                      ],
                    ),
                  );
                return EmptyData(
                    title: 'No Weekly Assesment',
                    subtitle:
                        'Student must be verify one or more daily activity before');
              }
              return CustomLoading();
            },
          ),
        ),
      ),
    );
  }
}
