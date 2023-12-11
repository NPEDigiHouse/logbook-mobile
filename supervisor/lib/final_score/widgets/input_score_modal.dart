import 'package:core/context/navigation_extension.dart';
import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main/blocs/assesment_cubit/assesment_cubit.dart';

enum FinalScoreType { cbt, osce }

class InputFinalScoreDialog extends StatefulWidget {
  final FinalScoreType type;
  final String unitId;
  final String studentId;
  final double initScore;
  const InputFinalScoreDialog(
      {super.key,
      required this.type,
      required this.initScore,
      required this.unitId,
      required this.studentId});

  @override
  State<InputFinalScoreDialog> createState() => _AddTopicDialogState();
}

class _AddTopicDialogState extends State<InputFinalScoreDialog> {
  final scoreController = TextEditingController();
  @override
  void initState() {
    super.initState();
    scoreController.text = widget.initScore.toString();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AssesmentCubit, AssesmentState>(
      listener: (context, state) {
        if (widget.type == FinalScoreType.cbt && state.isFinalScoreUpdate) {
          BlocProvider.of<AssesmentCubit>(context)
            .getFinalScore(unitId: widget.unitId, studentId: widget.studentId);
          Navigator.pop(context);
        }
        if (widget.type == FinalScoreType.osce && state.isFinalScoreUpdate) {
          BlocProvider.of<AssesmentCubit>(context)
            .getFinalScore(unitId: widget.unitId, studentId: widget.studentId);
          context.back();
        }
      },
      child: Dialog(
        elevation: 0,
        insetPadding: const EdgeInsets.symmetric(
          horizontal: 36.0,
          vertical: 24.0,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            widget.type == FinalScoreType.cbt
                                ? 'Update CBT Score'
                                : 'Update OSCE Score',
                            textAlign: TextAlign.center,
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 44,
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: scoreController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0, horizontal: 6),
                    disabledBorder: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: FilledButton(
                  onPressed: () {
                    if (scoreController.text.isNotEmpty) {
                      BlocProvider.of<AssesmentCubit>(context).updateFinalScore(
                          unitId: widget.unitId,
                          studentId: widget.studentId,
                          score: double.parse(scoreController.text),
                          type: widget.type == FinalScoreType.cbt
                              ? 'CBT'
                              : 'OSCE');
                    }
                  },
                  child: const Text('Submit'),
                ).fullWidth(),
              ),
              const SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
