import 'package:elogbook/core/helpers/app_size.dart';
import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/core/helpers/reusable_function_helper.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/presentation/blocs/sgl_cst_cubit/sgl_cst_cubit.dart';
import 'package:elogbook/src/presentation/widgets/custom_loading.dart';
import 'package:elogbook/src/presentation/widgets/dividers/item_divider.dart';
import 'package:elogbook/src/presentation/widgets/headers/unit_student_header.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:timeline_tile/timeline_tile.dart';

class SupervisorSglDetailPage extends StatefulWidget {
  final String studentId;
  final String userId;
  final String studentName;
  final bool isCeu;
  final String? unitName;
  const SupervisorSglDetailPage(
      {super.key,
      required this.studentName,
      required this.studentId,
      required this.isCeu,
      this.unitName,
      required this.userId});

  @override
  State<SupervisorSglDetailPage> createState() =>
      _SupervisorSglDetailPageState();
}

class _SupervisorSglDetailPageState extends State<SupervisorSglDetailPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<SglCstCubit>(context)
      ..getStudentSglDetailById(studentId: widget.studentId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.wait([
            BlocProvider.of<SglCstCubit>(context)
                .getStudentSglDetailById(studentId: widget.studentId),
          ]);
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              snap: true,
              title: Text('Small Group Learning (SGL)'),
            ),
            BlocConsumer<SglCstCubit, SglCstState>(
              listener: (context, state) {
                if (state.isVerifyTopicSuccess ||
                    state.isVerifySglCstSuccess ||
                    state.isVerifyAllSglCstSuccess) {
                  BlocProvider.of<SglCstCubit>(context)
                    ..getStudentSglDetailById(studentId: widget.studentId);
                }
              },
              builder: (context, state) {
                if (state.sglDetail != null)
                  return SliverToBoxAdapter(
                    child: SpacingColumn(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      horizontalPadding: 16,
                      children: [
                        StudentDepartmentHeader(
                          unitName: widget.unitName ?? '...',
                          studentId: widget.studentId,
                          studentName: widget.studentName,
                        ),
                        ListView.separated(
                            shrinkWrap: true,
                            padding: EdgeInsets.only(top: 12),
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final data = state.sglDetail!.sgls![index];
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
                                        Text(
                                          'SGL #${state.sglDetail!.sgls!.length - index}',
                                          style:
                                              textTheme.titleMedium?.copyWith(
                                            color: primaryColor,
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
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: RichText(
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        text: TextSpan(
                                          style: textTheme.bodyMedium?.copyWith(
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
                                              text: data.supervisorName ?? '-',
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "(${ReusableFunctionHelper.epochToStringTime(startTime: data.startTime!, endTime: data.endTime)})",
                                          style: textTheme.bodyMedium?.copyWith(
                                              color: primaryTextColor),
                                        ),
                                        SizedBox(
                                          width: 6,
                                        ),
                                        Text(
                                          ReusableFunctionHelper
                                              .datetimeToString(data.createdAt!,
                                                  format: 'EEEE, dd MMM yyyy'),
                                          style: textTheme.bodyMedium?.copyWith(
                                              color: primaryTextColor),
                                        ),
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
                                              Builder(
                                                builder: (context) {
                                                  if (data.supervisorId ==
                                                          widget.userId &&
                                                      data.verificationStatus !=
                                                          'VERIFIED') {
                                                    if (data.topic![i]
                                                            .verificationStatus !=
                                                        'VERIFIED')
                                                      return FilledButton(
                                                        onPressed: () {
                                                          BlocProvider.of<
                                                                  SglCstCubit>(
                                                              context)
                                                            ..verifySglTopic(
                                                                topicId: data
                                                                    .topic![i]
                                                                    .id!,
                                                                status: true);
                                                        },
                                                        child: Text('Verify'),
                                                      );
                                                    else
                                                      return OutlinedButton(
                                                        onPressed: () {
                                                          BlocProvider.of<
                                                                  SglCstCubit>(
                                                              context)
                                                            ..verifySglTopic(
                                                                topicId: data
                                                                    .topic![i]
                                                                    .id!,
                                                                status: false);
                                                        },
                                                        child: Text('Cancel'),
                                                      );
                                                  }
                                                  return SizedBox.shrink();
                                                },
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
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Builder(
                                          builder: (context) {
                                            if (data.supervisorId ==
                                                    widget.userId &&
                                                data.verificationStatus !=
                                                    'VERIFIED') {
                                              if (data.topic?.indexWhere(
                                                      (element) =>
                                                          element
                                                              .verificationStatus !=
                                                          'VERIFIED') !=
                                                  -1) {
                                                return FilledButton(
                                                  onPressed: () {
                                                    BlocProvider.of<
                                                        SglCstCubit>(context)
                                                      ..verifyAllSglTopic(
                                                        topicId: data.sglId!,
                                                        status: true,
                                                      );
                                                  },
                                                  child: Text('Verify Topics'),
                                                );
                                              } else {
                                                return OutlinedButton(
                                                  onPressed: () {
                                                    BlocProvider.of<
                                                        SglCstCubit>(context)
                                                      ..verifyAllSglTopic(
                                                        topicId: data.sglId!,
                                                        status: false,
                                                      );
                                                  },
                                                  child: Text('Cancel All'),
                                                );
                                              }
                                            }
                                            return SizedBox.shrink();
                                          },
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        if (widget.isCeu &&
                                            data.verificationStatus !=
                                                'VERIFIED')
                                          FilledButton(
                                            style: FilledButton.styleFrom(
                                              backgroundColor: secondaryColor,
                                            ),
                                            onPressed: (data.topic?.indexWhere(
                                                        (element) =>
                                                            element
                                                                .verificationStatus !=
                                                            'VERIFIED') ==
                                                    -1)
                                                ? () {
                                                    BlocProvider.of<
                                                        SglCstCubit>(context)
                                                      ..verifySgl(
                                                        status: true,
                                                        sglId: data.sglId!,
                                                      );
                                                  }
                                                : null,
                                            child: Text('Verify SGL'),
                                          ),
                                        if (widget.isCeu &&
                                            data.verificationStatus ==
                                                'VERIFIED')
                                          FilledButton(
                                            style: FilledButton.styleFrom(
                                              backgroundColor: errorColor,
                                            ),
                                            onPressed: () {
                                              BlocProvider.of<SglCstCubit>(
                                                  context)
                                                ..verifySgl(
                                                  status: false,
                                                  sglId: data.sglId!,
                                                );
                                            },
                                            child: Text('Unverify SGL'),
                                          ),
                                      ],
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
                            itemCount: state.sglDetail!.sgls!.length),
                      ],
                    ),
                  );

                return SliverFillRemaining(child: CustomLoading());
              },
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
