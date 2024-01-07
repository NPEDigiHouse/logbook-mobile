import 'package:core/context/navigation_extension.dart';
import 'package:core/helpers/asset_path.dart';
import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:supervisor/features/in_out_reporting/sections/check_in_students_page.dart';
import 'package:supervisor/features/in_out_reporting/sections/check_out_student_page.dart';
import 'in_out_history_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InOutReportingPage extends StatefulWidget {
  final List<String> departmentName;

  const InOutReportingPage({super.key, required this.departmentName});

  @override
  State<InOutReportingPage> createState() => _InOutReportingPageState();
}

class _InOutReportingPageState extends State<InOutReportingPage>
    with SingleTickerProviderStateMixin {
  late final List<Widget> _pages;
  late final TabController _tabController;

  @override
  void initState() {
    _pages = [
      const CheckInReportPage(
        title: 'Check In Reporting',
        iconQuarterTurns: 3,
      ),
      const CheckOutReportPage(
        title: 'Check Out Reporting',
        iconQuarterTurns: 1,
      ),
    ];
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return <Widget>[
              _headerSection(context),
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
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
      ),
    );
  }

  SliverToBoxAdapter _headerSection(BuildContext context) {
    return SliverToBoxAdapter(
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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(height: 12),
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
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: widget.departmentName.isEmpty
                                  ? borderColor.withOpacity(.7)
                                  : primaryColor.withOpacity(.7)),
                          child: Text(
                            widget.departmentName.isEmpty
                                ? 'No Department'
                                : widget.departmentName.first,
                            style: textTheme.bodySmall
                                ?.copyWith(color: scaffoldBackgroundColor),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      context.navigateTo(const InOutHistoryPage());
                    },
                    icon: const Icon(
                      Icons.history_rounded,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
