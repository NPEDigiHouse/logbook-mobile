import 'package:elogbook/core/helpers/app_size.dart';
import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/presentation/features/students/sgl_cst/create_cst_page.dart';
import 'package:elogbook/src/presentation/features/students/sgl_cst/widgets/add_topic_dialog.dart';
import 'package:elogbook/src/presentation/features/students/sgl_cst/widgets/sgl_cst_app_bar.dart';
import 'package:elogbook/src/presentation/features/students/sgl_cst/widgets/sgl_cst_data.dart';
import 'package:elogbook/src/presentation/widgets/dividers/item_divider.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:timeline_tile/timeline_tile.dart';

class ListCstPage extends StatefulWidget {
  const ListCstPage({super.key});

  @override
  State<ListCstPage> createState() => _ListCstPageState();
}

class _ListCstPageState extends State<ListCstPage> {
  final ValueNotifier<List<SglModel>> listSglData = ValueNotifier([]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SglCstAppBar(
            title: 'Clinical Skill Training (CST)',
            onBtnPressed: () {
              Navigator.push(context,
                      MaterialPageRoute(builder: (_) => CreateCstPage()))
                  .then((value) {
                listSglData.value = List.from(listSglData.value)
                  ..add(SglModel(date: 'Monday. Feb 26 2023', items: [
                    SglItemModel(
                      activity:
                          'Kelainan payudara (mastitis, cracked, inverted nipple) (4A), Fluor Albus, Vaginosis bakterialis (4A)',
                      time: '08.00 - 09.00 WITA',
                    )
                  ]));
              });
            },
          ),
          ValueListenableBuilder(
              valueListenable: listSglData,
              builder: (context, val, _) {
                return SliverToBoxAdapter(
                  child: SpacingColumn(
                    spacing: 16,
                    horizontalPadding: 16,
                    children: [
                      SizedBox(
                        height: 16,
                      ),
                      _buildAttendanceOverview(context),
                      for (SglModel sglModel in val)
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
                                  Icon(
                                    Icons.event_rounded,
                                    color: primaryColor,
                                  ),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  Expanded(
                                    child: Text(
                                      sglModel.date,
                                      style: textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              for (int i = 0; i < sglModel.items.length; i++)
                                TimelineTile(
                                  indicatorStyle: IndicatorStyle(
                                    width: 12,
                                    height: 12,
                                    color: primaryColor,
                                    indicatorXY: 0.15,
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
                                  isLast: i == sglModel.items.length - 1,
                                  endChild: Container(
                                    margin:
                                        EdgeInsets.only(left: 16, bottom: 12),
                                    child: Column(
                                      children: [
                                        Text(
                                          sglModel.items[i].activity,
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
                                              sglModel.items[i].time,
                                              style: textTheme.bodyMedium
                                                  ?.copyWith(
                                                      color:
                                                          onFormDisableColor),
                                            ),
                                          ],
                                        ),
                                      ],
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
                                onPressed: () {},
                                icon: Icon(Icons.add_rounded),
                                label: Text(
                                  'Add Topic',
                                  style: textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                );
              }),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 16,
            ),
          )
        ],
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
