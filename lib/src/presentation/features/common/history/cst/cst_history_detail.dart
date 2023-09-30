import 'package:elogbook/core/helpers/app_size.dart';
import 'package:elogbook/core/helpers/utils.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/presentation/blocs/clinical_record_cubit/clinical_record_cubit.dart';
import 'package:elogbook/src/presentation/blocs/sgl_cst_cubit/sgl_cst_cubit.dart';
import 'package:elogbook/src/presentation/features/common/no_internet/check_internet_onetime.dart';
import 'package:elogbook/src/presentation/widgets/custom_loading.dart';
import 'package:elogbook/src/presentation/widgets/dividers/item_divider.dart';
import 'package:elogbook/src/presentation/widgets/headers/unit_student_header.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeline_tile/timeline_tile.dart';

class HistoryCstPage extends StatefulWidget {
  final String id;

  const HistoryCstPage({super.key, required this.id});

  @override
  State<HistoryCstPage> createState() => _HistoryCstPageState();
}

class _HistoryCstPageState extends State<HistoryCstPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<SglCstCubit>(context)..getCst(id: widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clinical Skill Training (CST)'),
      ),
      body: CheckInternetOnetime(child: (context) {
        return BlocBuilder<SglCstCubit, SglCstState>(
          builder: (context, state) {
            if (state.historyCstData != null)
              return CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    child: SingleChildScrollView(
                      child: SpacingColumn(
                        horizontalPadding: 16,
                        children: [
                          SizedBox(
                            height: 16,
                          ),
                          StudentDepartmentHeader(
                            unitName: state.historyCstData?.unitName ?? '...',
                            studentId: state.historyCstData?.studentId ?? '...',
                            studentName:
                                state.historyCstData?.studentName ?? '...',
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Container(
                            width: AppSize.getAppWidth(context),
                            padding: EdgeInsets.symmetric(
                                vertical: 16, horizontal: 20),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(.12),
                                  offset: Offset(0, 2),
                                  blurRadius: 20,
                                )
                              ],
                              borderRadius: BorderRadius.circular(12),
                              color: scaffoldBackgroundColor,
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'CST',
                                      style: textTheme.titleMedium?.copyWith(
                                        color: primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Icon(
                                      Icons.verified,
                                      color: successColor,
                                      size: 16,
                                    ),
                                  ],
                                ),
                                SizedBox(
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
                                        TextSpan(
                                          text: 'Supervisor:\t',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        TextSpan(
                                          text: state.historyCstData
                                                  ?.supervisorName ??
                                              '-',
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "(${Utils.epochToStringTime(startTime: state.historyCstData?.startTime!, endTime: state.historyCstData?.endTime)})",
                                      style: textTheme.bodyMedium
                                          ?.copyWith(color: primaryTextColor),
                                    ),
                                    SizedBox(
                                      width: 6,
                                    ),
                                    Text(
                                      Utils.datetimeToString(
                                          state.historyCstData!.createdAt!,
                                          format: 'EEE, dd MMM yyyy'),
                                      style: textTheme.bodyMedium
                                          ?.copyWith(color: primaryTextColor),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                ItemDivider(),
                                SizedBox(
                                  height: 8,
                                ),
                                for (int i = 0;
                                    i < state.historyCstData!.topic!.length;
                                    i++)
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
                                            color: successColor),
                                        child: Center(
                                            child: Icon(
                                          Icons.check,
                                          size: 14,
                                          color: Colors.white,
                                        )),
                                      ),
                                    ),
                                    afterLineStyle: LineStyle(
                                      thickness: 1,
                                      color: secondaryTextColor,
                                    ),
                                    beforeLineStyle: LineStyle(
                                      thickness: 1,
                                      color: secondaryTextColor,
                                    ),
                                    alignment: TimelineAlign.start,
                                    isFirst: i == 0,
                                    isLast: i ==
                                        state.historyCstData!.topic!.length - 1,
                                    endChild: Container(
                                      margin:
                                          EdgeInsets.only(left: 16, bottom: 12),
                                      child: Text(
                                        state.historyCstData!.topic![i]
                                            .topicName!
                                            .join(', '),
                                        style: textTheme.bodyMedium?.copyWith(
                                          height: 1.1,
                                        ),
                                      ),
                                    ),
                                  ),
                                SizedBox(
                                  height: 12,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              );
            else if (state.requestState == RequestState.loading) {
              return Center(child: CustomLoading());
            } else if (state.requestState == RequestState.error) {
              return Text('Error');
            }
            return SizedBox.shrink();
          },
        );
      }),
    );
  }
}
