import 'package:core/context/navigation_extension.dart';
import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:data/models/assessment/personal_behavior_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main/blocs/assesment_cubit/assesment_cubit.dart';
import 'package:main/widgets/custom_loading.dart';
import 'package:main/widgets/dividers/section_divider.dart';
import 'package:main/widgets/empty_data.dart';
import 'package:main/widgets/spacing_column.dart';
import 'package:main/widgets/spacing_row.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:main/widgets/clip_donut_painter.dart';

class PersonalBehaviorDetailPage extends StatefulWidget {
  final PersonalBehaviorDetailModel pb;
  const PersonalBehaviorDetailPage({super.key, required this.pb});

  @override
  State<PersonalBehaviorDetailPage> createState() =>
      _PersonalBehaviorDetailPageState();
}

class _PersonalBehaviorDetailPageState
    extends State<PersonalBehaviorDetailPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Personal Behavior"),
      ).variant(),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.wait([
            BlocProvider.of<AssesmentCubit>(context)
                .getStudentPersonalBehavior(),
          ]);
        },
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              child: BlocBuilder<AssesmentCubit, AssesmentState>(
                builder: (context, state) {
                  if (state.personalBehaviorDetail != null) {
                    if (state.personalBehaviorDetail!.scores!.isNotEmpty) {
                      return SingleChildScrollView(
                        child: SpacingColumn(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          horizontalPadding: 16,
                          spacing: 12,
                          children: [
                            const SizedBox(
                              height: 16,
                            ),
                            TopStatCard(
                              title: 'Overview',
                              achivied: state.personalBehaviorDetail!.scores!
                                  .where(
                                    (element) =>
                                        element.verificationStatus ==
                                        'VERIFIED',
                                  )
                                  .toList(),
                              notAchivied: state.personalBehaviorDetail!.scores!
                                  .where(
                                    (element) =>
                                        element.verificationStatus ==
                                        'UNVERIFIED',
                                  )
                                  .toList(),
                              process: state.personalBehaviorDetail!.scores!
                                  .where(
                                    (element) =>
                                        element.verificationStatus ==
                                        'INPROCESS',
                                  )
                                  .toList(),
                            ),
                            ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return PersonalBehaviorCard(
                                    scoreData: state
                                        .personalBehaviorDetail!.scores![index],
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return const SizedBox(
                                    height: 12,
                                  );
                                },
                                itemCount: state
                                    .personalBehaviorDetail!.scores!.length),
                            const SizedBox(
                              height: 16,
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const EmptyData(
                          title: 'Empty Data',
                          subtitle: 'No Personal Bahavior Dat');
                    }
                  } else {
                    return const CustomLoading();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TopStatCard extends StatelessWidget {
  final String title;
  final List<Score> process;
  final List<Score> notAchivied;
  final List<Score> achivied;

  const TopStatCard({
    super.key,
    required this.title,
    required this.process,
    required this.notAchivied,
    required this.achivied,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(16),
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
              color: const Color(0xFFD4D4D4).withOpacity(.25)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          clipBehavior: Clip.antiAlias,
          children: [
            Positioned(
              bottom: 0,
              left: 8,
              child: CustomPaint(
                size: Size(
                    80,
                    (80 * 1.17)
                        .toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                painter: ClipDonutPainter(),
              ),
            ),
            Column(
              children: [
                const SizedBox(
                  height: 12,
                ),
                Text(
                  title,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                const SectionDivider(),
                const SizedBox(
                  height: 12,
                ),
                Builder(
                  builder: (context) {
                    Map<String, double> dataMap = {
                      "On Process": process.length.toDouble(),
                      "Achieved": achivied.length.toDouble(),
                      "Not Achieved": notAchivied.length.toDouble(),
                    };
                    final colorList = <Color>[
                      dividerColor,
                      primaryColor,
                      errorColor,
                    ];
                    return SpacingRow(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 12,
                      horizontalPadding: 32,
                      children: [
                        PieChart(
                          dataMap: dataMap,
                          animationDuration: const Duration(milliseconds: 800),
                          chartLegendSpacing: 32,
                          chartRadius: 100,
                          colorList: colorList,
                          initialAngleInDegree: 0,
                          chartType: ChartType.ring,
                          ringStrokeWidth: 20,
                          legendOptions: LegendOptions(
                            showLegendsInRow: false,
                            legendPosition: LegendPosition.right,
                            // legendShape: BoxShape.circle,
                            showLegends: false,
                            legendTextStyle: textTheme.bodySmall!,
                          ),
                          chartValuesOptions: const ChartValuesOptions(
                            showChartValueBackground: true,
                            showChartValues: false,
                            showChartValuesInPercentage: false,
                            showChartValuesOutside: false,
                            decimalPlaces: 1,
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        SpacingColumn(
                          spacing: 4,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...dataMap.entries.map((e) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    e.value.toString(),
                                    style: textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: e.key == 'On Process'
                                          ? Colors.grey
                                          : e.key == 'Achieved'
                                              ? primaryColor
                                              : errorColor,
                                    ),
                                  ),
                                  Text(
                                    e.key,
                                    style: textTheme.bodySmall?.copyWith(
                                      color: secondaryTextColor,
                                    ),
                                  )
                                ],
                              );
                            }).toList()
                          ],
                        )
                      ],
                    );
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PersonalBehaviorCard extends StatelessWidget {
  final Score scoreData;
  const PersonalBehaviorCard({super.key, required this.scoreData});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: <BoxShadow>[
          BoxShadow(
            offset: const Offset(0, 1),
            color: Colors.black.withOpacity(.06),
            blurRadius: 8,
          )
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          iconColor: primaryTextColor,
          collapsedIconColor: primaryTextColor,
          tilePadding: const EdgeInsets.only(
            left: 6,
            right: 10,
          ),
          childrenPadding: const EdgeInsets.fromLTRB(6, 8, 6, 16),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                scoreData.type ?? '',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 4,
              ),
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: scoreData.verificationStatus == 'VERIFIED'
                          ? primaryColor
                          : scoreData.verificationStatus == 'UNVERIFIED'
                              ? errorColor
                              : onFormDisableColor,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          scoreData.verificationStatus == 'VERIFIED'
                              ? Icons.check_circle
                              : scoreData.verificationStatus == 'UNVERIFIED'
                                  ? Icons.close_rounded
                                  : Icons.hourglass_bottom,
                          color: scaffoldBackgroundColor,
                          size: 16,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          scoreData.verificationStatus == 'VERIFIED'
                              ? 'Achieved'
                              : scoreData.verificationStatus == 'UNVERIFIED'
                                  ? 'Not Achieved'
                                  : 'ON PROCCESS',
                          style: textTheme.bodySmall?.copyWith(
                            color: scaffoldBackgroundColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(scoreData.name ?? ''),
            ),
          ],
        ),
      ),
    );
  }
}
