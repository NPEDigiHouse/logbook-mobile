import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/presentation/widgets/inkwell_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ResidentMenuPage extends StatefulWidget {
  const ResidentMenuPage({super.key});

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
        title.value = 'H071191049';
      }
    });
  }

  final List<String> titleList = [
    'Detail Profile',
    'Special Report',
    'History',
    'Self Reflection',
    'Daily Activity'
  ];

  final List<String> iconPath = [
    'icon_detail_profile.svg',
    'icon_special_report.svg',
    'icon_history.svg',
    'icon_self_reflection.svg',
    'icon_daily_activity.svg',
  ];

  final List<VoidCallback> onTaps = [
    () {},
    () {},
    () {},
    () {},
    () {},
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
              iconTheme: IconThemeData(
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
                padding: EdgeInsets.symmetric(horizontal: 20),
                width: double.infinity,
                height: 160,
                decoration: BoxDecoration(color: primaryColor),
                child: Column(
                  children: [
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      width: 75,
                      height: 75,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage(
                            AssetPath.getImage('profile_default.png'),
                          ),
                        ),
                        border: Border.all(
                          width: 2,
                          color: scaffoldBackgroundColor,
                        ),
                      ),
                    ),
                    Text(
                      'Khairunnisa',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleLarge?.copyWith(
                        color: scaffoldBackgroundColor,
                      ),
                    ),
                    Text(
                      'H071191049',
                      style: textTheme.bodyMedium?.copyWith(
                        color: scaffoldBackgroundColor,
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 16,
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid.builder(
                itemCount: titleList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.3,
                  crossAxisSpacing: 16,
                ),
                itemBuilder: (context, index) {
                  return buildResidentMenuCard(
                    context: context,
                    iconPath: iconPath[index],
                    onTap: onTaps[index],
                    title: titleList[index],
                  );
                },
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 16,
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
  }) {
    return InkWellContainer(
      onTap: onTap,
      padding: EdgeInsets.all(12),
      color: scaffoldBackgroundColor,
      radius: 12,
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
          Container(
            width: 35,
            height: 35,
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: primaryColor,
            ),
            child: SvgPicture.asset(
              AssetPath.getIcon(iconPath),
              color: scaffoldBackgroundColor,
            ),
          ),
          SizedBox(
            height: 12,
          ),
          Text(
            title,
            style: textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Lorem Ipsum Libre',
            style: textTheme.bodySmall?.copyWith(
              color: secondaryTextColor,
            ),
          ),
        ],
      ),
    );
  }
}