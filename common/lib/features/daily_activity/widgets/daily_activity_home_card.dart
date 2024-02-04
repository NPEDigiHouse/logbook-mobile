import 'dart:ui';

import 'package:common/models/verified_status.dart';
import 'package:coordinator/features/daily_activity/update_status.dart';
import 'package:core/context/navigation_extension.dart';
import 'package:core/helpers/asset_path.dart';
import 'package:core/helpers/utils.dart';
import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:data/models/daily_activity/student_daily_activity_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:main/blocs/daily_activity_cubit/daily_activity_cubit.dart';
import 'package:main/widgets/inkwell_container.dart';
import 'package:main/widgets/spacing_row.dart';
import 'package:main/widgets/verify_dialog.dart';
import 'package:students/features/daily_activity/pages/daily_activity_week_status_page.dart';

class DailyActivityHomeCard extends StatelessWidget {
  final DailyActivity da;
  final DateTime startDate;
  final DateTime endDate;
  final DailyActivity? dailyActivity;
  final bool status;
  final bool isSupervisor;
  final bool isCoordinator;
  final String? studentId;
  final bool activeStatus;
  const DailyActivityHomeCard(
      {super.key,
      this.studentId,
      required this.status,
      this.isCoordinator = false,
      this.activeStatus = false,
      required this.isSupervisor,
      required this.endDate,
      required this.startDate,
      required this.da,
      this.dailyActivity});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InkWellContainer(
          padding: const EdgeInsets.all(16),
          radius: 12,
          onTap: isCoordinator ? null : () => onWeekTab(context),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                offset: const Offset(0, 0),
                spreadRadius: 0,
                blurRadius: 6,
                color: const Color(0xFFD4D4D4).withOpacity(.25)),
            BoxShadow(
              offset: const Offset(0, 4),
              spreadRadius: 0,
              blurRadius: 24,
              color: const Color(0xFFD4D4D4).withOpacity(.25),
            ),
          ],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isCoordinator ? _dailyActivityStatus() : _verifiedWeekStatus(),
              ..._header(),
              _listDailyAttendance(),
            ],
          ),
        ),
        if (DateTime.now().isBefore(startDate) &&
            !isSupervisor &&
            !isCoordinator)
          Positioned.fill(
            child: _lockedWeekLayer(),
          ),
      ],
    );
  }

  List<Widget> _header() {
    return [
      const SizedBox(
        height: 16,
      ),
      Text(
        'Week ${da.weekName}',
        style: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        Utils.epochToStringDate(
            startTime: da.startDate ?? 0, endTime: da.endDate),
        style: textTheme.bodyMedium?.copyWith(
          color: secondaryTextColor,
        ),
      ),
      const SizedBox(
        height: 16,
      ),
    ];
  }

  Builder _dailyActivityStatus() {
    return Builder(builder: (context) {
      bool active = !endDate.isBefore(DateTime.now());
      bool status = activeStatus || active;

      return Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 4,
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: status ? successColor : onFormDisableColor),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  status ? Icons.check : Icons.close,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(
                  width: 4,
                ),
                Text(
                  active
                      ? 'Active'
                      : status
                          ? 'Set Active'
                          : 'Not Active',
                  style: textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_vert_rounded,
            ),
            onSelected: (value) {
              if (!active && value == 'Change Status') {
                showDialog(
                  context: context,
                  barrierLabel: '',
                  barrierDismissible: false,
                  builder: (_) => UpdateStatusDialog(
                    status: status,
                    studentId: studentId ?? '',
                    id: da.dailyActivityId ?? '',
                    active: active,
                    weekNum: da.weekName ?? 1,
                  ),
                );
              }

              if (value == 'Delete') {
                showDialog(
                  context: context,
                  barrierLabel: '',
                  barrierDismissible: false,
                  builder: (_) => VerifyDialog(
                    onTap: () {
                      context
                          .read<DailyActivityCubit>()
                          .deleteDailyActivity(id: da.dailyActivityId!);
                      Navigator.pop(context);
                    },
                  ),
                );
              }
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<String>>[
                if (!active)
                  const PopupMenuItem<String>(
                    value: 'Change Status',
                    child: Text('Change Status'),
                  ),
                const PopupMenuItem<String>(
                  value: 'Delete',
                  child: Text('Delete'),
                ),
              ];
            },
          ),
        ],
      );
    });
  }

  Builder _verifiedWeekStatus() {
    return Builder(builder: (context) {
      VerifiedStatus status = VerifiedStatus.pending;
      if (Utils.getIntervalOfData(da.startDate, da.endDate) + 1 ==
          (dailyActivity == null
              ? 0
              : dailyActivity!.activitiesStatus!.length)) {
        status = VerifiedStatus.unverified;
        if (dailyActivity!.activitiesStatus!.indexWhere(
                (element) => element.verificationStatus != 'VERIFIED') ==
            -1) {
          status = VerifiedStatus.verified;
        }
      }
      return Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: status == VerifiedStatus.verified
                  ? successColor
                  : status == VerifiedStatus.unverified
                      ? secondaryColor
                      : onFormDisableColor,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  status == VerifiedStatus.verified
                      ? Icons.verified_rounded
                      : Icons.hourglass_bottom_rounded,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(
                  width: 4,
                ),
                Text(
                  Utils.capitalizeFirstLetter(status.name),
                  style: textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          const Icon(
            Icons.arrow_forward_ios_rounded,
          )
        ],
      );
    });
  }

  Builder _listDailyAttendance() {
    return Builder(builder: (context) {
      Map<String, String> emoji = {
        'ATTEND': 'emoji_hadir.svg',
        'SICK': 'sakit_emoji.svg',
        'NOT_ATTEND': 'emoji_alfa.svg',
        'HOLIDAY': 'icon_holiday.svg',
      };
      final List<ActivitiesStatus> listDays =
          dailyActivity?.activitiesStatus ?? [];

      return SpacingRow(
        onlyPading: true,
        spacing: 0,
        horizontalPadding: 12,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: listDays.map(
          (e) {
            bool isLateAttend = endDate.isBefore(
                  DateTime(
                    DateTime.now().year,
                    DateTime.now().month,
                    DateTime.now().day,
                  ),
                ) &&
                e.activityStatus == 'NOT_ATTEND';

            bool isUnsubmit = e.activityStatus == 'NOT_ATTEND';
            return Column(
              children: [
                Text(
                  (e.day ?? 'ERR').substring(0, 3),
                  style: textTheme.bodySmall,
                ),
                const SizedBox(
                  height: 4,
                ),
                if (isLateAttend)
                  _notAttendIcon(emoji)
                else if (isUnsubmit)
                  _unsubmitIcon()
                else
                  _attendanceIcon(emoji, e),
              ],
            );
          },
        ).toList(),
      );
    });
  }

  Widget _lockedWeekLayer() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[300]?.withOpacity(.4),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock_rounded,
                  size: 28,
                  color: primaryTextColor.withOpacity(.9),
                ),
                const SizedBox(
                  height: 6,
                ),
                Text(
                  'This week is still locked',
                  style: textTheme.bodyLarge?.copyWith(
                    color: primaryTextColor.withOpacity(.9),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _attendanceIcon(Map<String, String> emoji, ActivitiesStatus e) {
    return SvgPicture.asset(
      AssetPath.getIcon(emoji[e.activityStatus!]!),
      width: 30,
      height: 30,
      fit: BoxFit.cover,
    );
  }

  Widget _unsubmitIcon() {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: dividerColor,
        border: Border.all(
          strokeAlign: BorderSide.strokeAlignInside,
          width: 1,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _notAttendIcon(Map<String, String> emoji) {
    return SvgPicture.asset(
      AssetPath.getIcon(emoji['NOT_ATTEND']!),
      width: 30,
      height: 30,
      fit: BoxFit.cover,
    );
  }

  void onWeekTab(BuildContext context) {
    bool active = !endDate.isBefore(DateTime.now());
    bool status = activeStatus || active;
    context.navigateTo(
      DailyActivityWeekStatusPage(
        daId: da.dailyActivityId ?? '',
        isSupervisor: isSupervisor,
        weekName: da.weekName!,
        studentId: studentId,
        startDate: startDate,
        endDate: endDate,
        status: status ||
            (!endDate.isBefore(
              DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day,
              ),
            )),
      ),
    );
  }
}
