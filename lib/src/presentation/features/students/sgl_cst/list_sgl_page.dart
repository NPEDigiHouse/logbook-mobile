import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/helpers/app_size.dart';
import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/core/helpers/reusable_function_helper.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/data/models/units/active_unit_model.dart';
import 'package:elogbook/src/presentation/blocs/clinical_record_cubit/clinical_record_cubit.dart';
import 'package:elogbook/src/presentation/blocs/sgl_cst_cubit/sgl_cst_cubit.dart';
import 'package:elogbook/src/presentation/features/students/sgl_cst/create_sgl_page.dart';
import 'package:elogbook/src/presentation/features/students/sgl_cst/widgets/add_topic_dialog.dart';
import 'package:elogbook/src/presentation/features/students/sgl_cst/widgets/sgl_cst_app_bar.dart';
import 'package:elogbook/src/presentation/widgets/custom_loading.dart';
import 'package:elogbook/src/presentation/widgets/dividers/item_divider.dart';
import 'package:elogbook/src/presentation/widgets/empty_data.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:timeline_tile/timeline_tile.dart';

class ListSglPage extends StatefulWidget {
  final ActiveUnitModel activeUnitModel;

  const ListSglPage({super.key, required this.activeUnitModel});

  @override
  State<ListSglPage> createState() => _ListSglPageState();
}

class _ListSglPageState extends State<ListSglPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<SglCstCubit>(context)..getStudentSglDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (widget.activeUnitModel.countCheckIn! > 0)
          ? AppBar(
              title: Text('Small Group Learning (SGL)'),
            )
          : null,
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.wait(
              [BlocProvider.of<SglCstCubit>(context).getStudentSglDetail()]);
        },
        child: CustomScrollView(
          slivers: [
            if (widget.activeUnitModel.countCheckIn! == 0)
              SglCstAppBar(
                title: 'Small Group Learning (SGL)',
                onBtnPressed: () {
                  context.navigateTo(
                    CreateSglPage(
                      model: widget.activeUnitModel,
                    ),
                  );
                },
              ),
            SliverFillRemaining(
              child: SingleChildScrollView(
                child: SpacingColumn(
                  horizontalPadding: 16,
                  children: [
                    // SizedBox(
                    //   height: 16,
                    // ),
                    // _buildAttendanceOverview(context),
                    BlocBuilder<SglCstCubit, SglCstState>(
                      builder: (context, state) {
                        if (state.sglDetail != null) {
                          if (state.sglDetail!.sgls!.isEmpty) {
                            return EmptyData(
                                title: 'No SGL Found',
                                subtitle: 'There is no sgl data added yet');
                          }
                          return ListView.separated(
                              shrinkWrap: true,
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
                                            style:
                                                textTheme.bodySmall?.copyWith(
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
                                            "(${ReusableFunctionHelper.epochToStringTime(startTime: data.startTime!, endTime: data.endTime)})",
                                            style: textTheme.bodyMedium
                                                ?.copyWith(
                                                    color: primaryTextColor),
                                          ),
                                          SizedBox(
                                            width: 6,
                                          ),
                                          Text(
                                            ReusableFunctionHelper
                                                .datetimeToString(
                                                    data.createdAt!,
                                                    format:
                                                        'EEEE, dd MMM yyyy'),
                                            style: textTheme.bodyMedium
                                                ?.copyWith(
                                                    color: primaryTextColor),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
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
                                      SizedBox(
                                        height: 12,
                                      ),
                                      ItemDivider(),
                                      SizedBox(
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
                                              supervisorId: '',
                                            ),
                                          );
                                        },
                                        icon: Icon(Icons.add_rounded),
                                        label: Text(
                                          'Add Topic',
                                          style:
                                              textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: primaryColor,
                                          ),
                                        ),
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
                              itemCount: state.sglDetail!.sgls!.length);
                        }
                        return SizedBox(height: 300, child: CustomLoading());
                      },
                    ),
                    SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
            ),
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
