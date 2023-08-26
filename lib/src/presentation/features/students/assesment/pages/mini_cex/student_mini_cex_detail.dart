import 'package:elogbook/core/helpers/app_size.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/presentation/blocs/assesment_cubit/assesment_cubit.dart';
import 'package:elogbook/src/presentation/blocs/clinical_record_cubit/clinical_record_cubit.dart';
import 'package:elogbook/src/presentation/features/students/assesment/pages/widgets/top_stat_card.dart';
import 'package:elogbook/src/presentation/widgets/empty_data.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentMiniCexDetail extends StatefulWidget {
  final String id;
  const StudentMiniCexDetail({
    super.key,
    required this.id,
  });

  @override
  State<StudentMiniCexDetail> createState() => _StudentMiniCexDetailState();
}

class _StudentMiniCexDetailState extends State<StudentMiniCexDetail> {
  @override
  void initState() {
    Future.microtask(() => BlocProvider.of<AssesmentCubit>(context)
      ..getMiniCexStudentDetail(
        id: widget.id,
      ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AssesmentCubit, AssesmentState>(
      builder: (context, state) {
        print(state);
        if (state.requestState == RequestState.loading)
          return SizedBox(
            height: 300,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        if (state.miniCexStudentDetail != null ||
            state.requestState == RequestState.data)
          return Builder(builder: (context) {
            if (state.miniCexStudentDetail!.scores!.isNotEmpty) {
              return SpacingColumn(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 12,
                children: [
                  SizedBox(
                    height: 16,
                  ),
                  TopStatCard(
                    title: 'Total Grades',
                    score: state.miniCexStudentDetail?.grade != null
                        ? state.miniCexStudentDetail!.grade!.toDouble()
                        : 0,
                  ),
                  ...List.generate(
                    state.miniCexStudentDetail!.scores!.length,
                    (index) => TestGradeScoreCard(
                        caseName:
                            state.miniCexStudentDetail!.scores![index].name ??
                                '',
                        score:
                            state.miniCexStudentDetail!.scores![index].score ??
                                0),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                ],
              );
            } else {
              return Center(
                child: EmptyData(
                  title: 'Waiting for assessment',
                  subtitle:
                      'the supervisor has not given a value for the mini cex',
                ),
              );
            }
          });
        else
          return SizedBox(
            child: Column(
              children: [
                SizedBox(
                  height: 12,
                ),
                OutlinedButton(
                  onPressed: () => BlocProvider.of<AssesmentCubit>(context)
                    ..getMiniCexStudentDetail(
                      id: widget.id,
                    ),
                  child: Text('Load Mini Cex Score'),
                ),
              ],
            ),
          );
      },
    );
  }
}

class TestGradeScoreCard extends StatelessWidget {
  const TestGradeScoreCard({
    super.key,
    required this.caseName,
    required this.score,
  });

  final String caseName;
  final int score;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: 65,
      ),
      child: Container(
        width: AppSize.getAppWidth(context),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 0),
              spreadRadius: 0,
              blurRadius: 6,
              color: Color(0xFFD4D4D4).withOpacity(.25),
            ),
            BoxShadow(
              offset: Offset(0, 4),
              spreadRadius: 0,
              blurRadius: 24,
              color: Color(0xFFD4D4D4).withOpacity(.25),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 2),
                width: 5,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              SizedBox(
                width: 12,
              ),
              Expanded(
                child: Text(
                  caseName,
                  maxLines: 2,
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w400,
                    height: 1.2,
                  ),
                ),
              ),
              SizedBox(
                width: 12,
              ),
              SizedBox(
                width: 35,
                child: Text(
                  score.toString(),
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
