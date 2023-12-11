import 'package:core/context/navigation_extension.dart';
import 'package:core/helpers/asset_path.dart';
import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:data/models/supervisors/supervisor_student_model.dart';
import 'package:main/widgets/inkwell_container.dart';

import 'daily_activity/daily_activity_student_page.dart';
import 'detail_profile/detail_profile_student_page.dart';
import 'self_reflection_student_page.dart/self_reflection_student_page.dart';
import 'special_report/special_report_student_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ResidentMenuPage extends StatefulWidget {
  final SupervisorStudent student;
  const ResidentMenuPage({super.key, required this.student});

  @override
  State<ResidentMenuPage> createState() => _ResidentMenuPageState();
}

class _ResidentMenuPageState extends State<ResidentMenuPage> {
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
        title.value = widget.student.studentId ?? '-';
      }
    });
  }

  final List<String> titleList = [
    'Detail Profile',
    'Problem Consultation',
    // 'History',
    'Self Reflection',
    'Daily Activity'
  ];

  final List<String> descList = [
    'Detail Profile of Student',
    'Problem Consultation',
    // 'History',
    'Self Reflection',
    'Daily Activity'
  ];

  final List<String> iconPath = [
    'icon_detail_profile.svg',
    'icon_special_report.svg',
    // 'icon_history.svg',
    'icon_self_reflection.svg',
    'icon_daily_activity.svg',
  ];

  List<VoidCallback> onTaps(BuildContext context) => [
        () => context.navigateTo(DetailProfileStudentPage(
              student: widget.student,
            )),
        () => context.navigateTo(SpecialReportStudentPage(
              student: widget.student,
            )),
        // () {},
        () => context.navigateTo(SelfReflectionStudentPage(
              student: widget.student,
            )),
        () => context.navigateTo(DailyActivityStudentPage(
              student: widget.student,
            )),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              pinned: true,
              backgroundColor: primaryColor,
              titleTextStyle: textTheme.titleMedium?.copyWith(
                color: scaffoldBackgroundColor,
              ),
              iconTheme: const IconThemeData(
                color: scaffoldBackgroundColor,
              ),
              title: ValueListenableBuilder(
                  valueListenable: title,
                  builder: (context, val, _) {
                    return Text(val);
                  }),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                width: double.infinity,
                height: 160,
                decoration: const BoxDecoration(color: primaryColor),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 16,
                    ),
                    Container(
                      width: 75,
                      height: 75,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: widget.student.profileImage == null
                            ? DecorationImage(
                                image: AssetImage(
                                  AssetPath.getImage('profile_default.png'),
                                ),
                                fit: BoxFit.cover,
                              )
                            : DecorationImage(
                                image: MemoryImage(
                                  widget.student.profileImage!,
                                ),
                                fit: BoxFit.cover,
                              ),
                        border: Border.all(
                          width: 2,
                          color: scaffoldBackgroundColor,
                        ),
                      ),
                    ),
                    Text(
                      widget.student.studentName ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleLarge?.copyWith(
                        color: scaffoldBackgroundColor,
                      ),
                    ),
                    Text(
                      widget.student.studentId ?? '',
                      style: textTheme.bodyMedium?.copyWith(
                        color: scaffoldBackgroundColor,
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 16,
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid.builder(
                itemCount: titleList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.15,
                  crossAxisSpacing: 16,
                ),
                itemBuilder: (context, index) {
                  return buildResidentMenuCard(
                    context: context,
                    desc: descList[index],
                    iconPath: iconPath[index],
                    onTap: onTaps(context)[index],
                    title: titleList[index],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildResidentMenuCard({
    required String title,
    required String iconPath,
    required VoidCallback onTap,
    required BuildContext context,
    required String desc,
  }) {
    return InkWellContainer(
      onTap: onTap,
      padding: const EdgeInsets.all(12),
      color: scaffoldBackgroundColor,
      radius: 12,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 35,
            height: 35,
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: primaryColor,
            ),
            child: SvgPicture.asset(
              AssetPath.getIcon(iconPath),
              color: scaffoldBackgroundColor,
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            title,
            style: textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          Text(
            desc,
            style: textTheme.bodySmall?.copyWith(
              color: secondaryTextColor,
            ),
          ),
        ],
      ),
    );
  }
}
