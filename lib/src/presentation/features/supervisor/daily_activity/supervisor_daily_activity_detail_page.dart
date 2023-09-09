import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/data/models/daily_activity/daily_activity_student.dart';
import 'package:elogbook/src/presentation/blocs/clinical_record_cubit/clinical_record_cubit.dart';
import 'package:elogbook/src/presentation/blocs/daily_activity_cubit/daily_activity_cubit.dart';
import 'package:elogbook/src/presentation/features/supervisor/daily_activity/supervisor_daily_activity_perweek_page.dart';
import 'package:elogbook/src/presentation/widgets/custom_loading.dart';
import 'package:elogbook/src/presentation/widgets/dividers/item_divider.dart';
import 'package:elogbook/src/presentation/widgets/dividers/section_divider.dart';
import 'package:elogbook/src/presentation/widgets/headers/unit_header.dart';
import 'package:elogbook/src/presentation/widgets/headers/unit_student_header.dart';
import 'package:elogbook/src/presentation/widgets/inkwell_container.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:elogbook/src/presentation/widgets/spacing_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SupervisorDailyActivityDetailPage extends StatefulWidget {
  final DailyActivityStudent data;
  const SupervisorDailyActivityDetailPage({super.key, required this.data});

  @override
  State<SupervisorDailyActivityDetailPage> createState() =>
      _SupervisorDailyActivityDetailPageState();
}

class _SupervisorDailyActivityDetailPageState
    extends State<SupervisorDailyActivityDetailPage> {
  late ValueNotifier<bool> isVerify;
  @override
  void initState() {
    super.initState();
    if (widget.data.verificationStatus == 'VERIFIED') {
      isVerify = ValueNotifier(true);
    } else {
      isVerify = ValueNotifier(false);
    }
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
            isVerify.value = !isVerify.value;
            BlocProvider.of<DailyActivityCubit>(context)
              ..getDailyActivityStudentBySupervisor();
          }
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              SizedBox(
                height: 16,
              ),
              StudentDepartmentHeader(
                unitName: widget.data.unitName ?? '',
                studentName: widget.data.studentName ?? '',
                studentId: widget.data.studentId ?? '',
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
                child: ValueListenableBuilder(
                    valueListenable: isVerify,
                    builder: (context, val, _) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                            AssetPath.getIcon(
                                emoji[widget.data.activityStatus]!),
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
                                '${widget.data.day} (Week ${widget.data.weekNum})',
                                style: textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (val) ...[
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
                                widget.data.location ?? '',
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
                          Text('Activity', style: textTheme.bodyMedium),
                          Text(
                            widget.data.activityName ?? '',
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          ValueListenableBuilder(
                            valueListenable: isVerify,
                            builder: (context, value, child) {
                              if (value) {
                                return SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton(
                                    onPressed: () {
                                      BlocProvider.of<DailyActivityCubit>(
                                              context)
                                          .verifiyDailyActivityById(
                                              id: widget.data.id!,
                                              verifiedStatus: false);
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
                                      BlocProvider.of<DailyActivityCubit>(
                                              context)
                                          .verifiyDailyActivityById(
                                              id: widget.data.id!,
                                              verifiedStatus: true);
                                    },
                                    label: Text('Verify'),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
