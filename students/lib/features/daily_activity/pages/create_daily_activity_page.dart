import 'package:core/context/navigation_extension.dart';
import 'package:core/helpers/utils.dart';
import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:data/models/activity/activity_model.dart';
import 'package:data/models/daily_activity/daily_activity_post_model.dart';
import 'package:data/models/daily_activity/student_daily_activity_model.dart';
import 'package:data/models/supervisors/supervisor_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:main/blocs/activity_cubit/activity_cubit.dart';
import 'package:main/blocs/clinical_record_cubit/clinical_record_cubit.dart';
import 'package:main/blocs/daily_activity_cubit/daily_activity_cubit.dart';
import 'package:main/blocs/supervisor_cubit/supervisors_cubit.dart';
import 'package:main/widgets/custom_alert.dart';
import 'package:main/widgets/dividers/section_divider.dart';
import 'package:main/widgets/headers/form_section_header.dart';
import 'package:main/widgets/inkwell_container.dart';
import 'package:main/widgets/inputs/custom_dropdown.dart';
import 'package:main/widgets/spacing_column.dart';
import 'package:students/features/daily_activity/pages/select_activity_page.dart';

class CreateDailyActivityPage extends StatefulWidget {
  final String id;
  final String? dayId;
  final List<String>? dayExist;
  final ActivitiesStatus? activityStatus;
  const CreateDailyActivityPage(
      {super.key,
      this.dayId,
      required this.id,
      this.activityStatus,
      this.dayExist});

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
  final ValueNotifier<String?> day = ValueNotifier(null);
  final TextEditingController detailController = TextEditingController();
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      BlocProvider.of<SupervisorsCubit>(context).getAllSupervisors();
      BlocProvider.of<ActivityCubit>(context)
        ..getActivityNames()
        ..getActivityLocations();
    });
    status = widget.activityStatus?.activityStatus;
    detailController.text = widget.activityStatus?.detail ?? '';
    status = status == "NOT_ATTEND" ? null : status;

    if (status == 'ATTEND') {
      locationName = widget.activityStatus?.location ?? '';
      activityName = widget.activityStatus?.activityName ?? '';
    }
    supervisorName = widget.activityStatus?.supervisorName;
    if (widget.dayExist != null) {
      if (widget.dayExist!.isNotEmpty) {
        day.value = widget.dayExist?.first;
      }
    }
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
        title: const Text("Add Daily Activity"),
      ).variant(),
      body: BlocListener<DailyActivityCubit, DailyActivityState>(
        listener: (context, state) {
          if (state.isDailyActivityUpdated) {
            CustomAlert.success(
                message: 'Success Update Daily Activity', context: context);
            Navigator.pop(context);
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 20),
            child: FormBuilder(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 4,
                  ),
                  const FormSectionHeader(
                    label: 'General Info',
                    pathPrefix: 'icon_info.svg',
                    padding: 16,
                  ),
                  SpacingColumn(spacing: 16, horizontalPadding: 16, children: [
                    if (widget.dayExist == null)
                      TextFormField(
                        decoration: const InputDecoration(
                          label: Text('Date'),
                          enabled: false,
                        ),
                        initialValue: Utils.datetimeToString(DateTime.now()),
                      )
                    else
                      ValueListenableBuilder(
                          valueListenable: day,
                          builder: (context, val, _) {
                            return DropdownButtonFormField(
                              isExpanded: true,
                              hint: const Text('Day Name'),
                              items: widget.dayExist!
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (v) {
                                day.value = v;
                              },
                              value: val,
                            );
                          }),
                    BlocBuilder<SupervisorsCubit, SupervisorsState>(
                        builder: (context, state) {
                      List<SupervisorModel> supervisors = [];
                      if (state is SupervisorFetchSuccess) {
                        supervisors.clear();
                        supervisors.addAll(state.supervisors);
                        if (supervisors.indexWhere((element) =>
                                element.fullName == supervisorName) !=
                            -1) {
                          final al = supervisors.firstWhere(
                              (element) => element.fullName == supervisorName);
                          supervisorId = al.id;
                        }
                        return CustomDropdown<SupervisorModel>(
                            errorNotifier: supervisorVal,
                            onSubmit: (text, controller) {
                              if (supervisors.indexWhere((element) =>
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
                              final temp = supervisors
                                  .where((competence) =>
                                      (competence.fullName ?? 'unknown')
                                          .toLowerCase()
                                          .trim()
                                          .contains(pattern.toLowerCase()))
                                  .toList();

                              return pattern.isEmpty ? supervisors : temp;
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
                      return const CircularProgressIndicator();
                    }),
                    const SizedBox(
                      height: 12,
                    ),
                  ]),
                  const SectionDivider(),
                  const FormSectionHeader(
                    label: 'Activity',
                    pathPrefix: 'icon_diagnosis.svg',
                    padding: 16,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Builder(builder: (context) {
                      List<String> type = ['Attend', 'Sick', 'Holiday'];
                      return DropdownButtonFormField(
                        validator: FormBuilderValidators.required(
                          errorText: 'This field is required',
                        ),
                        isExpanded: true,
                        hint: const Text('Status'),
                        value: status != null
                            ? status!.isNotEmpty
                                ? status![0].toUpperCase() +
                                    status!.substring(1).toLowerCase()
                                : null
                            : null,
                        items: type
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(
                                  e,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
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
                  const SizedBox(
                    height: 16,
                  ),
                  SpacingColumn(
                    spacing: 16,
                    horizontalPadding: 16,
                    children: [
                      if (status == 'ATTEND') ...[
                        BlocSelector<ActivityCubit, ActivityState,
                            List<ActivityModel>?>(
                          selector: (state) => state.activityLocations,
                          builder: (context, state) {
                            if (state == null) return const SizedBox.shrink();
                            ActivityModel? data;
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              data = state.indexWhere((element) =>
                                          element.name == locationName) !=
                                      -1
                                  ? state.firstWhere(
                                      (element) => element.name == locationName)
                                  : null;
                            });

                            return InkWellContainer(
                              onTap: () =>
                                  context.navigateTo(SelectActivityPage(
                                onTap: (activity) {
                                  locationId = activity.id;
                                  locationName = activity.name;
                                  setState(() {});
                                },
                                selectModelName: data,
                              )),
                              border: Border.all(
                                width: 2,
                                color: locationName != null
                                    ? primaryColor
                                    : errorColor,
                              ),
                              radius: 16,
                              child: SizedBox(
                                width: double.infinity,
                                height: 60,
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 16),
                                      child: Row(
                                        children: [
                                          Icon(
                                            CupertinoIcons.location_solid,
                                            color: locationName != null
                                                ? primaryTextColor
                                                : borderColor,
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          Expanded(
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Text(
                                                locationName != null
                                                    ? locationName!
                                                    : 'Select Location',
                                                style: textTheme.bodyLarge
                                                    ?.copyWith(
                                                  color: locationName != null
                                                      ? primaryTextColor
                                                      : borderColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 44,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      right: 0,
                                      child: Container(
                                        height: 60,
                                        width: 60,
                                        decoration: BoxDecoration(
                                            color: locationName != null
                                                ? primaryColor
                                                : errorColor,
                                            borderRadius:
                                                const BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(8),
                                                    bottomRight:
                                                        Radius.circular(8))),
                                        child: Icon(
                                          locationName != null
                                              ? Icons.check_circle_rounded
                                              : Icons.warning_rounded,
                                          color: scaffoldBackgroundColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        BlocBuilder<ActivityCubit, ActivityState>(
                            builder: (context, state) {
                          List<ActivityModel> activityLocations = [];
                          if (state.activityNames != null) {
                            activityLocations.clear();
                            activityLocations.addAll(state.activityNames!);
                          }
                          if (activityLocations.indexWhere(
                                  (element) => element.name == activityName) !=
                              -1) {
                            final al = activityLocations.firstWhere(
                                (element) => element.name == activityName);
                            activityNameId = al.id;
                          }
                          return DropdownButtonFormField(
                            validator: FormBuilderValidators.required(
                              errorText: 'This field is required',
                            ),
                            isExpanded: true,
                            hint: const Text('Activity'),
                            items: activityLocations
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e.name!),
                                  ),
                                )
                                .toList(),
                            onChanged: (v) {
                              if (v != null) activityNameId = v.id!;
                            },
                            value: activityLocations.indexWhere((element) =>
                                        element.name == activityName) !=
                                    -1
                                ? activityLocations.firstWhere(
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
                  const SizedBox(
                    height: 16,
                  ),
                  BlocSelector<DailyActivityCubit, DailyActivityState, bool>(
                    selector: (state) =>
                        state.updateState == RequestState.loading,
                    builder: (context, isLoading) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: FilledButton(
                          onPressed: isLoading ? null : onSubmit,
                          child: const Text('Next'),
                        ).fullWidth(),
                      );
                    },
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
      if (widget.dayId != null) {
        BlocProvider.of<DailyActivityCubit>(context).updateDailyActivity(
          id: widget.dayId!,
          weekId: widget.id,
          model: DailyActivityPostModel(
            activityNameId: activityNameId,
            activityStatus: status,
            detail: detailController.text,
            locationId: locationId,
            supervisorId: supervisorId,
          ),
        );
      } else {
        BlocProvider.of<DailyActivityCubit>(context).updateDailyActivity2(
          day: day.value!,
          weekId: widget.id,
          dailyActivityV2Id: widget.id,
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
}
