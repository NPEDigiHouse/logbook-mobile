import 'package:core/context/navigation_extension.dart';
import 'package:core/helpers/utils.dart';
import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:data/models/sglcst/topic_on_sglcst.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:main/blocs/clinical_record_cubit/clinical_record_cubit.dart';
import 'package:main/blocs/sgl_cst_cubit/sgl_cst_cubit.dart';
import 'package:main/widgets/inputs/input_date_time_field.dart';
import 'package:main/widgets/spacing_column.dart';
import 'add_topic_dialog.dart';

class EditSglCstDialog extends StatefulWidget {
  final TopicDialogType type;
  final String id;
  final int startTime;
  final int endTime;
  final DateTime date;
  final List<Topic> topics;
  const EditSglCstDialog({
    super.key,
    required this.topics,
    required this.startTime,
    required this.endTime,
    required this.type,
    required this.id,
    required this.date,
  });

  @override
  State<EditSglCstDialog> createState() => _EditSglCstDialogState();
}

class _EditSglCstDialogState extends State<EditSglCstDialog> {
  final startTimeController = TextEditingController();
  final endTimeController = TextEditingController();
  final _formKey = GlobalKey<FormBuilderState>();
  late DateTime start;
  late DateTime end;

  @override
  void initState() {
    start = DateTime.fromMillisecondsSinceEpoch(widget.startTime * 1000);
    end = DateTime.fromMillisecondsSinceEpoch(widget.endTime * 1000);
    startTimeController.text = Utils.datetimeToStringTime(start);
    endTimeController.text = Utils.datetimeToStringTime(end);
    super.initState();
  }

  @override
  void dispose() {
    startTimeController.dispose();
    endTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SglCstCubit, SglCstState>(
      listener: (context, state) {
        if (widget.type == TopicDialogType.cst && state.isCstEditSuccess) {
          context.back();
        } else if (state.isSglEditSuccess &&
            widget.type == TopicDialogType.sgl) {
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
          child: FormBuilder(
            key: _formKey,
            child: Builder(builder: (context) {
              return Column(
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
                                widget.type == TopicDialogType.sgl
                                    ? 'Edit SGL'
                                    : 'Edit CST',
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
                  SpacingColumn(
                    horizontalPadding: 16,
                    spacing: 12,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: InputDateTimeField(
                                action: (d) {
                                  start = d;
                                },
                                validator: FormBuilderValidators.required(
                                  errorText: 'This field is required',
                                ),
                                initialDate: start,
                                controller: startTimeController,
                                hintText: 'Start Time'),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Expanded(
                            child: InputDateTimeField(
                                action: (d) {
                                  end = d;
                                },
                                validator: (data) {
                                  if (data == null || data.isEmpty) {
                                    return 'This field is required';
                                  }
                                  if (Utils.stringTimeToDateTime(
                                          widget.date, startTimeController.text)
                                      .isAfter(Utils.stringTimeToDateTime(
                                          widget.date,
                                          endTimeController.text))) {
                                    return 'endtime cannot before starttime';
                                  }
                                  return null;
                                },
                                initialDate: end,
                                controller: endTimeController,
                                hintText: 'End Time'),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  BlocSelector<SglCstCubit, SglCstState, bool>(
                    selector: (state) =>
                        state.createState == RequestState.loading,
                    builder: (context, isLoading) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: FilledButton(
                          onPressed: isLoading ? null : onSubmit,
                          child: const Text('Submit'),
                        ).fullWidth(),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  void onSubmit() {
    FocusScope.of(context).unfocus();
    bool valid = true;

    if (valid && _formKey.currentState!.saveAndValidate()) {
      if (widget.type == TopicDialogType.sgl) {
        BlocProvider.of<SglCstCubit>(context).editSgl(
          id: widget.id,
          startTime: start.millisecondsSinceEpoch ~/ 1000,
          endTime: end.millisecondsSinceEpoch ~/ 1000,
          date: Utils.datetimeToString(widget.date, format: 'yyyy-MM-dd'),
        );
      } else {
        BlocProvider.of<SglCstCubit>(context).editCst(
          id: widget.id,
          startTime: start.millisecondsSinceEpoch ~/ 1000,
          endTime: end.millisecondsSinceEpoch ~/ 1000,
          date: Utils.datetimeToString(widget.date, format: 'yyyy-MM-dd'),
        );
      }
    }
  }
}
