import 'package:common/features/no_internet/check_internet_onetime.dart';
import 'package:core/context/navigation_extension.dart';
import 'package:core/helpers/app_size.dart';
import 'package:core/helpers/utils.dart';
import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:data/models/sglcst/topic_on_sglcst.dart';
import 'package:data/models/units/active_unit_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main/blocs/sgl_cst_cubit/sgl_cst_cubit.dart';
import 'package:main/widgets/custom_loading.dart';
import 'package:main/widgets/dividers/item_divider.dart';
import 'package:main/widgets/empty_data.dart';
import 'package:main/widgets/spacing_column.dart';
import 'package:main/widgets/verify_dialog.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'create_sgl_page.dart';
import 'widgets/add_topic_dialog.dart';
import 'widgets/edit_sglcst_dialog.dart';
import 'widgets/sgl_cst_app_bar.dart';

class ListSglPage extends StatefulWidget {
  final ActiveDepartmentModel activeDepartmentModel;

  const ListSglPage({super.key, required this.activeDepartmentModel});

  @override
  State<ListSglPage> createState() => _ListSglPageState();
}

class _ListSglPageState extends State<ListSglPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<SglCstCubit>(context).getStudentSglDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Small Group Learning (SGL)'),
      // ),
      body: CheckInternetOnetime(child: (context) {
        return RefreshIndicator(
          onRefresh: () async {
            await Future.wait(
                [BlocProvider.of<SglCstCubit>(context).getStudentSglDetail()]);
          },
          child: CustomScrollView(
            slivers: [
              // if (widget.activeDepartmentModel.countCheckIn! == 0)
              SglCstAppBar(
                title: 'Small Group Learning (SGL)',
                onBtnPressed: () {
                  context.navigateTo(
                    CreateSglPage(
                      model: widget.activeDepartmentModel,
                      date: DateTime.now(),
                    ),
                  );
                },
              ),
              // else
              //   SliverToBoxAdapter(
              //     child: SizedBox(
              //       height: 16,
              //     ),
              //   ),
              SliverFillRemaining(
                child: SingleChildScrollView(
                  child: SpacingColumn(
                    horizontalPadding: 16,
                    children: [
                      BlocConsumer<SglCstCubit, SglCstState>(
                        listener: (context, state) {
                          if (state.isSglDeleteSuccess ||
                              state.isSglEditSuccess) {
                            BlocProvider.of<SglCstCubit>(context)
                                .getStudentSglDetail();
                          }
                        },
                        builder: (context, state) {
                          if (state.sglDetail != null) {
                            if (state.sglDetail!.sgls!.isEmpty) {
                              return const EmptyData(
                                  title: 'No SGL Found',
                                  subtitle: 'There is no sgl data added yet');
                            }
                            return ListView.separated(
                                shrinkWrap: true,
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
                                              style: textTheme.titleMedium
                                                  ?.copyWith(
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
                                            ],
                                            const Spacer(),
                                            if (data.verificationStatus !=
                                                'VERIFIED')
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
                                                          date: data
                                                                  .createdAt ??
                                                              DateTime.now(),
                                                          type: TopicDialogType
                                                              .sgl,
                                                          id: data.sglId ?? '',
                                                          startTime:
                                                              data.startTime ??
                                                                  -1,
                                                          endTime:
                                                              data.endTime ??
                                                                  -1,
                                                          topics: data.topic ??
                                                              <Topic>[]),
                                                    );
                                                  }

                                                  if (value == 'Delete') {
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
                                                              .deleteSgl(
                                                                  id: data.sglId ??
                                                                      '');
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      ),
                                                    );
                                                  }
                                                },
                                                itemBuilder:
                                                    (BuildContext context) {
                                                  return <PopupMenuEntry<
                                                      String>>[
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
                                              style:
                                                  textTheme.bodySmall?.copyWith(
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
                                                  text: data.supervisorName ??
                                                      '-',
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "(${Utils.epochToStringTime(startTime: data.startTime!, endTime: data.endTime)})",
                                              style: textTheme.bodyMedium
                                                  ?.copyWith(
                                                      color: primaryTextColor),
                                            ),
                                            const SizedBox(
                                              width: 6,
                                            ),
                                            Text(
                                              Utils.datetimeToString(
                                                  data.createdAt!,
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
                                              child: Text(
                                                data.topic![i].topicName!
                                                    .join(', '),
                                                style: textTheme.bodyMedium
                                                    ?.copyWith(
                                                  height: 1.1,
                                                ),
                                              ),
                                            ),
                                          ),
                                        const SizedBox(
                                          height: 12,
                                        ),
                                        if (data.verificationStatus !=
                                            'VERIFIED') ...[
                                          const ItemDivider(),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          TextButton.icon(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                barrierLabel: '',
                                                barrierDismissible: false,
                                                builder: (_) => AddTopicDialog(
                                                  type: TopicDialogType.sgl,
                                                  date: data.createdAt!,
                                                  id: data.sglId!,
                                                  departmentId: widget
                                                          .activeDepartmentModel
                                                          .unitId ??
                                                      '',
                                                  supervisorId: '',
                                                ),
                                              );
                                            },
                                            icon: const Icon(Icons.add_rounded),
                                            label: Text(
                                              'Add Topic',
                                              style: textTheme.titleMedium
                                                  ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: primaryColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return const SizedBox(
                                    height: 16,
                                  );
                                },
                                itemCount: state.sglDetail!.sgls!.length);
                          }
                          return const SizedBox(
                              height: 300, child: CustomLoading());
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
