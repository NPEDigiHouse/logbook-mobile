import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/helpers/reusable_function_helper.dart';
import 'package:elogbook/src/data/models/activity/activity_model.dart';
import 'package:elogbook/src/data/models/daily_activity/daily_activity_post_model.dart';
import 'package:elogbook/src/data/models/supervisors/supervisor_model.dart';
import 'package:elogbook/src/presentation/blocs/activity_cubit/activity_cubit.dart';
import 'package:elogbook/src/presentation/blocs/daily_activity_cubit/daily_activity_cubit.dart';
import 'package:elogbook/src/presentation/blocs/supervisor_cubit/supervisors_cubit.dart';
import 'package:elogbook/src/presentation/widgets/dividers/section_divider.dart';
import 'package:elogbook/src/presentation/widgets/headers/form_section_header.dart';
import 'package:elogbook/src/presentation/widgets/inputs/custom_dropdown.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateDailyActivityPage extends StatefulWidget {
  final String id;
  final String dayId;
  const CreateDailyActivityPage(
      {super.key, required this.dayId, required this.id});

  @override
  State<CreateDailyActivityPage> createState() =>
      _CreateDailyActivityPageState();
}

class _CreateDailyActivityPageState extends State<CreateDailyActivityPage> {
  String? supervisorId;
  int? locationId;
  String? status;
  int? activityNameId;
  final TextEditingController detailController = TextEditingController();
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      BlocProvider.of<SupervisorsCubit>(context)..getAllSupervisors();
      BlocProvider.of<ActivityCubit>(context)
        ..getActivityLocations()
        ..getActivityNames();
    });
  }

  @override
  void dispose() {
    super.dispose();
    detailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Daily Activity"),
      ).variant(),
      body: BlocListener<DailyActivityCubit, DailyActivityState>(
        listener: (context, state) {
          if (state.isDailyActivityUpdated) {
            Navigator.pop(context);
            Future.microtask(
              () {
                BlocProvider.of<DailyActivityCubit>(context)
                  ..getStudentActivityPerweek(id: widget.id)
                  ..getStudentDailyActivities();
              },
            );
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 20),
            child: Column(
              children: [
                SizedBox(
                  height: 4,
                ),
                FormSectionHeader(
                  label: 'General Info',
                  pathPrefix: 'icon_info.svg',
                  padding: 16,
                ),
                SpacingColumn(spacing: 16, horizontalPadding: 16, children: [
                  TextFormField(
                    decoration: InputDecoration(
                      label: Text('Date'),
                      enabled: false,
                    ),
                    initialValue:
                        ReusableFunctionHelper.datetimeToString(DateTime.now()),
                  ),
                  BlocBuilder<SupervisorsCubit, SupervisorsState>(
                      builder: (context, state) {
                    List<SupervisorModel> _supervisors = [];
                    if (state is FetchSuccess) {
                      _supervisors.clear();
                      _supervisors.addAll(state.supervisors);
                    }
                    return CustomDropdown<SupervisorModel>(
                        onSubmit: (text, controller) {
                          if (_supervisors.indexWhere((element) =>
                                  element.fullName == text.trim()) ==
                              -1) {
                            controller.clear();
                            supervisorId = '';
                          }
                        },
                        hint: 'Supervisor',
                        onCallback: (pattern) {
                          final temp = _supervisors
                              .where((competence) =>
                                  (competence.fullName ?? 'unknown')
                                      .toLowerCase()
                                      .trim()
                                      .contains(pattern.toLowerCase()))
                              .toList();

                          return pattern.isEmpty ? _supervisors : temp;
                        },
                        child: (suggestion) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                              vertical: 16,
                            ),
                            child: Text(suggestion?.fullName ?? ''),
                          );
                        },
                        onItemSelect: (v, controller) {
                          if (v != null) {
                            supervisorId = v.id!;
                            controller.text = v.fullName!;
                          }
                        });
                  }),
                  SizedBox(
                    height: 12,
                  ),
                ]),
                SectionDivider(),
                FormSectionHeader(
                  label: 'Activity',
                  pathPrefix: 'icon_diagnosis.svg',
                  padding: 16,
                ),
                SizedBox(
                  height: 4,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Builder(builder: (context) {
                    List<String> _type = ['Attend', 'Sick', 'Holiday'];
                    return DropdownButtonFormField(
                      isExpanded: true,
                      hint: Text('Status'),
                      items: _type
                          .map(
                            (e) => DropdownMenuItem(
                              child: Text(
                                e,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              value: e,
                            ),
                          )
                          .toList(),
                      onChanged: (v) {
                        if (v != null) status = v.toUpperCase();
                        setState(() {});
                      },
                    );
                  }),
                ),
                SizedBox(
                  height: 16,
                ),
                SpacingColumn(
                  spacing: 16,
                  horizontalPadding: 16,
                  children: [
                    if (status != 'HOLIDAY') ...[
                      BlocBuilder<ActivityCubit, ActivityState>(
                          builder: (context, state) {
                        List<ActivityModel> _activityLocations = [];
                        if (state.activityLocations != null) {
                          _activityLocations.clear();
                          _activityLocations.addAll(state.activityLocations!);
                        }
                        return DropdownButtonFormField(
                          isExpanded: true,
                          hint: Text('Location'),
                          items: _activityLocations
                              .map(
                                (e) => DropdownMenuItem(
                                  child: Text(
                                    e.name!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  value: e,
                                ),
                              )
                              .toList(),
                          onChanged: (v) {
                            if (v != null) locationId = v.id!;
                          },
                          value: null,
                        );
                      }),
                      BlocBuilder<ActivityCubit, ActivityState>(
                          builder: (context, state) {
                        List<ActivityModel> _activityLocations = [];
                        if (state.activityNames != null) {
                          _activityLocations.clear();
                          _activityLocations.addAll(state.activityNames!);
                        }
                        return DropdownButtonFormField(
                          isExpanded: true,
                          hint: Text('Activity'),
                          items: _activityLocations
                              .map(
                                (e) => DropdownMenuItem(
                                  child: Text(e.name!),
                                  value: e,
                                ),
                              )
                              .toList(),
                          onChanged: (v) {
                            if (v != null) activityNameId = v.id!;
                            ;
                          },
                          value: null,
                        );
                      }),
                    ],
                    TextFormField(
                      maxLines: 5,
                      controller: detailController,
                      minLines: 5,
                      decoration: InputDecoration(
                        label: Text(
                            status != 'HOLIDAY' ? 'Detail Activity' : 'Notes'),
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
                      if (((locationId != null && activityNameId != null) ||
                              status == 'HOLIDAY') &&
                          supervisorId != null &&
                          detailController.text.isNotEmpty) {
                        BlocProvider.of<DailyActivityCubit>(context)
                          ..updateDailyActivity(
                            id: widget.dayId,
                            model: DailyActivityPostModel(
                              activityNameId: activityNameId,
                              activityStatus: status,
                              detail: detailController.text,
                              locationId: locationId,
                              supervisorId: supervisorId,
                            ),
                          );
                      }
                    },
                    child: Text('Next'),
                  ).fullWidth(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
