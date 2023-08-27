import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/presentation/features/students/special_reports/widgets/special_report_card.dart';
import 'package:elogbook/src/presentation/features/supervisor/list_resident/widgets/head_resident_page.dart';
import 'package:elogbook/src/presentation/widgets/dividers/item_divider.dart';
import 'package:elogbook/src/presentation/widgets/inkwell_container.dart';
import 'package:flutter/material.dart';

class SpecialReportStudentPage extends StatefulWidget {
  const SpecialReportStudentPage({super.key});

  @override
  State<SpecialReportStudentPage> createState() =>
      _SpecialReportStudentPageState();
}

class _SpecialReportStudentPageState extends State<SpecialReportStudentPage> {
  late ScrollController _scrollController;
  final ValueNotifier<String> title = ValueNotifier('Entry Details');

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels < 160) {
        title.value = 'Entry Details';
      } else if (_scrollController.position.pixels >= 160) {
        title.value = 'H071191049';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            ...getHeadSection(title: title, subtitle: 'Special Reports'),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Text(
                      'List of Consultation on Encountered Issues',
                      style: textTheme.titleMedium?.copyWith(
                        height: 1.1,
                        color: secondaryColor,
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    ListView.separated(
                      itemBuilder: (context, index) {
                        return SpecialReportCard();
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          height: 12,
                        );
                      },
                      itemCount: 3,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
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
}

class SpecialReportCard extends StatelessWidget {
  const SpecialReportCard({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWellContainer(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      radius: 12,
      onTap: () {},
      color: Colors.white,
      boxShadow: [
        BoxShadow(
            offset: Offset(0, 0),
            spreadRadius: 0,
            blurRadius: 6,
            color: Color(0xFFD4D4D4).withOpacity(.25)),
        BoxShadow(
            offset: Offset(0, 4),
            spreadRadius: 0,
            blurRadius: 24,
            color: Color(0xFFD4D4D4).withOpacity(.25)),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Senin, 21 February 2023',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodyMedium?.copyWith(),
              ),
              Spacer(),
              if (true)
                SizedBox(
                  height: 45,
                  width: 45,
                  child: Center(
                    child: Icon(
                      Icons.edit,
                      size: 16,
                      color: secondaryTextColor,
                    ),
                  ),
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
          Text(
            'Encountered Problems',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodySmall?.copyWith(color: primaryColor),
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            'Saya merasa kesulitan dalam lorem ipsum test lorem ipsum test lorem ipsum test lorem ipsum test lorem ipsum test lorem ipsum test lorem ipsum lorem ips...',
            style: textTheme.bodyMedium?.copyWith(height: 1.2),
          ),
          SizedBox(
            height: 12,
          ),
          Text(
            'Provided Solutions',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodySmall?.copyWith(color: primaryColor),
          ),
          SizedBox(
            height: 4,
          ),
          false
              ? Text(
                  'Saya merasa kesulitan dalam lorem ipsum test lorem ipsum test lorem ipsum test lorem ipsum test lorem ipsum test lorem ipsum test lorem ipsum lorem ips...',
                  style: textTheme.bodyMedium?.copyWith(height: 1.2),
                )
              : Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      width: 1,
                      color: onFormDisableColor,
                      style: BorderStyle.solid,
                    ),
                  ),
                  padding: EdgeInsets.all(12),
                  child: Center(
                    child: Text(
                      'no solution provided yet',
                      style: textTheme.bodySmall?.copyWith(
                        color: secondaryTextColor,
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
