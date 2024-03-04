import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:data/models/clinical_records/verify_clinical_record_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:main/blocs/clinical_record_supervisor_cubit/clinical_record_supervisor_cubit.dart';
import 'package:main/widgets/custom_alert.dart';
import 'package:main/widgets/spacing_column.dart';

class VerifyClinicalRecordDialog extends StatefulWidget {
  final String id;
  const VerifyClinicalRecordDialog({super.key, required this.id});

  @override
  State<VerifyClinicalRecordDialog> createState() => _AddTopicDialogState();
}

class _AddTopicDialogState extends State<VerifyClinicalRecordDialog> {
  double rating = 2;
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
    return BlocListener<ClinicalRecordSupervisorCubit,
        ClinicalRecordSupervisorState>(
      listener: (context, state) {
        if (state.successVerifyClinicalRecords) {
          CustomAlert.success(
              message: "Success Verify Clinical Record", context: context);
          BlocProvider.of<ClinicalRecordSupervisorCubit>(context)
              .getDetailClinicalRecord(id: widget.id);
          BlocProvider.of<ClinicalRecordSupervisorCubit>(context)
              .getClinicalRecords();
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
                  const SizedBox(
                    width: 44,
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              SpacingColumn(horizontalPadding: 16, spacing: 12, children: [
                const Divider(),
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
                  unratedColor: const Color(0xFFCED8EE),
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: primaryColor,
                  ),
                  onRatingUpdate: (rating) {
                    this.rating = rating;
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  'Add Feedback',
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: dividerColor,
                  ),
                  child: TextField(
                    controller: feedbackController,
                    minLines: 3,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: 'Feedback',
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ]),
              const SizedBox(
                height: 12,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                width: MediaQuery.of(context).size.width,
                child: FilledButton.icon(
                  onPressed: () {
                    BlocProvider.of<ClinicalRecordSupervisorCubit>(context)
                        .verifyClinicalRecord(
                      id: widget.id,
                      model: VerifyClinicalRecordModel(
                          verified: true,
                          rating: rating,
                          supervisorFeedback: feedbackController.text),
                    );
                  },
                  icon: const Icon(Icons.verified),
                  label: const Text('Submit'),
                ),
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
