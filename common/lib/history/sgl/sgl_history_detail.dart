import 'package:core/helpers/app_size.dart';
import 'package:core/helpers/utils.dart';
import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:main/blocs/clinical_record_cubit/clinical_record_cubit.dart';
import 'package:main/blocs/sgl_cst_cubit/sgl_cst_cubit.dart';
import 'package:main/widgets/custom_loading.dart';
import 'package:main/widgets/dividers/item_divider.dart';
import 'package:main/widgets/headers/unit_student_header.dart';
import 'package:main/widgets/spacing_column.dart';

import '../../no_internet/check_internet_onetime.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeline_tile/timeline_tile.dart';

class HistorySglPage extends StatefulWidget {
  final String id;

  const HistorySglPage({super.key, required this.id});

  @override
  State<HistorySglPage> createState() => _HistorySglPageState();
}

class _HistorySglPageState extends State<HistorySglPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<SglCstCubit>(context).getSgl(id: widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Small Group Learning (SGL)'),
      ),
      body: CheckInternetOnetime(child: (context) {
        return BlocBuilder<SglCstCubit, SglCstState>(
          builder: (context, state) {
            if (state.historySglData != null) {
              return CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    child: SingleChildScrollView(
                      child: SpacingColumn(
                        horizontalPadding: 16,
                        children: [
                          const SizedBox(
                            height: 16,
                          ),
                          StudentDepartmentHeader(
                            unitName: state.historySglData?.unitName ?? '...',
                            studentId: state.historySglData?.studentId ?? '...',
                            studentName:
                                state.historySglData?.studentName ?? '...',
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Container(
                            width: AppSize.getAppWidth(context),
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 20),
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
                                  children: [
                                    Text(
                                      'SGL',
                                      style: textTheme.titleMedium?.copyWith(
                                        color: primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    const Icon(
                                      Icons.verified,
                                      color: successColor,
                                      size: 16,
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
                                          text: state.historySglData
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
                                      "(${Utils.epochToStringTime(startTime: state.historySglData?.startTime!, endTime: state.historySglData?.endTime)})",
                                      style: textTheme.bodyMedium
                                          ?.copyWith(color: primaryTextColor),
                                    ),
                                    const SizedBox(
                                      width: 6,
                                    ),
                                    Text(
                                      Utils.datetimeToString(
                                          state.historySglData!.createdAt!,
                                          format: 'EEE, dd MMM yyyy'),
                                      style: textTheme.bodyMedium
                                          ?.copyWith(color: primaryTextColor),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                const ItemDivider(),
                                const SizedBox(
                                  height: 8,
                                ),
                                for (int i = 0;
                                    i < state.historySglData!.topic!.length;
                                    i++)
                                  TimelineTile(
                                    indicatorStyle: IndicatorStyle(
                                      width: 14,
                                      height: 14,
                                      indicatorXY: 0.15,
                                      indicator: Container(
                                        width: 14,
                                        height: 14,
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: successColor),
                                        child: const Center(
                                            child: Icon(
                                          Icons.check,
                                          size: 14,
                                          color: Colors.white,
                                        )),
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
                                    isLast: i ==
                                        state.historySglData!.topic!.length - 1,
                                    endChild: Container(
                                      margin: const EdgeInsets.only(
                                          left: 16, bottom: 12),
                                      child: Text(
                                        state.historySglData!.topic![i]
                                            .topicName!
                                            .join(', '),
                                        style: textTheme.bodyMedium?.copyWith(
                                          height: 1.1,
                                        ),
                                      ),
                                    ),
                                  ),
                                const SizedBox(
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
            } else if (state.requestState == RequestState.loading) {
              return const Center(child: CustomLoading());
            } else if (state.requestState == RequestState.error) {
              return const Text('Error');
            }
            return const SizedBox.shrink();
          },
        );
      }),
    );
  }
}
