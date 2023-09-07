import 'package:elogbook/src/presentation/blocs/assesment_cubit/assesment_cubit.dart';
import 'package:flutter/material.dart';
import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WeeklyGradeScoreDialog extends StatefulWidget {
  final int week;
  final double? score;
  final String id;
  final String activeDepartmentId;
  final String studentId;

  const WeeklyGradeScoreDialog({
    super.key,
    required this.week,
    this.score,
    required this.activeDepartmentId,
    required this.studentId,
    required this.id,
  });

  @override
  State<WeeklyGradeScoreDialog> createState() => _WeeklyGradeScoreDialogState();
}

class _WeeklyGradeScoreDialogState extends State<WeeklyGradeScoreDialog> {
  late final TextEditingController _scoreController;

  @override
  void initState() {
    _scoreController = TextEditingController(
      text: '${widget.score ?? ''}',
    );

    super.initState();
  }

  @override
  void dispose() {
    _scoreController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AssesmentCubit, AssesmentState>(
      listener: (context, state) {
        if (state.isScoreWeeklyAssessment) {
          BlocProvider.of<AssesmentCubit>(context)
            ..getWeeklyAssesment(
                studentId: widget.studentId, unitId: widget.activeDepartmentId);
          context.back();
        }
      },
      child: Dialog(
        elevation: 0,
        insetPadding: const EdgeInsets.symmetric(
          vertical: 24,
          horizontal: 36,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 8, left: 4),
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.close_rounded,
                      color: onFormDisableColor,
                    ),
                    tooltip: 'Close',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Center(
                    child: Text(
                      'Week ${widget.week} Score',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: primaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 20),
              child: TextField(
                controller: _scoreController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  label: Text('Score'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: FilledButton(
                onPressed: () {
                  BlocProvider.of<AssesmentCubit>(context)
                    ..addScoreWeeklyAssesment(
                        id: widget.id,
                        score: int.parse(_scoreController.text.isNotEmpty
                            ? _scoreController.text
                            : '0'));
                },
                child: const Text('Submit'),
              ).fullWidth(),
            ),
          ],
        ),
      ),
    );
  }
}
