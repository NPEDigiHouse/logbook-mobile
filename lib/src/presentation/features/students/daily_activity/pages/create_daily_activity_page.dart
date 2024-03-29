import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/helpers/utils.dart';
import 'package:elogbook/src/data/models/activity/activity_model.dart';
import 'package:elogbook/src/data/models/daily_activity/daily_activity_post_model.dart';
import 'package:elogbook/src/data/models/daily_activity/student_daily_activity_model.dart';
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
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class CreateDailyActivityPage extends StatefulWidget {
  final String id;
  final String dayId;
  final ActivitiesStatus? activityStatus;
  const CreateDailyActivityPage(
      {super.key, required this.dayId, required this.id, this.activityStatus});

  @override
  State<CreateDailyActivityPage> createState() =>
      _CreateDailyActivityPageState();
}

class _CreateDailyActivityPageState extends State<CreateDailyActivityPage> {
  String? supervisorId;
  int? locationId;
  String? locationName;
  String? activityName;
  String? status;
  int? activityNameId;
  String? supervisorName;
  final _formKey = GlobalKey<FormBuilderState>();

  final ValueNotifier<String?> supervisorVal = ValueNotifier(null);
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
    status = widget.activityStatus?.activityStatus;
    detailController.text = widget.activityStatus?.detail ?? '';
    if (status == 'ATTEND') {
      locationName = widget.activityStatus?.location ?? '';
      activityName = widget.activityStatus?.activityName ?? '';
    }
    supervisorName = widget.activityStatus?.supervisorName;
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
            child: FormBuilder(
              key: _formKey,
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
                      initialValue: Utils.datetimeToString(DateTime.now()),
                    ),
                    BlocBuilder<SupervisorsCubit, SupervisorsState>(
                        builder: (context, state) {
                      List<SupervisorModel> _supervisors = [];
                      if (state is FetchSuccess) {
                        _supervisors.clear();
                        _supervisors.addAll(state.supervisors);
                        if (_supervisors.indexWhere((element) =>
                                element.fullName == supervisorName) !=
                            -1) {
                          final al = _supervisors.firstWhere(
                              (element) => element.fullName == supervisorName);
                          supervisorId = al.id;
                        }
                        return CustomDropdown<SupervisorModel>(
                            errorNotifier: supervisorVal,
                            onSubmit: (text, controller) {
                              if (_supervisors.indexWhere((element) =>
                                      element.fullName?.trim() ==
                                      text.trim()) ==
                                  -1) {
                                controller.clear();
                                supervisorId = '';
                              }
                            },
                            hint: 'Supervisor',
                            init: supervisorName,
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
                      }
                      return CircularProgressIndicator();
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
                        validator: FormBuilderValidators.required(
                          errorText: 'This field is required',
                        ),
                        isExpanded: true,
                        hint: Text('Status'),
                        value: status != null
                            ? status!.isNotEmpty
                                ? status![0].toUpperCase() +
                                    status!.substring(1).toLowerCase()
                                : null
                            : null,
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
                      if (status == 'ATTEND') ...[
                        BlocBuilder<ActivityCubit, ActivityState>(
                            builder: (context, state) {
                          List<ActivityModel> _activityLocations = [];
                          if (state.activityLocations != null) {
                            _activityLocations.clear();
                            _activityLocations.addAll(state.activityLocations!);
                          }
                          if (_activityLocations.indexWhere(
                                  (element) => element.name == locationName) !=
                              -1) {
                            final al = _activityLocations.firstWhere(
                                (element) => element.name == locationName);
                            locationId = al.id;
                          }
                          return DropdownButtonFormField(
                            validator: FormBuilderValidators.required(
                              errorText: 'This field is required',
                            ),
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
                            value: _activityLocations.indexWhere((element) =>
                                        element.name == locationName) !=
                                    -1
                                ? _activityLocations.firstWhere(
                                    (element) => element.name == locationName)
                                : null,
                          );
                        }),
                        BlocBuilder<ActivityCubit, ActivityState>(
                            builder: (context, state) {
                          List<ActivityModel> _activityLocations = [];
                          if (state.activityNames != null) {
                            _activityLocations.clear();
                            _activityLocations.addAll(state.activityNames!);
                          }
                          if (_activityLocations.indexWhere(
                                  (element) => element.name == activityName) !=
                              -1) {
                            final al = _activityLocations.firstWhere(
                                (element) => element.name == activityName);
                            activityNameId = al.id;
                          }
                          return DropdownButtonFormField(
                            validator: FormBuilderValidators.required(
                              errorText: 'This field is required',
                            ),
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
                            },
                            value: _activityLocations.indexWhere((element) =>
                                        element.name == activityName) !=
                                    -1
                                ? _activityLocations.firstWhere(
                                    (element) => element.name == activityName)
                                : null,
                          );
                        }),
                      ],
                      TextFormField(
                        maxLines: 5,
                        controller: detailController,
                        minLines: 5,
                        decoration: InputDecoration(
                          label: Text(
                              status == 'ATTEND' ? 'Detail Activity' : 'Notes'),
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
                      onPressed: onSubmit,
                      child: Text('Next'),
                    ).fullWidth(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onSubmit() {
    FocusScope.of(context).unfocus();
    supervisorVal.value = supervisorId == null
        ? 'This field is required, please select again.'
        : null;
    if (_formKey.currentState!.saveAndValidate() && supervisorId != null) {
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
  }
}
