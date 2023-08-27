import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/presentation/features/head_section/in_out_reporting/check_report_page.dart';
import 'package:elogbook/src/presentation/features/head_section/in_out_reporting/dummy_models.dart';
import 'package:elogbook/src/presentation/widgets/inputs/search_field.dart';

class InOutReportingPage extends StatefulWidget {
  const InOutReportingPage({super.key});

  @override
  State<InOutReportingPage> createState() => _InOutReportingPageState();
}

class _InOutReportingPageState extends State<InOutReportingPage>
    with SingleTickerProviderStateMixin {
  late final List<Widget> _pages;
  late final ValueNotifier<String> _query;
  late final TabController _tabController;

  @override
  void initState() {
    _pages = [
      CheckReportPage(
        title: 'Check In Reporting',
        iconQuarterTurns: 3,
        students: students,
      ),
      const CheckReportPage(
        title: 'Check Out Reporting',
        iconQuarterTurns: 1,
        students: [],
      ),
    ];

    _query = ValueNotifier('');
    _tabController = TabController(length: 2, vsync: this);

    super.initState();
  }

  @override
  void dispose() {
    _query.dispose();
    _tabController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            SliverToBoxAdapter(
              child: SizedBox(
                width: double.infinity,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      right: 16,
                      top: 0,
                      child: SvgPicture.asset(
                        AssetPath.getVector('circle_bg4.svg'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SafeArea(
                            child: GestureDetector(
                              onTap: () => context.back(),
                              child: const Icon(
                                Icons.arrow_back_rounded,
                                color: primaryColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            'Verification',
                            style: textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: primaryColor,
                            ),
                          ),
                          Text(
                            'In-Out Reporting',
                            style: textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 14),
                          ValueListenableBuilder(
                            valueListenable: _query,
                            builder: (context, query, child) {
                              return SearchField(
                                text: query,
                                onChanged: (value) => _query.value = value,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverSafeArea(
                top: false,
                sliver: SliverAppBar(
                  elevation: 0,
                  forceElevated: innerBoxIsScrolled,
                  pinned: true,
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  surfaceTintColor: Colors.transparent,
                  systemOverlayStyle: const SystemUiOverlayStyle(
                    statusBarIconBrightness: Brightness.dark,
                  ),
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(0),
                    child: Container(
                      color: onDisableColor,
                      child: TabBar(
                        controller: _tabController,
                        dividerColor: Colors.transparent,
                        labelStyle: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        unselectedLabelStyle: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.normal,
                        ),
                        unselectedLabelColor: const Color(0xFF848FA9),
                        tabs: const <Tab>[
                          Tab(text: 'Check In'),
                          Tab(text: 'Check Out'),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: _pages,
        ),
      ),
    );
  }
}
