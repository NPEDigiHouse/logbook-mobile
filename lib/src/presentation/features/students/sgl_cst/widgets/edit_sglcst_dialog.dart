import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/helpers/utils.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/data/models/sglcst/topic_model.dart';
import 'package:elogbook/src/data/models/sglcst/topic_on_sglcst.dart';
import 'package:elogbook/src/presentation/blocs/sgl_cst_cubit/sgl_cst_cubit.dart';
import 'package:elogbook/src/presentation/features/students/sgl_cst/widgets/add_topic_dialog.dart';
import 'package:elogbook/src/presentation/widgets/inputs/custom_dropdown.dart';
import 'package:elogbook/src/presentation/widgets/inputs/input_date_time_field.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

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
  List<int> topicId = [];
  List<String> topicNames = [];
  final List<ValueNotifier<String?>> topicVal = [];

  @override
  void initState() {
    start = DateTime.fromMillisecondsSinceEpoch(widget.startTime * 1000);
    end = DateTime.fromMillisecondsSinceEpoch(widget.endTime * 1000);
    startTimeController.text = Utils.datetimeToStringTime(start);
    endTimeController.text = Utils.datetimeToStringTime(end);
    for (var i = 0; i < widget.topics.length; i++) {
      topicNames.add(widget.topics[i].topicName!.first);
      topicId.add(-1);
      topicVal.add(ValueNotifier(null));
    }
    BlocProvider.of<SglCstCubit>(context, listen: false)..getTopics();
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
          BlocProvider.of<SglCstCubit>(context)..getStudentCstDetail();
          context.back();
        } else if (state.isSglEditSuccess &&
            widget.type == TopicDialogType.sgl) {
          BlocProvider.of<SglCstCubit>(context)..getStudentSglDetail();
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
                      SizedBox(
                        width: 44,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  SpacingColumn(
                    horizontalPadding: 16,
                    spacing: 12,
                    children: [
                      BlocBuilder<SglCstCubit, SglCstState>(
                          builder: (context, state) {
                        List<TopicModel> _topics = [];
                        if (state.topics != null) {
                          _topics.clear();
                          _topics.addAll(Utils.filterTopic(
                              listData: state.topics!,
                              isSGL: widget.type == TopicDialogType.sgl));
                          return SpacingColumn(
                            spacing: 8,
                            children: [
                              for (int i = 0; i < topicNames.length; i++)
                                Builder(builder: (context) {
                                  int indx = _topics.indexWhere((element) =>
                                      element.name == topicNames[i]);
                                  topicId[i] =
                                      indx == -1 ? -1 : _topics[indx].id!;
                                  return CustomDropdown<TopicModel>(
                                    errorNotifier: topicVal[i],
                                    init: widget
                                            .topics[i].topicName!.first.isEmpty
                                        ? null
                                        : widget.topics[i].topicName?.first,
                                    onSubmit: (text, controller) {
                                      if (_topics.indexWhere((element) =>
                                              element.name?.trim() ==
                                              text.trim()) ==
                                          -1) {
                                        controller.clear();
                                        topicId.clear();
                                      }
                                    },
                                    hint: 'Topics',
                                    onCallback: (pattern) {
                                      final temp = _topics
                                          .where((competence) => (competence
                                                      .name ??
                                                  'unknown')
                                              .toLowerCase()
                                              .trim()
                                              .contains(pattern.toLowerCase()))
                                          .toList();

                                      return pattern.isEmpty ? _topics : temp;
                                    },
                                    child: (suggestion) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0,
                                          vertical: 16,
                                        ),
                                        child: Text(suggestion?.name ?? ''),
                                      );
                                    },
                                    onClear: (controller) {
                                      topicId[i] = -1;
                                      topicNames[i] = '';
                                    },
                                    onItemSelect: (v, controller) {
                                      if (v != null) {
                                        topicId[i] = v.id ?? -1;
                                        topicNames[i] = v.name;
                                        controller.text = v.name!;
                                      }
                                    },
                                  );
                                }),
                            ],
                          );
                        }
                        return CircularProgressIndicator();
                      }),
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
                          SizedBox(
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
                  SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: FilledButton(
                      onPressed: onSubmit,
                      child: Text('Submit'),
                    ).fullWidth(),
                  ),
                  SizedBox(
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

    for (var i = 0; i < topicVal.length; i++) {
      topicVal[i].value = topicId[i] == -1
          ? 'This field is required, please select again.'
          : null;
      if (topicId[i] == -1) {
        valid = false;
      }
    }
    if (valid && _formKey.currentState!.saveAndValidate()) {
      if (widget.type == TopicDialogType.sgl) {
        BlocProvider.of<SglCstCubit>(context)
          ..editSgl(
            id: widget.id,
            startTime: start.millisecondsSinceEpoch ~/ 1000,
            endTime: end.millisecondsSinceEpoch ~/ 1000,
            topics: [
              for (int i = 0; i < topicId.length; i++)
                if (widget.topics[i].topicName != topicNames[i])
                  {
                    "oldId": widget.topics[i].id,
                    "newId": topicId[i],
                  }
            ],
          );
      } else {
        BlocProvider.of<SglCstCubit>(context)
          ..editCst(
            id: widget.id,
            startTime: start.millisecondsSinceEpoch ~/ 1000,
            endTime: end.millisecondsSinceEpoch ~/ 1000,
            topics: [
              for (int i = 0; i < topicId.length; i++)
                if (widget.topics[i].topicName != topicNames[i])
                  {
                    "oldId": widget.topics[i].id,
                    "newId": topicId[i],
                  }
            ],
          );
      }
    }
  }
}
