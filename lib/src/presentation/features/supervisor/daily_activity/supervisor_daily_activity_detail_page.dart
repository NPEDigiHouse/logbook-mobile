import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/presentation/blocs/clinical_record_cubit/clinical_record_cubit.dart';
import 'package:elogbook/src/presentation/blocs/daily_activity_cubit/daily_activity_cubit.dart';
import 'package:elogbook/src/presentation/widgets/custom_loading.dart';
import 'package:elogbook/src/presentation/widgets/dividers/item_divider.dart';
import 'package:elogbook/src/presentation/widgets/headers/unit_student_header.dart';
import 'package:elogbook/src/presentation/widgets/verify_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SupervisorDailyActivityDetailPage extends StatefulWidget {
  final String id;
  final bool isHistory;
  const SupervisorDailyActivityDetailPage(
      {super.key, required this.id, this.isHistory = false});

  @override
  State<SupervisorDailyActivityDetailPage> createState() =>
      _SupervisorDailyActivityDetailPageState();
}

class _SupervisorDailyActivityDetailPageState
    extends State<SupervisorDailyActivityDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => BlocProvider.of<DailyActivityCubit>(context)
      ..getActivityDetailBySupervisor(id: widget.id));
  }

  Map<String, String> emoji = {
    'ATTEND': 'emoji_hadir.svg',
    'SICK': 'sakit_emoji.svg',
    'HOLIDAY': 'icon_holiday.svg',
    'NOT_ATTEND': 'emoji_alfa.svg',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Activity'),
      ),
      body: BlocListener<DailyActivityCubit, DailyActivityState>(
        listener: (context, state) {
          if (state.stateVerifyDailyActivity == RequestState.data) {
            BlocProvider.of<DailyActivityCubit>(context)
              ..getActivityDetailBySupervisor(id: widget.id);
          }
        },
        child: BlocBuilder<DailyActivityCubit, DailyActivityState>(
          builder: (context, state) {
            if (state.activityPerweekBySupervisor != null &&
                state.requestState == RequestState.data) {
              final data = state.activityPerweekBySupervisor;
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    SizedBox(
                      height: 16,
                    ),
                    StudentDepartmentHeader(
                      unitName: data?.unitName ?? '',
                      studentName: data?.studentName ?? '',
                      studentId: data?.studentId ?? '',
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(0, 0),
                              spreadRadius: 0,
                              blurRadius: 6,
                              color: Color(0xFFD4D4D4).withOpacity(.25)),
                          BoxShadow(
                              offset: Offset(0, 4),
                              spreadRadius: 0,
                              blurRadius: 24,
                              color: Color(0xFFD4D4D4).withOpacity(.25)),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                            AssetPath.getIcon(emoji[data?.activityStatus]!),
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Row(
                            children: [
                              Text(
                                '${data?.day} (Week ${data?.weekNum})',
                                style: textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (widget.isHistory) ...[
                                SizedBox(
                                  width: 4,
                                ),
                                Icon(
                                  Icons.verified,
                                  color: primaryColor,
                                )
                              ],
                            ],
                          ),
                          if (data?.activityStatus == 'ATTEND')
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on_rounded,
                                  size: 16,
                                  color: onFormDisableColor,
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  data?.location ?? '',
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: onFormDisableColor,
                                  ),
                                ),
                              ],
                            ),
                          SizedBox(
                            height: 12,
                          ),
                          ItemDivider(),
                          SizedBox(
                            height: 12,
                          ),
                          if (data?.activityStatus == 'ATTEND') ...[
                            Text('Activity', style: textTheme.bodyMedium),
                            Text(
                              data?.activityName ?? '',
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ] else
                            Text(
                              data!.activityStatus![0].toUpperCase() +
                                  data.activityStatus!
                                      .substring(1)
                                      .toLowerCase(),
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          SizedBox(
                            height: 16,
                          ),
                          if (!widget.isHistory)
                            Builder(
                              builder: (context) {
                                if (data?.verificationStatus == "VERIFIED") {
                                  return SizedBox(
                                    width: double.infinity,
                                    child: OutlinedButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            barrierLabel: '',
                                            barrierDismissible: false,
                                            builder: (_) => VerifyDialog(
                                                  onTap: () {
                                                    BlocProvider.of<
                                                                DailyActivityCubit>(
                                                            context)
                                                        .verifiyDailyActivityById(
                                                            id: data!.id!,
                                                            verifiedStatus:
                                                                false);
                                                    Navigator.pop(context);
                                                  },
                                                  isSubmit: false,
                                                ));
                                      },
                                      child: Text('Cancel'),
                                    ),
                                  );
                                } else {
                                  return SizedBox(
                                    width: double.infinity,
                                    child: FilledButton.icon(
                                      icon: Icon(Icons.verified),
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            barrierLabel: '',
                                            barrierDismissible: false,
                                            builder: (_) => VerifyDialog(
                                                  onTap: () {
                                                    BlocProvider.of<
                                                                DailyActivityCubit>(
                                                            context)
                                                        .verifiyDailyActivityById(
                                                            id: data!.id!,
                                                            verifiedStatus:
                                                                true);
                                                    Navigator.pop(context);
                                                  },
                                                  isSubmit: true,
                                                ));
                                      },
                                      label: Text('Verify'),
                                    ),
                                  );
                                }
                              },
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
            return Center(child: CustomLoading());
          },
        ),
      ),
    );
  }
}
