import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/helpers/reusable_function_helper.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/src/data/models/sglcst/sglcst_post_model.dart';
import 'package:elogbook/src/data/models/sglcst/topic_model.dart';
import 'package:elogbook/src/data/models/supervisors/supervisor_model.dart';
import 'package:elogbook/src/presentation/blocs/sgl_cst_cubit/sgl_cst_cubit.dart';
import 'package:elogbook/src/presentation/blocs/supervisor_cubit/supervisors_cubit.dart';
import 'package:elogbook/src/presentation/widgets/dividers/section_divider.dart';
import 'package:elogbook/src/presentation/widgets/headers/form_section_header.dart';
import 'package:elogbook/src/presentation/widgets/inputs/input_date_time_field.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateSglPage extends StatefulWidget {
  const CreateSglPage({super.key});

  @override
  State<CreateSglPage> createState() => _CreateSglPageState();
}

class _CreateSglPageState extends State<CreateSglPage> {
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final ValueNotifier<List<int>> topics = ValueNotifier<List<int>>([-1]);
  String? supervisorId;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<SupervisorsCubit>(context, listen: false)
      ..getAllSupervisors();
    BlocProvider.of<SglCstCubit>(context, listen: false)..getTopics();
    dateController.text =
        ReusableFunctionHelper.datetimeToString(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New SGL"),
      ).variant(),
      body: BlocListener<SglCstCubit, SglCstState>(
        listener: (context, state) {
          if (state.isSglPostSuccess) {
            BlocProvider.of<SglCstCubit>(context)..getStudentSglDetail();
            Navigator.pop(context);
          }
        },
        child: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            children: [
              FormSectionHeader(
                label: 'General Info',
                pathPrefix: 'icon_info.svg',
                padding: 16,
              ),
              SpacingColumn(
                horizontalPadding: 16,
                spacing: 14,
                children: [
                  TextField(
                    controller: dateController,
                    decoration: InputDecoration(enabled: false),
                  ),
                  BlocBuilder<SupervisorsCubit, SupervisorsState>(
                      builder: (context, state) {
                    List<SupervisorModel> _supervisors = [];
                    if (state is FetchSuccess) {
                      _supervisors.clear();
                      _supervisors.addAll(state.supervisors);
                    }
                    return DropdownButtonFormField(
                      hint: Text('Supervisor'),
                      isExpanded: true,
                      items: _supervisors
                          .map(
                            (e) => DropdownMenuItem(
                              child: Text(e.fullName!),
                              value: e,
                            ),
                          )
                          .toList(),
                      onChanged: (v) {
                        if (v != null) supervisorId = v.id!;
                      },
                      value: null,
                    );
                  }),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              SectionDivider(),
              FormSectionHeader(
                label: 'Activity',
                pathPrefix: 'icon_activity.svg',
                padding: 16,
              ),
              SpacingColumn(
                horizontalPadding: 16,
                spacing: 12,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: InputDateTimeField(
                            action: (d) {},
                            initialDate: dateController.text.isEmpty
                                ? DateTime.now()
                                : ReusableFunctionHelper.stringToDateTime(
                                    dateController.text),
                            controller: startTimeController,
                            hintText: 'Start Time'),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        child: InputDateTimeField(
                            action: (d) {},
                            initialDate: dateController.text.isEmpty
                                ? DateTime.now()
                                : ReusableFunctionHelper.stringToDateTime(
                                    dateController.text),
                            controller: endTimeController,
                            hintText: 'End Time'),
                      ),
                    ],
                  ),
                  BlocBuilder<SglCstCubit, SglCstState>(
                      builder: (context, state) {
                    List<TopicModel> _topics = [];
                    if (state.topics != null) {
                      _topics.clear();
                      _topics.addAll(state.topics!);
                    }

                    if (_topics.isNotEmpty)
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ValueListenableBuilder(
                            valueListenable: topics,
                            builder: (context, value, child) {
                              return Column(
                                children: [
                                  for (int i = 0; i < value.length; i++) ...[
                                    DropdownButtonFormField(
                                      hint: Text('Topics'),
                                      isExpanded: true,
                                      items: _topics
                                          .map(
                                            (e) => DropdownMenuItem(
                                              child: Text(e.name!),
                                              value: e,
                                            ),
                                          )
                                          .toList(),
                                      onChanged: (v) {
                                        if (v != null &&
                                            !value.contains(v.id!)) {
                                          topics.value[i] = v.id!;
                                        }
                                      },
                                      value: null,
                                    ),
                                    if (i < value.length)
                                      SizedBox(
                                        height: 8,
                                      ),
                                  ],
                                ],
                              );
                            },
                          ),
                          FilledButton.icon(
                            onPressed: () {
                              if (topics.value.last != -1 &&
                                  _topics.isNotEmpty) {
                                topics.value = [...topics.value, -1];
                              }
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor:
                                  Color(0xFF29C5F6).withOpacity(.2),
                              foregroundColor: primaryColor,
                            ),
                            icon: Icon(
                              Icons.add_rounded,
                              color: primaryColor,
                            ),
                            label: Text('Add another topic'),
                          ),
                        ],
                      );
                    return SizedBox.shrink();
                  }),
                  TextFormField(
                    maxLines: 4,
                    minLines: 4,
                    controller: noteController,
                    decoration: InputDecoration(
                      label: Text(
                        'Additional notes',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: FilledButton(
                  onPressed: () {
                    if (dateController.text.isNotEmpty &&
                        startTimeController.text.isNotEmpty &&
                        endTimeController.text.isNotEmpty &&
                        topics.value.first != -1) {
                      final date = ReusableFunctionHelper.stringToDateTime(
                          dateController.text);
                      final start = startTimeController.text.split(':');
                      final end = endTimeController.text.split(':');
                      final startTime = DateTime(date.year, date.month,
                          date.day, int.parse(start[0]), int.parse(start[1]));
                      final endTime = DateTime(date.year, date.month, date.day,
                          int.parse(end[0]), int.parse(end[1]));
                      BlocProvider.of<SglCstCubit>(context)
                        ..uploadSgl(
                          model: SglCstPostModel(
                            supervisorId: supervisorId,
                            topicId: topics.value
                                .where((element) => element != -1)
                                .toList(),
                            startTime: startTime.millisecondsSinceEpoch,
                            endTime: endTime.millisecondsSinceEpoch,
                          ),
                        );
                    }
                  },
                  child: Text('Submit'),
                ).fullWidth(),
              ),
              SizedBox(
                height: 16,
              ),
            ],
          ),
        )),
      ),
    );
  }
}
