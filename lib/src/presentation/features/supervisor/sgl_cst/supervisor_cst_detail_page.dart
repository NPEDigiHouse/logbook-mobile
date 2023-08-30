import 'package:elogbook/core/helpers/app_size.dart';
import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/core/helpers/reusable_function_helper.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/presentation/blocs/sgl_cst_cubit/sgl_cst_cubit.dart';
import 'package:elogbook/src/presentation/widgets/dividers/item_divider.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:timeline_tile/timeline_tile.dart';

class SupervisorCstDetailPage extends StatefulWidget {
  final String studentId;
  final bool isCeu;
  const SupervisorCstDetailPage(
      {super.key, required this.studentId, required this.isCeu});

  @override
  State<SupervisorCstDetailPage> createState() =>
      _SupervisorCstDetailPageState();
}

class _SupervisorCstDetailPageState extends State<SupervisorCstDetailPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<SglCstCubit>(context)
      ..getStudentCstDetailById(studentId: widget.studentId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.wait([
            BlocProvider.of<SglCstCubit>(context)
                .getStudentCstDetailById(studentId: widget.studentId),
          ]);
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: Text('Clinical Skill Training (CST)'),
            ),
            SliverToBoxAdapter(
              child: SpacingColumn(
                horizontalPadding: 16,
                children: [
                  SizedBox(
                    height: 16,
                  ),
                  _buildAttendanceOverview(context),
                  BlocConsumer<SglCstCubit, SglCstState>(
                    listener: (context, state) {
                      if (state.isVerifyTopicSuccess ||
                          state.isVerifySglCstSuccess) {
                        BlocProvider.of<SglCstCubit>(context)
                          ..getStudentCstDetailById(
                              studentId: widget.studentId);
                      }
                    },
                    builder: (context, state) {
                      if (state.cstDetail != null)
                        return ListView.separated(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final data = state.cstDetail!.csts![index];
                              return Container(
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
                                        Icon(
                                          Icons.event_rounded,
                                          color: primaryColor,
                                        ),
                                        SizedBox(
                                          width: 12,
                                        ),
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Text(
                                                ReusableFunctionHelper
                                                    .datetimeToString(
                                                        data.createdAt!),
                                                style: textTheme.titleSmall
                                                    ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              if (data.verificationStatus ==
                                                  'VERIFIED') ...[
                                                SizedBox(
                                                  width: 4,
                                                ),
                                                Icon(
                                                  Icons.verified,
                                                  color: successColor,
                                                  size: 16,
                                                )
                                              ]
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
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
                                              color: data.topic![i]
                                                          .verificationStatus ==
                                                      'VERIFIED'
                                                  ? successColor
                                                  : secondaryTextColor,
                                            ),
                                            child: Center(
                                              child: data.topic![i]
                                                          .verificationStatus ==
                                                      'VERIFIED'
                                                  ? Icon(
                                                      Icons.check,
                                                      size: 14,
                                                      color: Colors.white,
                                                    )
                                                  : null,
                                            ),
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
                                        isLast: i == data.topic!.length - 1,
                                        endChild: Container(
                                          margin: EdgeInsets.only(
                                              left: 16, bottom: 12),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                data.topic![i].topicName!
                                                    .join(', '),
                                                style: textTheme.bodyMedium
                                                    ?.copyWith(
                                                  height: 1.1,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 4,
                                              ),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.av_timer_rounded,
                                                    color: onFormDisableColor,
                                                  ),
                                                  SizedBox(
                                                    width: 4,
                                                  ),
                                                  Text(
                                                    ReusableFunctionHelper
                                                        .epochToStringTime(
                                                            startTime: data
                                                                .topic![i]
                                                                .startTime!,
                                                            endTime: data
                                                                .topic![i]
                                                                .endTime),
                                                    style: textTheme.bodyMedium
                                                        ?.copyWith(
                                                            color:
                                                                onFormDisableColor),
                                                  ),
                                                ],
                                              ),
                                              if (data.topic![i]
                                                      .verificationStatus !=
                                                  'VERIFIED')
                                                FilledButton(
                                                  onPressed: () {
                                                    BlocProvider.of<
                                                        SglCstCubit>(context)
                                                      ..verifyCstTopic(
                                                          topicId: data
                                                              .topic![i].id!,
                                                          status: true);
                                                  },
                                                  child: Text('Verify'),
                                                )
                                              else
                                                OutlinedButton(
                                                  onPressed: () {
                                                    BlocProvider.of<
                                                        SglCstCubit>(context)
                                                      ..verifyCstTopic(
                                                          topicId: data
                                                              .topic![i].id!,
                                                          status: false);
                                                  },
                                                  child: Text('Cancel'),
                                                ),
                                              SizedBox(
                                                height: 12,
                                              ),
                                              ItemDivider(),
                                            ],
                                          ),
                                        ),
                                      ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    if (data.verificationStatus != 'VERIFIED' &&
                                        widget.isCeu)
                                      FilledButton(
                                        onPressed: () {
                                          BlocProvider.of<SglCstCubit>(context)
                                            ..verifyCst(
                                              cstId: data.cstId!,
                                            );
                                        },
                                        child: Text('Verify All Topics'),
                                      ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                  ],
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(
                                height: 16,
                              );
                            },
                            itemCount: state.cstDetail!.csts!.length);

                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 16,
              ),
            )
          ],
        ),
      ),
    );
  }

  Container _buildAttendanceOverview(BuildContext context) {
    return Container(
      width: AppSize.getAppWidth(context),
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
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
          Text(
            'Attendance Overview',
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFF6F7F8),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  height: 84,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: errorColor.withOpacity(
                            .2,
                          ),
                          shape: BoxShape.circle,
                        ),
                        padding: EdgeInsets.all(2),
                        child: SvgPicture.asset(
                          AssetPath.getIcon('emoji_alfa.svg'),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        '1',
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          height: 1,
                        ),
                      ),
                      Text('Tidak Hadir'),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFF6F7F8),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  height: 84,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(
                            .2,
                          ),
                          shape: BoxShape.circle,
                        ),
                        padding: EdgeInsets.all(2),
                        child: SvgPicture.asset(
                          AssetPath.getIcon('emoji_hadir.svg'),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        '1',
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          height: 1,
                        ),
                      ),
                      Text('Hadir'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
