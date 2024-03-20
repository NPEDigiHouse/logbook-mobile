import 'package:core/helpers/app_size.dart';
import 'package:core/helpers/utils.dart';
import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:data/models/sglcst/cst_model.dart';
import 'package:data/models/sglcst/topic_on_sglcst.dart';
import 'package:data/models/units/active_unit_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main/blocs/sgl_cst_cubit/sgl_cst_cubit.dart';
import 'package:main/widgets/custom_alert.dart';
import 'package:main/widgets/dividers/item_divider.dart';
import 'package:main/widgets/verify_dialog.dart';
import 'package:students/features/sgl_cst/widgets/add_topic_dialog.dart';
import 'package:students/features/sgl_cst/widgets/edit_sglcst_dialog.dart';
import 'package:timeline_tile/timeline_tile.dart';

class CstSubmissionCard extends StatelessWidget {
  const CstSubmissionCard({
    super.key,
    required this.data,
    required this.unitId,
    required this.activeDepartmentModel,
  });

  final Cst data;
  final ActiveDepartmentModel activeDepartmentModel;
  final String unitId;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSize.getAppWidth(context),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.12),
            offset: const Offset(0, 2),
            blurRadius: 20,
          )
        ],
        borderRadius: BorderRadius.circular(12),
        color: scaffoldBackgroundColor,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CST - ${Utils.datetimeToString(data.createdAt!, format: 'EEE, dd MMM yyyy')}',
                    style: textTheme.titleMedium?.copyWith(
                      color: secondaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    Utils.epochToStringTime(
                        startTime: data.startTime!, endTime: data.endTime),
                    style:
                        textTheme.bodyMedium?.copyWith(color: primaryTextColor),
                  ),
                ],
              ),
              if (data.verificationStatus == 'VERIFIED') ...[
                const SizedBox(
                  width: 4,
                ),
                const Column(
                  children: [
                    SizedBox(
                      height: 3,
                    ),
                    Icon(
                      Icons.verified,
                      color: primaryColor,
                      size: 16,
                    ),
                  ],
                )
              ],
              const Spacer(),
              if (data.verificationStatus != 'VERIFIED' &&
                  (activeDepartmentModel.checkOutTime == null ||
                      activeDepartmentModel.checkOutTime == 0))
                PopupMenuButton<String>(
                  icon: const Icon(
                    Icons.more_vert_rounded,
                  ),
                  onSelected: (value) {
                    if (value == 'Edit') {
                      showDialog(
                        context: context,
                        barrierLabel: '',
                        barrierDismissible: false,
                        builder: (_) => EditSglCstDialog(
                            date: data.createdAt ?? DateTime.now(),
                            type: TopicDialogType.cst,
                            id: data.cstId ?? '',
                            startTime: data.startTime ?? -1,
                            endTime: data.endTime ?? -1,
                            topics: data.topic ?? <Topic>[]),
                      );
                    }

                    if (value == 'Delete') {
                      showDialog(
                        context: context,
                        barrierLabel: '',
                        barrierDismissible: false,
                        builder: (_) => VerifyDialog(
                          onTap: () {
                            BlocProvider.of<SglCstCubit>(context)
                                .deleteCst(id: data.cstId ?? '');
                            Navigator.pop(context);
                          },
                        ),
                      );
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: 'Edit',
                        child: Text('Edit'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'Delete',
                        child: Text('Delete'),
                      ),
                    ];
                  },
                ),
            ],
          ),
          const SizedBox(
            height: 4,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: RichText(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                style: textTheme.bodySmall?.copyWith(
                  color: secondaryTextColor,
                ),
                children: <TextSpan>[
                  const TextSpan(
                    text: 'Supervisor:\t',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(
                    text: data.supervisorName ?? '-',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          for (int i = 0; i < data.topic!.length; i++)
            TimelineTile(
              indicatorStyle: IndicatorStyle(
                width: 14,
                height: 14,
                indicatorXY: 0.15,
                indicator: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: data.topic![i].verificationStatus == 'VERIFIED'
                        ? primaryColor
                        : secondaryTextColor,
                  ),
                  child: Center(
                    child: data.topic![i].verificationStatus == 'VERIFIED'
                        ? const Icon(
                            Icons.check,
                            size: 14,
                            color: Colors.white,
                          )
                        : null,
                  ),
                ),
              ),
              afterLineStyle: const LineStyle(
                thickness: 1,
                color: secondaryTextColor,
              ),
              beforeLineStyle: const LineStyle(
                thickness: 1,
                color: secondaryTextColor,
              ),
              alignment: TimelineAlign.start,
              isFirst: i == 0,
              isLast: i == data.topic!.length - 1,
              endChild: Container(
                margin: const EdgeInsets.only(left: 16, bottom: 12),
                child: Text(
                  data.topic![i].topicName!.join(', '),
                  style: textTheme.bodyMedium?.copyWith(
                    height: 1.1,
                  ),
                ),
              ),
            ),
          const SizedBox(
            height: 12,
          ),
          if (data.verificationStatus != 'VERIFIED') ...[
            const ItemDivider(),
            const SizedBox(
              height: 12,
            ),
            TextButton.icon(
              onPressed: () {
                if (activeDepartmentModel.checkOutTime != null &&
                    activeDepartmentModel.checkOutTime != 0) {
                  CustomAlert.error(
                      message: "already checkout for this department",
                      context: context);
                  return;
                }
                showDialog(
                  context: context,
                  barrierLabel: '',
                  barrierDismissible: false,
                  builder: (_) => AddTopicDialog(
                    type: TopicDialogType.cst,
                    date: data.createdAt!,
                    id: data.cstId!,
                    departmentId: unitId,
                    supervisorId: '',
                  ),
                );
              },
              icon: const Icon(Icons.add_rounded),
              label: Text(
                'Add Topic',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
