import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/data/models/scientific_session/verify_scientific_session_model.dart';
import 'package:elogbook/src/presentation/blocs/scientific_session_supervisor_cubit/scientific_session_supervisor_cubit.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class VerifyScientificSessionDialog extends StatefulWidget {
  final String id;
  const VerifyScientificSessionDialog({super.key, required this.id});

  @override
  State<VerifyScientificSessionDialog> createState() => _AddTopicDialogState();
}

class _AddTopicDialogState extends State<VerifyScientificSessionDialog> {
  int rating = 2;
  final TextEditingController feedbackController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ScientificSessionSupervisorCubit,
        ScientificSessionSupervisorState>(
      listener: (context, state) {
        if (state.successVerify) {
          BlocProvider.of<ScientificSessionSupervisorCubit>(context)
            ..getScientificSessionDetail(id: widget.id);
          BlocProvider.of<ScientificSessionSupervisorCubit>(context)
            ..getScientificSessionList();
          Navigator.pop(context);
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
                            'Verify Entry',
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
                  SizedBox(
                    width: 44,
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              SpacingColumn(horizontalPadding: 16, spacing: 12, children: [
                Divider(),
                Text(
                  'Add Rating',
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                RatingBar.builder(
                  initialRating: 2,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  unratedColor: Color(0xFFCED8EE),
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: primaryColor,
                  ),
                  onRatingUpdate: (rating) {
                    this.rating = rating.toInt();
                  },
                ),
                SizedBox(
                  height: 16,
                ),
              ]),
              SizedBox(
                height: 12,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                width: MediaQuery.of(context).size.width,
                child: FilledButton.icon(
                  onPressed: () {
                    if (rating != null) {
                      BlocProvider.of<ScientificSessionSupervisorCubit>(context)
                        ..verifyClinicalRecord(
                          id: widget.id,
                          model: VerifyScientificSessionModel(
                            verified: true,
                            rating: rating,
                          ),
                        );
                    }
                  },
                  icon: Icon(Icons.verified),
                  label: Text('Submit'),
                ),
              ),
              SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
