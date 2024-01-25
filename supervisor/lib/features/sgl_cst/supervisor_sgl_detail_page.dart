import 'package:core/helpers/app_size.dart';
import 'package:core/helpers/utils.dart';
import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main/blocs/sgl_cst_cubit/sgl_cst_cubit.dart';
import 'package:main/widgets/custom_loading.dart';
import 'package:main/widgets/dividers/item_divider.dart';
import 'package:main/widgets/empty_data.dart';
import 'package:main/widgets/headers/unit_student_header.dart';
import 'package:main/widgets/spacing_column.dart';
import 'package:main/widgets/verify_dialog.dart';
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
        .getStudentSglDetailById(studentId: widget.studentId);
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
            const SliverAppBar(
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
                      .getStudentSglDetailById(studentId: widget.studentId);
                }
              },
              builder: (context, state) {
                if (state.sglDetail != null && state.sglDetail?.sgls != null) {
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
                        if (state.sglDetail!.sgls!.isNotEmpty)
                          ListView.separated(
                              shrinkWrap: true,
                              padding: const EdgeInsets.only(top: 12),
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final data = state.sglDetail!.sgls![index];
                                return Container(
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
                                            'SGL #${state.sglDetail!.sgls![index].sglId?.substring(0, 5).toUpperCase()}',
                                            style:
                                                textTheme.titleMedium?.copyWith(
                                              color: primaryColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          if (data.verificationStatus ==
                                              'VERIFIED') ...[
                                            const SizedBox(
                                              width: 4,
                                            ),
                                            const Icon(
                                              Icons.verified,
                                              color: successColor,
                                              size: 16,
                                            )
                                          ]
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
                                            style:
                                                textTheme.bodyMedium?.copyWith(
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
                                                text:
                                                    data.supervisorName ?? '-',
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "(${Utils.epochToStringTime(startTime: data.startTime, endTime: data.endTime)})",
                                            style: textTheme.bodyMedium
                                                ?.copyWith(
                                                    color: primaryTextColor),
                                          ),
                                          const SizedBox(
                                            width: 6,
                                          ),
                                          Text(
                                            Utils.datetimeToString(
                                                data.createdAt ??
                                                    DateTime.now(),
                                                format: 'EEE, dd MMM yyyy'),
                                            style: textTheme.bodyMedium
                                                ?.copyWith(
                                                    color: primaryTextColor),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      if (data.topic != null)
                                        for (int i = 0;
                                            i < data.topic!.length;
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
                                              margin: const EdgeInsets.only(
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
                                                  const SizedBox(
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
                                                            'VERIFIED') {
                                                          return FilledButton(
                                                            onPressed: () {
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  barrierLabel:
                                                                      '',
                                                                  barrierDismissible:
                                                                      false,
                                                                  builder: (_) =>
                                                                      VerifyDialog(
                                                                        onTap:
                                                                            () {
                                                                          BlocProvider.of<SglCstCubit>(context).verifySglTopic(
                                                                              topicId: data.topic![i].id!,
                                                                              status: true);
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        isSubmit:
                                                                            true,
                                                                      ));
                                                            },
                                                            child: const Text(
                                                                'Verify'),
                                                          );
                                                        } else {
                                                          return OutlinedButton(
                                                            onPressed: () {
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  barrierLabel:
                                                                      '',
                                                                  barrierDismissible:
                                                                      false,
                                                                  builder: (_) =>
                                                                      VerifyDialog(
                                                                        onTap:
                                                                            () {
                                                                          BlocProvider.of<SglCstCubit>(context).verifySglTopic(
                                                                              topicId: data.topic![i].id!,
                                                                              status: false);
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        isSubmit:
                                                                            false,
                                                                      ));
                                                            },
                                                            child: const Text(
                                                                'Cancel'),
                                                          );
                                                        }
                                                      }
                                                      return const SizedBox
                                                          .shrink();
                                                    },
                                                  ),
                                                  const SizedBox(
                                                    height: 12,
                                                  ),
                                                  const ItemDivider(),
                                                ],
                                              ),
                                            ),
                                          ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
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
                                                      showDialog(
                                                          context: context,
                                                          barrierLabel: '',
                                                          barrierDismissible:
                                                              false,
                                                          builder:
                                                              (_) =>
                                                                  VerifyDialog(
                                                                    onTap: () {
                                                                      BlocProvider.of<SglCstCubit>(
                                                                              context)
                                                                          .verifyAllSglTopic(
                                                                        topicId:
                                                                            data.sglId!,
                                                                        status:
                                                                            true,
                                                                      );
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    isSubmit:
                                                                        true,
                                                                  ));
                                                    },
                                                    child: const Text(
                                                        'Verify All'),
                                                  );
                                                } else {
                                                  return OutlinedButton(
                                                    onPressed: () {
                                                      showDialog(
                                                          context: context,
                                                          barrierLabel: '',
                                                          barrierDismissible:
                                                              false,
                                                          builder:
                                                              (_) =>
                                                                  VerifyDialog(
                                                                    onTap: () {
                                                                      BlocProvider.of<SglCstCubit>(
                                                                              context)
                                                                          .verifyAllSglTopic(
                                                                        topicId:
                                                                            data.sglId!,
                                                                        status:
                                                                            false,
                                                                      );
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    isSubmit:
                                                                        false,
                                                                  ));
                                                    },
                                                    child: const Text(
                                                        'Cancel All'),
                                                  );
                                                }
                                              }
                                              return const SizedBox.shrink();
                                            },
                                          ),
                                          const SizedBox(
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
                                                      showDialog(
                                                          context: context,
                                                          barrierLabel: '',
                                                          barrierDismissible:
                                                              false,
                                                          builder:
                                                              (_) =>
                                                                  VerifyDialog(
                                                                    onTap: () {
                                                                      BlocProvider.of<SglCstCubit>(
                                                                              context)
                                                                          .verifySgl(
                                                                        status:
                                                                            true,
                                                                        sglId: data
                                                                            .sglId!,
                                                                      );
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    isSubmit:
                                                                        true,
                                                                  ));
                                                    }
                                                  : null,
                                              child: const Text('Verify SGL'),
                                            ),
                                          if (widget.isCeu &&
                                              data.verificationStatus ==
                                                  'VERIFIED')
                                            FilledButton(
                                              style: FilledButton.styleFrom(
                                                backgroundColor: errorColor,
                                              ),
                                              onPressed: () {
                                                showDialog(
                                                    context: context,
                                                    barrierLabel: '',
                                                    barrierDismissible: false,
                                                    builder: (_) =>
                                                        VerifyDialog(
                                                          onTap: () {
                                                            BlocProvider.of<
                                                                        SglCstCubit>(
                                                                    context)
                                                                .verifySgl(
                                                              status: false,
                                                              sglId:
                                                                  data.sglId ??
                                                                      '',
                                                            );
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          isSubmit: false,
                                                        ));
                                              },
                                              child: const Text('Unverify SGL'),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                    ],
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return const SizedBox(
                                  height: 16,
                                );
                              },
                              itemCount: state.sglDetail!.sgls!.length)
                        else
                          const EmptyData(
                            title: 'No SGL to Verify',
                            subtitle: 'all SGLs have been verified',
                          )
                      ],
                    ),
                  );
                }

                return const SliverFillRemaining(child: CustomLoading());
              },
            ),
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 16,
              ),
            )
          ],
        ),
      ),
    );
  }
}
